BEGIN;

ALTER TABLE transaction_items
  ADD COLUMN IF NOT EXISTS member_priced_quantity INTEGER NOT NULL DEFAULT 0;

UPDATE transaction_items
SET member_priced_quantity = quantity
WHERE is_member_price = TRUE
  AND member_priced_quantity = 0;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint c
    JOIN pg_class t ON t.oid = c.conrelid
    JOIN pg_namespace n ON n.oid = t.relnamespace
    WHERE c.conname = 'transaction_items_member_priced_quantity_check'
      AND t.relname = 'transaction_items'
      AND n.nspname = current_schema()
  ) THEN
    ALTER TABLE transaction_items
      ADD CONSTRAINT transaction_items_member_priced_quantity_check
      CHECK (
        member_priced_quantity >= 0
        AND member_priced_quantity <= quantity
      );
  END IF;
END $$;

COMMENT ON COLUMN transaction_items.member_priced_quantity
  IS 'Quantity on this line that consumed member pricing quota';

COMMIT;
