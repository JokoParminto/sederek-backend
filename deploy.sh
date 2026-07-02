#!/bin/bash
# =============================================================================
# Sederek Kopi — Backend Deploy Script
# Usage: bash deploy.sh
# Fresh VPS: pastikan .env sudah diisi sebelum jalankan
# =============================================================================
set -e

APP_NAME="sederek-api"
APP_DIR="$(cd "$(dirname "$0")" && pwd)"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
info() { echo -e "${YELLOW}[..] $1${NC}"; }
fail() { echo -e "${RED}[!!] $1${NC}"; exit 1; }

echo ""
echo "============================================="
echo "  Sederek Kopi Backend Deploy"
echo "  Dir: $APP_DIR"
echo "============================================="

cd "$APP_DIR"

# ── 0. Git pull ───────────────────────────────────────────────────────────────
info "[0/6] Git pull latest code..."
git pull
ok "Code updated"

# ── 1. Cek .env ──────────────────────────────────────────────────────────────
info "Checking .env..."
if [ ! -f ".env" ]; then
  fail ".env tidak ditemukan! Copy .env.production ke .env dan isi: DB_HOST, DB_NAME, DB_USER, DB_PASSWORD, JWT_SECRET"
fi
ok ".env found"

# Pastikan NODE_ENV=production
if ! grep -q "NODE_ENV=production" .env; then
  echo "NODE_ENV=production" >> .env
  ok "Added NODE_ENV=production to .env"
fi

# Load DB vars dari .env
DB_HOST=$(grep '^DB_HOST=' .env | cut -d= -f2)
DB_PORT=$(grep '^DB_PORT=' .env | cut -d= -f2 || echo '5432')
DB_NAME=$(grep '^DB_NAME=' .env | cut -d= -f2)
DB_USER=$(grep '^DB_USER=' .env | cut -d= -f2)
DB_PASS=$(grep '^DB_PASSWORD=' .env | cut -d= -f2)

# ── 2. Check Node & PM2 ──────────────────────────────────────────────────────
info "Checking Node.js..."
NODE_VER=$(node -v 2>/dev/null) || fail "Node.js tidak terinstall. Install: curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs"
ok "Node $NODE_VER"

if ! command -v pm2 &>/dev/null; then
  info "PM2 tidak ditemukan, install..."
  npm install -g pm2
  ok "PM2 installed"
else
  ok "PM2 $(pm2 -v)"
fi

# ── 3. Auto-create database jika belum ada ───────────────────────────────────
echo ""
info "[1/6] Checking database..."
DB_EXISTS=$(PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -tAc \
  "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" postgres 2>/dev/null || echo "")

if [ "$DB_EXISTS" != "1" ]; then
  info "Database '$DB_NAME' belum ada, membuat..."
  PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c \
    "CREATE DATABASE \"$DB_NAME\" OWNER \"$DB_USER\";" postgres \
    || fail "Gagal buat database. Pastikan user '$DB_USER' punya privilege CREATEDB. Jalankan: ALTER USER $DB_USER CREATEDB;"
  ok "Database '$DB_NAME' berhasil dibuat"
else
  ok "Database '$DB_NAME' sudah ada"
fi

# ── 4. npm install ───────────────────────────────────────────────────────────
echo ""
info "[2/6] npm install..."
npm install --production=false
ok "Dependencies installed"

# ── 5. Build TypeScript ──────────────────────────────────────────────────────
echo ""
info "[3/6] Building TypeScript..."
npm run build
ok "Build complete → dist/"

mkdir -p uploads logs
ok "uploads/ dan logs/ directory ready"

# ── 6. Run migrations ────────────────────────────────────────────────────────
echo ""
info "[4/6] Running database migrations..."
npm run migrate
ok "Migrations done"

# ── 7. Seed base data ────────────────────────────────────────────────────────
echo ""
info "[5/6] Seeding base data..."
SEED_FILE="$APP_DIR/src/database/seed_base.sql"
if [ -f "$SEED_FILE" ]; then
  PGPASSWORD="$DB_PASS" psql \
    -h "$DB_HOST" -p "$DB_PORT" \
    -U "$DB_USER" -d "$DB_NAME" \
    -f "$SEED_FILE" -v ON_ERROR_STOP=0 \
    2>&1 | grep -v "^SET\|^BEGIN\|^COMMIT" || true
  ok "Base data seeded (ON CONFLICT DO NOTHING — aman re-run)"
else
  info "seed_base.sql tidak ditemukan, skip seed"
fi

# ── 8. PM2 start / reload ────────────────────────────────────────────────────
echo ""
info "[6/6] Starting server via PM2..."
if pm2 list | grep -q "$APP_NAME"; then
  pm2 reload ecosystem.config.js --env production
  ok "PM2 reloaded (zero-downtime): $APP_NAME"
else
  pm2 start ecosystem.config.js --env production
  ok "PM2 started: $APP_NAME"
fi

# ── 9. Balance CPU — scale pos-jagad-api ke 2 jika running ──────────────────
if pm2 list | grep -q "pos-jagad-api"; then
  pm2 scale pos-jagad-api 2
  ok "pos-jagad-api scaled → 2 instances (share 4 cores equally)"
fi

pm2 save --force

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "============================================="
echo -e "  ${GREEN}Deploy selesai!${NC}"
echo "============================================="
echo ""
echo "App    : $APP_NAME"
echo "Port   : $(grep '^PORT=' .env | cut -d= -f2 || echo '3000')"
echo "DB     : $DB_NAME @ $DB_HOST:$DB_PORT"
echo ""
pm2 status "$APP_NAME"
echo ""
echo "Log    : pm2 logs $APP_NAME"
echo "Stop   : pm2 stop $APP_NAME"
echo "Redeploy: bash deploy.sh"
