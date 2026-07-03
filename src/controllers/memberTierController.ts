import { Request, Response, NextFunction } from 'express'
import { pool } from '../config/database'
import { successResponse } from '../utils/response'
import { AppError } from '../middleware/errorHandler'

/**
 * GET /api/v1/member-tier-rules
 * Semua rules beserta produk yang terlampir
 */
export const getRules = async (_req: Request, res: Response, next: NextFunction) => {
  try {
    const rulesResult = await pool.query(
      `SELECT r.*,
              COALESCE(
                json_agg(
                  json_build_object('id', p.id, 'name', p.name)
                  ORDER BY p.name
                ) FILTER (WHERE p.id IS NOT NULL),
                '[]'
              ) AS products
       FROM member_tier_rules r
       LEFT JOIN member_tier_rule_products rp ON r.id = rp.rule_id
       LEFT JOIN products p ON rp.product_id = p.id
       GROUP BY r.id
       ORDER BY r.tier, r.sort_order, r.created_at`
    )
    res.json(successResponse(rulesResult.rows, 'Member tier rules fetched'))
  } catch (e) { next(e) }
}

/**
 * POST /api/v1/member-tier-rules
 */
export const createRule = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { tier, label, rule_type, scope, min_price, discount_amount, fixed_price, sort_order, is_active } = req.body

    if (!tier || !label || !rule_type || !scope) {
      throw new AppError('VALIDATION_ERROR', 'tier, label, rule_type, scope wajib diisi', 400)
    }
    if (rule_type === 'discount_amount' && !discount_amount) {
      throw new AppError('VALIDATION_ERROR', 'discount_amount wajib untuk tipe discount_amount', 400)
    }
    if (rule_type === 'fixed_price' && !fixed_price) {
      throw new AppError('VALIDATION_ERROR', 'fixed_price wajib untuk tipe fixed_price', 400)
    }

    const result = await pool.query(
      `INSERT INTO member_tier_rules
         (tier, label, rule_type, scope, min_price, discount_amount, fixed_price, sort_order, is_active)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)
       RETURNING *`,
      [tier, label, rule_type, scope,
       min_price || null, discount_amount || null, fixed_price || null,
       sort_order ?? 0, is_active ?? true]
    )
    res.json(successResponse(result.rows[0], 'Rule dibuat'))
  } catch (e) { next(e) }
}

/**
 * PUT /api/v1/member-tier-rules/:id
 */
export const updateRule = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params
    const { tier, label, rule_type, scope, min_price, discount_amount, fixed_price, sort_order, is_active } = req.body

    const result = await pool.query(
      `UPDATE member_tier_rules
       SET tier            = COALESCE($1, tier),
           label           = COALESCE($2, label),
           rule_type       = COALESCE($3, rule_type),
           scope           = COALESCE($4, scope),
           min_price       = $5,
           discount_amount = $6,
           fixed_price     = $7,
           sort_order      = COALESCE($8, sort_order),
           is_active       = COALESCE($9, is_active),
           updated_at      = NOW()
       WHERE id = $10
       RETURNING *`,
      [tier, label, rule_type, scope,
       min_price ?? null, discount_amount ?? null, fixed_price ?? null,
       sort_order, is_active, id]
    )
    if (!result.rows.length) throw new AppError('NOT_FOUND', 'Rule tidak ditemukan', 404)
    res.json(successResponse(result.rows[0], 'Rule diupdate'))
  } catch (e) { next(e) }
}

/**
 * DELETE /api/v1/member-tier-rules/:id
 */
export const deleteRule = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params
    const result = await pool.query('DELETE FROM member_tier_rules WHERE id = $1 RETURNING id', [id])
    if (!result.rows.length) throw new AppError('NOT_FOUND', 'Rule tidak ditemukan', 404)
    res.json(successResponse(null, 'Rule dihapus'))
  } catch (e) { next(e) }
}

/**
 * POST /api/v1/member-tier-rules/:id/products
 * Body: { product_ids: string[] }
 * Ganti semua linked products untuk rule ini
 */
export const setRuleProducts = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params
    const { product_ids = [] } = req.body

    const client = await pool.connect()
    try {
      await client.query('BEGIN')
      await client.query('DELETE FROM member_tier_rule_products WHERE rule_id = $1', [id])
      for (const pid of product_ids) {
        await client.query(
          'INSERT INTO member_tier_rule_products (rule_id, product_id) VALUES ($1, $2) ON CONFLICT DO NOTHING',
          [id, pid]
        )
      }
      await client.query('COMMIT')
    } catch (e) {
      await client.query('ROLLBACK')
      throw e
    } finally {
      client.release()
    }

    res.json(successResponse(null, 'Produk rule diupdate'))
  } catch (e) { next(e) }
}
