-- Migration 045: Member tier system
-- Replaces single member_price with dynamic per-tier rules

BEGIN;

-- Add tier + status to customers (keep is_member for backward compat)
ALTER TABLE customers
  ADD COLUMN IF NOT EXISTS member_type  VARCHAR(20)
    CHECK (member_type IN ('umum', 'akamsi', 'vip')),
  ADD COLUMN IF NOT EXISTS member_status VARCHAR(20) NOT NULL DEFAULT 'inactive'
    CHECK (member_status IN ('active', 'pending', 'inactive'));

-- Migrate existing members: assign 'umum' tier, keep status
UPDATE customers
  SET member_type   = 'umum',
      member_status = 'active'
WHERE is_member = TRUE;

-- Tier rules master table
CREATE TABLE IF NOT EXISTS member_tier_rules (
  id             UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  tier           VARCHAR(20) NOT NULL CHECK (tier IN ('umum', 'akamsi', 'vip')),
  label          VARCHAR(120) NOT NULL,
  rule_type      VARCHAR(20) NOT NULL CHECK (rule_type IN ('discount_amount', 'fixed_price')),
  scope          VARCHAR(20) NOT NULL DEFAULT 'non_food'
                   CHECK (scope IN ('all', 'non_food', 'specific')),
  min_price      DECIMAL(15,2),        -- applies only if product price >= min_price
  discount_amount DECIMAL(15,2),       -- for rule_type = discount_amount
  fixed_price    DECIMAL(15,2),        -- for rule_type = fixed_price
  sort_order     INT NOT NULL DEFAULT 0,
  is_active      BOOLEAN NOT NULL DEFAULT TRUE,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Products linked to a specific rule (only for scope = 'specific')
CREATE TABLE IF NOT EXISTS member_tier_rule_products (
  rule_id    UUID REFERENCES member_tier_rules(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  PRIMARY KEY (rule_id, product_id)
);

-- Seed default rules (skema awal, bisa diubah via admin UI)
INSERT INTO member_tier_rules (tier, label, rule_type, scope, min_price, discount_amount, sort_order)
VALUES
  ('umum',   'Potongan Rp2.000 semua minuman harga > 15k', 'discount_amount', 'non_food', 15000, 2000, 1),
  ('akamsi', 'Potongan Rp2.000 semua minuman harga > 15k', 'discount_amount', 'non_food', 15000, 2000, 1),
  ('akamsi', 'Potongan Rp2.000 menu pilihan (Red Velvet, Kopsu Original)', 'discount_amount', 'specific', NULL, 2000, 2),
  ('vip',    'Potongan Rp2.000 semua minuman harga > 15k', 'discount_amount', 'non_food', 15000, 2000, 1),
  ('vip',    'Potongan Rp2.000 menu pilihan (Red Velvet, Kopsu Original)', 'discount_amount', 'specific', NULL, 2000, 2),
  ('vip',    'Harga khusus Rp13.000 Es Kopi Susu', 'fixed_price', 'specific', NULL, NULL, 3);

-- Note: specific-scope rules need product links set via admin UI after migration
-- (products may have different IDs per environment)

COMMIT;
