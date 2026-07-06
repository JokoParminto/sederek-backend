-- Migration 046: Add daily_limit to member_tier_rules + update min_price 15000 → 17000

BEGIN;

-- Add daily_limit column (null = unlimited)
ALTER TABLE member_tier_rules
  ADD COLUMN IF NOT EXISTS daily_limit INT NULL;

-- Update min_price threshold: 15000 → 17000
UPDATE member_tier_rules
SET min_price = 17000
WHERE min_price = 15000;

-- Set daily_limit = 2 for all existing rules (all tiers share 2 cup/day cap)
UPDATE member_tier_rules
SET daily_limit = 2;

COMMIT;
