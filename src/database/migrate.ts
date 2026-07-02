import fs from 'fs'
import path from 'path'
import { Pool } from 'pg'
import { config } from '../config/env'

const pool = new Pool({
  host: config.database.host,
  port: config.database.port,
  database: config.database.name,
  user: config.database.user,
  password: config.database.password,
})

async function runMigrations() {
  const client = await pool.connect()
  try {
    console.log('🚀 Starting migrations...')

    // Buat tracking table jika belum ada
    await client.query(`
      CREATE TABLE IF NOT EXISTS schema_migrations (
        filename   TEXT PRIMARY KEY,
        applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
      )
    `)

    const migrationsDir = path.join(__dirname, '..', '..', 'src', 'database', 'migrations')
    const migrationFiles = fs
      .readdirSync(migrationsDir)
      .filter((file) => file.endsWith('.sql'))
      .sort()

    // Ambil daftar migration yg sudah jalan
    const { rows } = await client.query('SELECT filename FROM schema_migrations')
    const applied = new Set(rows.map((r: { filename: string }) => r.filename))

    let skipped = 0
    for (const file of migrationFiles) {
      if (applied.has(file)) {
        console.log(`⏭️  Skipped (already applied): ${file}`)
        skipped++
        continue
      }

      const filePath = path.join(migrationsDir, file)
      const sql = fs.readFileSync(filePath, 'utf-8')

      console.log(`⏳ Running migration: ${file}`)
      try {
        await client.query(sql)
        await client.query('INSERT INTO schema_migrations (filename) VALUES ($1)', [file])
        console.log(`✅ Completed: ${file}`)
      } catch (error) {
        console.error(`❌ Error in migration ${file}:`, error)
        throw error
      }
    }

    console.log(`✨ Migrations done. Applied: ${migrationFiles.length - skipped}, Skipped: ${skipped}`)
  } catch (error) {
    console.error('❌ Migration failed:', error)
    process.exit(1)
  } finally {
    await client.release()
    await pool.end()
  }
}

runMigrations()
