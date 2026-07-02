-- Migration 044: Hapus semua addons untuk produk kategori Food
-- Dijalankan SEKALI saja berkat schema_migrations tracking.
-- Addons yang ditambah manual setelah migration ini aman.

BEGIN;

DELETE FROM product_addons
WHERE product_id IN (
  SELECT p.id
  FROM products p
  JOIN categories c ON p.category_id = c.id
  WHERE c.name = 'Food'
);

COMMIT;
