-- Migration 042: Seed menu Sederek Kopi
-- Idempotent: ON CONFLICT DO NOTHING untuk kategori, WHERE NOT EXISTS untuk produk
-- Sumber: menu.jpeg

BEGIN;

-- ── 0. HAPUS DATA JAGAD COFFEE (cleanup rebranding) ──────────────────────────
-- Hapus product_addons Jagad (hanya yang linked ke produk Jagad)
DELETE FROM product_addons
WHERE product_id IN (
  SELECT id FROM products
  WHERE name IN (
    'Aren Latte','Salted Caramel Latte','Latte','Hazelnut Latte','Strawberry Latte',
    'Cappuccino','Americano','Americano Arabica','Lemon Black',
    'Cokelat susu','Taro Susu','Red Velvet',
    'Summer Passion','Berry Twist','Summer Lychee','Matcha Latte','Sunny Lemon'
  )
);
-- Hapus produk Jagad
DELETE FROM products
WHERE name IN (
  'Aren Latte','Salted Caramel Latte','Latte','Hazelnut Latte','Strawberry Latte',
  'Cappuccino','Americano','Americano Arabica','Lemon Black',
  'Cokelat susu','Taro Susu','Red Velvet',
  'Summer Passion','Berry Twist','Summer Lychee','Matcha Latte','Sunny Lemon'
);
-- Hapus kategori Jagad
DELETE FROM categories
WHERE name IN ('Signature Latte','Esspresso Based','Coffee Mocktail','Non Coffee');

-- ── 1. KATEGORI SEDEREK ────────────────────────────────────────────────────────

INSERT INTO categories (name, description, icon, sort_order, status) VALUES
  ('Kopi Susu',      'Espresso based dengan susu',         '☕', 1, 'active'),
  ('Non-Coffee',     'Minuman non-kopi',                   '🥤', 2, 'active'),
  ('Hot Latte',      'Minuman panas latte',                '🔥', 3, 'active'),
  ('Black Coffee',   'Kopi hitam tanpa susu',              '☕', 4, 'active'),
  ('Moktail Coffee', 'Minuman kopi kreatif moktail style', '🍹', 5, 'active'),
  ('Food',           'Makanan',                            '🍟', 6, 'active')
ON CONFLICT (name) DO NOTHING;

-- ── 2. PRODUK ─────────────────────────────────────────────────────────────────
-- Pakai WHERE NOT EXISTS agar aman re-run (produk tidak punya unique constraint di name)

-- KOPI SUSU
INSERT INTO products (category_id, name, price, hpp, member_price, image_url, stock, status)
SELECT cat.id, p.name, p.price, 0, NULL, NULL, 10000, 'active'
FROM (VALUES
  ('ESKA Kopsu Ice',    17000),
  ('Dyrti',             17000),
  ('Butterscoth',       17000),
  ('Savana Kopsu Ice',  17000),
  ('Avocado Kopsu Ice', 15000),
  ('Caramel Kopsu Ice', 15000),
  ('Pandan Wangi',      13000),
  ('Vanila Kopsu Ice',  13000),
  ('Kopsu Original',    12000)
) AS p(name, price)
JOIN categories cat ON cat.name = 'Kopi Susu'
WHERE NOT EXISTS (SELECT 1 FROM products WHERE products.name = p.name);

-- NON-COFFEE
-- Coklat/Coklat Manja 10K/15K → 2 produk beda harga
-- Tea/Lychee Tea 5K/10K → 2 produk beda harga
-- Lemon/Lemon Tea 7K → 1 produk (harga sama)
INSERT INTO products (category_id, name, price, hpp, member_price, image_url, stock, status)
SELECT cat.id, p.name, p.price, 0, NULL, NULL, 10000, 'active'
FROM (VALUES
  ('Matcha Latte Ice',   15000),
  ('Taro Full Cream',    15000),
  ('Red Velvet Ice',     12000),
  ('Ocean Blue',         12000),
  ('Coklat',             10000),
  ('Coklat Manja',       15000),
  ('Tea',                 5000),
  ('Lychee Tea',         10000),
  ('Lemon / Lemon Tea',   7000),
  ('Wedang Ndoro',        8000)
) AS p(name, price)
JOIN categories cat ON cat.name = 'Non-Coffee'
WHERE NOT EXISTS (SELECT 1 FROM products WHERE products.name = p.name);

-- HOT LATTE
-- Coffee/Coklat/Red velvet latte 15K → 3 produk beda nama, harga sama
INSERT INTO products (category_id, name, price, hpp, member_price, image_url, stock, status)
SELECT cat.id, p.name, p.price, 0, NULL, NULL, 10000, 'active'
FROM (VALUES
  ('Coffee Latte',     15000),
  ('Coklat Latte',     15000),
  ('Red Velvet Latte', 15000),
  ('Kopi Susu Clasic', 10000)
) AS p(name, price)
JOIN categories cat ON cat.name = 'Hot Latte'
WHERE NOT EXISTS (SELECT 1 FROM products WHERE products.name = p.name);

-- BLACK COFFEE
-- V60 Filter/Japanese 17K → 1 produk (harga sama)
-- Tubruk Arabika/Robusta 10K → 1 produk (harga sama)
INSERT INTO products (category_id, name, price, hpp, member_price, image_url, stock, status)
SELECT cat.id, p.name, p.price, 0, NULL, NULL, 10000, 'active'
FROM (VALUES
  ('V60 Filter / Japanese',  17000),
  ('Tubruk Arabika/Robusta', 10000),
  ('Lemon Black',            12000),
  ('Black Panther',          17000),
  ('Americano',              10000)
) AS p(name, price)
JOIN categories cat ON cat.name = 'Black Coffee'
WHERE NOT EXISTS (SELECT 1 FROM products WHERE products.name = p.name);

-- MOKTAIL COFFEE
INSERT INTO products (category_id, name, price, hpp, member_price, image_url, stock, status)
SELECT cat.id, p.name, p.price, 0, NULL, NULL, 10000, 'active'
FROM (VALUES
  ('Sweda Coffee Reborn', 17000),
  ('Mont Blanc',          17000),
  ('Long Peach',          15000),
  ('Manisan',             13000),
  ('Perkecut',            13000)
) AS p(name, price)
JOIN categories cat ON cat.name = 'Moktail Coffee'
WHERE NOT EXISTS (SELECT 1 FROM products WHERE products.name = p.name);

-- FOOD
INSERT INTO products (category_id, name, price, hpp, member_price, image_url, stock, status)
SELECT cat.id, p.name, p.price, 0, NULL, NULL, 10000, 'active'
FROM (VALUES
  ('Nasi Kulit Asam Manis',   16000),
  ('Nasi Kulit Tambah Telur', 20000),
  ('Mie Nyemek',              12000),
  ('Mie Goreng Telur',         8000),
  ('Mie Rebus Telur',          8000),
  ('Jamur Krispy Saos Pedas',  8000),
  ('Mendoan Sambel Kecap',     8000),
  ('French Fries',             8000),
  ('Pisang Goreng Manis',     10000)
) AS p(name, price)
JOIN categories cat ON cat.name = 'Food'
WHERE NOT EXISTS (SELECT 1 FROM products WHERE products.name = p.name);

COMMIT;
