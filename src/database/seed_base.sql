-- ============================================================
-- POS JAGAD — Base Seed Data
-- Generated from local Docker postgres. Run AFTER all migrations.
-- Safe to re-run (ON CONFLICT DO NOTHING).
-- ============================================================

-- permissions
INSERT INTO public.permissions (id, name, description, created_at) VALUES ('e154a45c-f6bd-488d-81c9-c2fd1213c521', 'dashboard', 'Akses ke halaman dashboard', '2026-05-28 04:15:24.483946') ON CONFLICT DO NOTHING;
INSERT INTO public.permissions (id, name, description, created_at) VALUES ('e4ae556e-f5dc-432d-a0d1-43dddc157369', 'kasir', 'Akses ke halaman kasir/transaksi', '2026-05-28 04:15:24.483946') ON CONFLICT DO NOTHING;
INSERT INTO public.permissions (id, name, description, created_at) VALUES ('36c933c1-b3e0-44dd-84cd-40a8ba9f5a8c', 'laporan', 'Akses ke halaman laporan', '2026-05-28 04:15:24.483946') ON CONFLICT DO NOTHING;
INSERT INTO public.permissions (id, name, description, created_at) VALUES ('6ab47a84-a936-42e8-95c4-663cd8587d83', 'produk', 'Akses ke halaman produk', '2026-05-28 04:15:24.483946') ON CONFLICT DO NOTHING;
INSERT INTO public.permissions (id, name, description, created_at) VALUES ('413ce8cc-def6-49ad-b0e2-1a7ce13adc0c', 'customer', 'Akses ke halaman customer', '2026-05-28 04:15:24.483946') ON CONFLICT DO NOTHING;
INSERT INTO public.permissions (id, name, description, created_at) VALUES ('642b96ae-0bfb-4b32-a0fe-a64651895abb', 'setting', 'Akses ke halaman pengaturan', '2026-05-28 04:15:24.483946') ON CONFLICT DO NOTHING;
INSERT INTO public.permissions (id, name, description, created_at) VALUES ('3a464b72-b9b8-456b-8587-ec5be5b70334', 'printer:read', 'Lihat daftar printer dan konfigurasi', '2026-05-28 04:15:27.806278') ON CONFLICT DO NOTHING;
INSERT INTO public.permissions (id, name, description, created_at) VALUES ('8b7ee60c-5d2a-4f8e-9a03-9b4d8ad5f0c6', 'printer:create', 'Tambah printer baru', '2026-05-28 04:15:27.806278') ON CONFLICT DO NOTHING;
INSERT INTO public.permissions (id, name, description, created_at) VALUES ('b6c851e7-7ce3-4f07-aba3-9b06e30f9368', 'printer:update', 'Edit konfigurasi printer', '2026-05-28 04:15:27.806278') ON CONFLICT DO NOTHING;
INSERT INTO public.permissions (id, name, description, created_at) VALUES ('4d7058cf-b98f-48a1-8a39-8ddc4aaec7e1', 'printer:delete', 'Hapus printer', '2026-05-28 04:15:27.806278') ON CONFLICT DO NOTHING;
INSERT INTO public.permissions (id, name, description, created_at) VALUES ('e6a9650e-337b-4fb8-bdf5-94dba1a4203c', 'printer:manage_templates', 'Buat dan edit template cetak', '2026-05-28 04:15:27.806278') ON CONFLICT DO NOTHING;
INSERT INTO public.permissions (id, name, description, created_at) VALUES ('ad113087-6120-40b3-8564-e6ab527d2b15', 'printer:test_print', 'Jalankan test print', '2026-05-28 04:15:27.806278') ON CONFLICT DO NOTHING;
INSERT INTO public.permissions (id, name, description, created_at) VALUES ('40892485-76a8-4636-8043-0cd6e051e7c9', 'printer:view_history', 'Lihat riwayat print jobs', '2026-05-28 04:15:27.806278') ON CONFLICT DO NOTHING;

-- users
INSERT INTO public.users (id, username, password_hash, full_name, email, phone_number, role, status, avatar_url, created_at, updated_at, last_login_at) VALUES ('45a2494c-f57d-4cb3-b674-52a86b90bba5', 'admin', '$2a$12$aqWEJljKDh58zO14srphTuQ6as/BQjqJLHLRo6IQvBiHYR3N7FciC', 'Administrator', NULL, NULL, 'admin', 'active', NULL, '2026-05-28 04:15:24.488673', '2026-05-28 04:15:24.488673', '2026-06-16 00:11:18.003124') ON CONFLICT DO NOTHING;
INSERT INTO public.users (id, username, password_hash, full_name, email, phone_number, role, status, avatar_url, created_at, updated_at, last_login_at) VALUES ('5ef0d17a-f9a0-41f5-a35e-29a2a0fc48f4', 'codot', '$2a$12$aqWEJljKDh58zO14srphTuQ6as/BQjqJLHLRo6IQvBiHYR3N7FciC', 'codot', NULL, NULL, 'kasir', 'active', NULL, '2026-05-28 16:56:49.6963', '2026-06-13 00:43:08.940088', '2026-06-15 13:21:29.650594') ON CONFLICT DO NOTHING;

-- role_permissions
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('3f2dfea7-9adb-4b55-8d4d-29a6534b353b', 'admin', 'e154a45c-f6bd-488d-81c9-c2fd1213c521', '2026-05-28 04:15:24.485889') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('db6728bf-585c-4225-9e5b-442d390099ca', 'admin', 'e4ae556e-f5dc-432d-a0d1-43dddc157369', '2026-05-28 04:15:24.485889') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('b19d19c6-816d-4559-be2e-ec4f1842fe4c', 'admin', '36c933c1-b3e0-44dd-84cd-40a8ba9f5a8c', '2026-05-28 04:15:24.485889') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('b25b3bda-54eb-4479-b1d3-01e08287ff0d', 'admin', '6ab47a84-a936-42e8-95c4-663cd8587d83', '2026-05-28 04:15:24.485889') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('4c6b5978-99c8-43c4-b9bb-adf0979018b3', 'admin', '413ce8cc-def6-49ad-b0e2-1a7ce13adc0c', '2026-05-28 04:15:24.485889') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('49398203-4a4d-44cb-ae4a-2303340af079', 'admin', '642b96ae-0bfb-4b32-a0fe-a64651895abb', '2026-05-28 04:15:24.485889') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('73949cfa-6b0e-45e0-9705-003199d23d0f', 'manager', 'e154a45c-f6bd-488d-81c9-c2fd1213c521', '2026-05-28 04:15:24.487894') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('f4e0fbeb-10f8-4d91-b992-98e7e3aa1df5', 'manager', 'e4ae556e-f5dc-432d-a0d1-43dddc157369', '2026-05-28 04:15:24.487894') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('1543d81e-eb1f-4a77-9328-6acfc1398ab2', 'manager', '36c933c1-b3e0-44dd-84cd-40a8ba9f5a8c', '2026-05-28 04:15:24.487894') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('c1e2994c-7248-4af6-8a53-8a16a7771c85', 'manager', '6ab47a84-a936-42e8-95c4-663cd8587d83', '2026-05-28 04:15:24.487894') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('0af32c00-4cf3-416c-87dc-02082fc755f9', 'manager', '413ce8cc-def6-49ad-b0e2-1a7ce13adc0c', '2026-05-28 04:15:24.487894') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('b162081c-d498-4572-a9c3-592ea597c1a1', 'kasir', 'e4ae556e-f5dc-432d-a0d1-43dddc157369', '2026-05-28 04:15:24.488379') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('658918a2-f37d-4c76-a353-f4c9c8a48e22', 'kasir', '36c933c1-b3e0-44dd-84cd-40a8ba9f5a8c', '2026-05-28 04:15:24.488379') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('9c9ae808-573b-4da9-b0c5-eefb066d18c9', 'kasir', '6ab47a84-a936-42e8-95c4-663cd8587d83', '2026-05-28 04:15:24.488379') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('43843e4b-bb73-4259-b641-19b3b1b26849', 'kasir', '413ce8cc-def6-49ad-b0e2-1a7ce13adc0c', '2026-05-28 04:15:24.488379') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('8396544e-1ab3-4968-8ec3-d661d4e662a8', 'admin', '3a464b72-b9b8-456b-8587-ec5be5b70334', '2026-05-28 04:15:27.809562') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('e08e31b2-bbb2-4c00-b30c-b23a0107a780', 'admin', '8b7ee60c-5d2a-4f8e-9a03-9b4d8ad5f0c6', '2026-05-28 04:15:27.809562') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('a8843fdf-1957-4903-80ee-53b364f3ed91', 'admin', 'b6c851e7-7ce3-4f07-aba3-9b06e30f9368', '2026-05-28 04:15:27.809562') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('06c171cd-cd83-40fd-b98c-0ee390f5c1ed', 'admin', '4d7058cf-b98f-48a1-8a39-8ddc4aaec7e1', '2026-05-28 04:15:27.809562') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('b557245f-6bea-49f1-917f-b8dcea9a3ba3', 'admin', 'e6a9650e-337b-4fb8-bdf5-94dba1a4203c', '2026-05-28 04:15:27.809562') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('8644724f-3d25-4c5a-9da6-80949c239b04', 'admin', 'ad113087-6120-40b3-8564-e6ab527d2b15', '2026-05-28 04:15:27.809562') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('6de0dce2-ff73-4ec7-a824-fb0560f2863f', 'admin', '40892485-76a8-4636-8043-0cd6e051e7c9', '2026-05-28 04:15:27.809562') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('9af71b53-2252-4de2-8070-b314484200ea', 'manager', '3a464b72-b9b8-456b-8587-ec5be5b70334', '2026-05-28 04:15:27.811403') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('9a391d4d-a814-471e-acff-7d6215514bc4', 'manager', 'ad113087-6120-40b3-8564-e6ab527d2b15', '2026-05-28 04:15:27.811403') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('61a51722-44c8-4bf3-b671-5002f100b6a8', 'manager', '40892485-76a8-4636-8043-0cd6e051e7c9', '2026-05-28 04:15:27.811403') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('7eec9e86-9a4c-4be0-bce8-e7e576d1fec2', 'kasir', '3a464b72-b9b8-456b-8587-ec5be5b70334', '2026-05-28 04:15:27.812131') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('53a941b7-423f-4985-9d4c-9a528cc1537f', 'kasir', 'ad113087-6120-40b3-8564-e6ab527d2b15', '2026-05-28 04:15:27.812131') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('69c786b9-4636-47d6-8582-ba6e8d942fb1', 'owner', '3a464b72-b9b8-456b-8587-ec5be5b70334', '2026-06-02 15:38:09.480313') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('f5c21b6c-e979-4f41-a2a5-b2a21ccd8711', 'owner', '8b7ee60c-5d2a-4f8e-9a03-9b4d8ad5f0c6', '2026-06-02 15:38:09.480313') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('9bf16585-b49e-4544-bf9f-beed14fa8275', 'owner', 'b6c851e7-7ce3-4f07-aba3-9b06e30f9368', '2026-06-02 15:38:09.480313') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('7652b3d6-4200-44f6-a175-8d83621a3ae3', 'owner', '4d7058cf-b98f-48a1-8a39-8ddc4aaec7e1', '2026-06-02 15:38:09.480313') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('7f9757b1-86f9-4adb-94f1-58fbe0844d2b', 'owner', 'e6a9650e-337b-4fb8-bdf5-94dba1a4203c', '2026-06-02 15:38:09.480313') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('6e1fe038-6595-4fe4-9386-bcf67de77dfb', 'owner', 'ad113087-6120-40b3-8564-e6ab527d2b15', '2026-06-02 15:38:09.480313') ON CONFLICT DO NOTHING;
INSERT INTO public.role_permissions (id, role, permission_id, created_at) VALUES ('3470d037-eb1e-4fc7-9090-96fa5ad296fe', 'owner', '40892485-76a8-4636-8043-0cd6e051e7c9', '2026-06-02 15:38:09.480313') ON CONFLICT DO NOTHING;

-- categories
INSERT INTO categories (name, description, icon, sort_order, status) VALUES
  ('Kopi Susu',      'Espresso based dengan susu',         '☕', 1, 'active'),
  ('Non-Coffee',     'Minuman non-kopi',                   '🥤', 2, 'active'),
  ('Hot Latte',      'Minuman panas latte',                '🔥', 3, 'active'),
  ('Black Coffee',   'Kopi hitam tanpa susu',              '☕', 4, 'active'),
  ('Moktail Coffee', 'Minuman kopi kreatif moktail style', '🍹', 5, 'active'),
  ('Food',           'Makanan',                            '🍟', 6, 'active')
ON CONFLICT (name) DO NOTHING;

-- add_ons
INSERT INTO public.add_ons (id, name, price, description, icon, sort_order, status, created_at, updated_at) VALUES ('a1b4b408-5218-4dcc-892a-786a6dd963ee', 'Extra Shot Espresso', 3000.00, 'Tambahan 1 shot espresso', NULL, 1, 'active', '2026-05-28 04:15:25.54253', '2026-05-28 17:02:27.578994') ON CONFLICT DO NOTHING;
INSERT INTO public.add_ons (id, name, price, description, icon, sort_order, status, created_at, updated_at) VALUES ('ad682870-d0f9-4b8a-b931-35bdb88cf92d', 'Less Sweet', 0.00, NULL, NULL, 0, 'active', '2026-05-28 17:02:46.899299', '2026-05-28 17:02:46.899299') ON CONFLICT DO NOTHING;
INSERT INTO public.add_ons (id, name, price, description, icon, sort_order, status, created_at, updated_at) VALUES ('5f14a47b-b762-4162-bf68-6e14945877ac', 'Normal Sweet', 0.00, NULL, NULL, 0, 'active', '2026-05-28 17:02:55.496243', '2026-05-28 17:02:55.496243') ON CONFLICT DO NOTHING;
INSERT INTO public.add_ons (id, name, price, description, icon, sort_order, status, created_at, updated_at) VALUES ('d835e5f0-1f13-4f06-a9bc-d051a457c9e4', 'Extra Sweet', 0.00, NULL, NULL, 0, 'active', '2026-05-28 17:03:02.393294', '2026-05-28 17:03:02.393294') ON CONFLICT DO NOTHING;
INSERT INTO public.add_ons (id, name, price, description, icon, sort_order, status, created_at, updated_at) VALUES ('dd34b0c5-9071-47ed-9ac2-a2916f7c8a68', 'Less Ice', 0.00, NULL, NULL, 0, 'active', '2026-05-28 17:03:08.690888', '2026-05-28 17:03:08.690888') ON CONFLICT DO NOTHING;
INSERT INTO public.add_ons (id, name, price, description, icon, sort_order, status, created_at, updated_at) VALUES ('6bdb0c59-87a6-4128-8890-ba1a4b362b68', 'Normal Ice', 0.00, NULL, NULL, 0, 'active', '2026-05-28 17:03:13.956614', '2026-05-28 17:03:13.956614') ON CONFLICT DO NOTHING;
INSERT INTO public.add_ons (id, name, price, description, icon, sort_order, status, created_at, updated_at) VALUES ('fceb0587-4308-4f91-9d50-ec234b519352', 'Extra Ice', 0.00, NULL, NULL, 0, 'active', '2026-05-28 17:03:19.407643', '2026-05-28 17:03:19.407643') ON CONFLICT DO NOTHING;

-- payment_methods
INSERT INTO public.payment_methods (id, icon, name, status, created_at, updated_at) VALUES ('6aea4e96-6f86-447a-a0a5-181ea8f1f799', '💵', 'Cash', 'active', '2026-05-28 04:15:26.261287', '2026-05-28 04:15:26.261287') ON CONFLICT DO NOTHING;
INSERT INTO public.payment_methods (id, icon, name, status, created_at, updated_at) VALUES ('8d31a5c2-2c37-48c3-b188-7b9dd6bec40a', '📱', 'QRIS', 'active', '2026-05-28 04:15:26.261287', '2026-05-28 04:15:26.261287') ON CONFLICT DO NOTHING;

-- printers
INSERT INTO public.printers (id, name, description, printer_type, connection_type, paper_width, font_size, status, is_default, auto_print, created_at, updated_at, last_used_at, device_path) VALUES ('127a36b9-c7ae-40e6-9b9a-f74c4208849f', 'RPP02N', 'tes', 'barista', 'bluetooth', 58.00, 12, 'active', false, false, '2026-06-09 11:31:49.008076', '2026-06-15 13:11:41.811831', NULL, '86:67:7A:B1:B0:03') ON CONFLICT DO NOTHING;
INSERT INTO public.printers (id, name, description, printer_type, connection_type, paper_width, font_size, status, is_default, auto_print, created_at, updated_at, last_used_at, device_path) VALUES ('0bc8b6b2-5ba4-49bf-b028-df2a323d4b0d', 'RPP02N', '', 'receipt', 'bluetooth', 80.00, 12, 'active', false, false, '2026-06-02 15:56:35.322037', '2026-06-15 13:11:45.315167', NULL, '86:67:7A:B1:B0:03') ON CONFLICT DO NOTHING;

-- printer_masterdata_template
INSERT INTO public.printer_masterdata_template (id, name, printer_type, content, description, is_active, created_at, updated_at, preview_content) VALUES ('14769718-97ad-4bf2-8eae-551651fcfee7', 'Default Receipt Template', 'receipt', '{"sections": {"items": {"show_notes": false, "show_add_ons": true, "show_quantity": true, "show_item_name": true, "show_item_discount": true, "show_item_subtotal": true}, "footer": {"footer_text": "Terima kasih sudah berbelanja ☕", "show_qr_code": true}, "header": {"show_logo": true, "show_cashier": true, "show_date_time": true, "show_store_info": true, "show_store_name": true, "show_store_phone": true, "show_table_number": true, "show_customer_name": true, "show_store_address": true, "show_transaction_id": true}, "payment": {"show_tax": true, "show_rounding": true, "show_subtotal": true, "show_grand_total": true, "show_tax_breakdown": false, "show_payment_method": true, "show_service_charge": true, "show_discount_reason": false, "show_global_discount": true, "show_payment_reference": true}}}', 'Master template for customer receipts (80mm) - Complete with all sections', true, '2026-05-28 04:15:28.098762', '2026-06-02 15:38:09.475603', '{"sections": {"items": {"price": "13.000", "add_ons": [{"name": "extra espresso", "price": "3.000", "quantity": 1}, {"name": "Less Sweet", "price": "0", "quantity": 1}], "quantity": 1, "subtotal": "15.000", "item_name": "Americano", "show_add_ons": true, "item_discount": "1.000", "show_quantity": true, "show_item_discount": true}, "footer": {"footer_text": "Terima kasih atas kunjungannya! Sampai jumpa dan selamat ngopi ~  \"Ngopi bersama kodok dan jangkrik\"", "show_qr_code": true}, "header": [{"logo": "/logo.webp", "show_logo": true}, {"store_name": "Sederek Kopi", "show_store_name": true}, {"store_address": "Jl. Jemb. Gantung, Ngrancah, Sriharjo, Kec. Imogiri, Kabupaten Bantul", "show_store_address": true}, {"date_time": "17 Feb 2026 14:30", "show_date_time": true}, {"cashier": "Bisma", "show_cashier": true}, {"customer_name": "Andi", "show_customer_name": true}, {"table_number": "18", "show_table_number": true}], "payment": {"subtotal": "16.000", "discount_items": "1.000", "global_discount": "0", "grand_total": "15.000", "show_subtotal": true, "show_global_discount": true, "show_grand_total": true, "payment_method": "QRIS", "show_payment_method": true}}}') ON CONFLICT DO NOTHING;
INSERT INTO public.printer_masterdata_template (id, name, printer_type, content, description, is_active, created_at, updated_at, preview_content) VALUES ('8f0730ac-de44-490e-8033-592b02f3e98a', 'Default Barista Template', 'barista', '{"sections": {"items": {"show_notes": true, "show_price": false, "show_add_ons": true, "show_quantity": true, "show_item_name": true}, "footer": {"preparation_text": "Siapkan dengan standar resep ☕", "show_preparation_reminder": true}, "header": {"show_time": true, "show_channel": true, "show_queue_number": true, "show_table_number": true, "show_customer_name": true}}}', 'Master template for barista tickets (58mm) - Complete with all sections', true, '2026-05-28 04:15:28.098762', '2026-06-02 15:38:09.475603', '{"sections": {"items": {"add_ons": [{"name": "extra espresso", "quantity": 1}, {"name": "Less Sweet", "quantity": 1}], "quantity": 1, "item_name": "Americano", "show_add_ons": true, "show_quantity": true}, "footer": {"preparation_text": "Siapkan dengan standar resep ☕", "show_preparation_reminder": true}, "header": [{"queue_number": "01", "show_queue_number": true}, {"table_number": 10, "show_table_number": true}, {"date_time": "17 Feb 2026 14:30", "show_date_time": true}, {"customer_name": "Andi", "show_customer_name": true}]}}') ON CONFLICT DO NOTHING;

-- printer_templates
INSERT INTO public.printer_templates (id, name, description, template_type, content, is_default, is_active, created_at, updated_at, id_printer, preview_content) VALUES ('c9d9ef91-a33f-4c43-bfb4-7662c6bd8a9b', 'tes - Default Barista Template', 'Template untuk printer tes', 'barista', '{"sections": {"items": {"show_notes": true, "show_price": false, "show_add_ons": true, "show_quantity": true, "show_item_name": true}, "footer": {"preparation_text": "Siapkan sesuai resep standar", "show_preparation_reminder": true}, "header": {"show_time": true, "show_channel": true, "show_queue_number": true, "show_table_number": true, "show_customer_name": true}, "store_info": {"logo_url": "", "store_name": "", "footer_text": "", "store_phone": "", "store_address": ""}}}', false, true, '2026-06-09 11:31:49.056142', '2026-06-13 00:42:27.264588', '127a36b9-c7ae-40e6-9b9a-f74c4208849f', '{"sections": {"items": {"add_ons": [{"name": "extra espresso", "quantity": 1}, {"name": "Less Sweet", "quantity": 1}], "quantity": 1, "item_name": "Americano", "show_add_ons": true, "show_quantity": true}, "footer": {"preparation_text": "Siapkan sesuai resep standar", "show_preparation_reminder": true}, "header": [{"queue_number": "01", "show_queue_number": true}, {"table_number": 10, "show_table_number": true}, {"date_time": "17 Feb 2026 14:30", "show_date_time": true}, {"customer_name": "Andi", "show_customer_name": true}]}}') ON CONFLICT DO NOTHING;
INSERT INTO public.printer_templates (id, name, description, template_type, content, is_default, is_active, created_at, updated_at, id_printer, preview_content) VALUES ('5a64bb97-a39f-40de-9ebb-d7e72d0f62bb', 'epson - Default Receipt Template', 'Template untuk printer epson', 'receipt', '{"sections": {"items": {"show_notes": false, "show_price": true, "show_add_ons": true, "show_quantity": true, "show_item_name": true, "item_name_format": "short", "show_item_discount": true, "show_item_subtotal": true}, "footer": {"footer_text": "Terima kasih sudah berbelanja, Dari Sederek untuk semua", "show_qr_code": true, "show_thank_you_message": true}, "header": {"show_logo": true, "show_cashier": true, "show_date_time": true, "show_store_name": true, "show_store_phone": true, "show_cashier_name": true, "show_store_slogan": false, "show_table_number": false, "show_customer_name": true, "show_store_address": true, "show_transaction_id": true, "show_transaction_date": true}, "payment": {"show_tax": false, "show_rounding": false, "show_subtotal": true, "show_grand_total": true, "show_tax_breakdown": false, "show_payment_method": true, "show_service_charge": true, "show_discount_reason": false, "show_global_discount": true, "total_display_format": "compact", "show_payment_reference": true}, "store_info": {"logo_url": "", "store_name": "Sederek Kopi", "footer_text": "Terima kasih sudah berbelanja, Dari Sederek untuk semua", "store_phone": "", "store_address": "Jl. Jemb. Gantung, Ngrancah, Sriharjo, Kec. Imogiri, Kabupaten Bantul, Daerah Istimewa Yogyakarta 55782"}}}', false, true, '2026-06-02 15:56:35.358374', '2026-06-15 12:59:32.195227', '0bc8b6b2-5ba4-49bf-b028-df2a323d4b0d', '{"sections": {"items": {"price": "13.000", "add_ons": [{"name": "extra espresso", "price": "3.000", "quantity": 1}, {"name": "Less Sweet", "price": "0", "quantity": 1}], "quantity": 1, "subtotal": "15.000", "item_name": "Americano", "show_add_ons": true, "item_discount": "1.000", "show_quantity": true, "show_item_discount": true}, "footer": {"footer_text": "Terima kasih sudah berbelanja, Dari Sederek untuk semua", "show_qr_code": true}, "header": [{"logo": "/logo.webp", "show_logo": true}, {"store_name": "Sederek Kopi", "show_store_name": true}, {"store_address": "Jl. Jemb. Gantung, Ngrancah, Sriharjo, Kec. Imogiri, Kabupaten Bantul, Daerah Istimewa Yogyakarta 55782", "show_store_address": true}, {"date_time": "17 Feb 2026 14:30", "show_date_time": true}, {"cashier": "Bisma", "show_cashier": true}, {"customer_name": "Andi", "show_customer_name": true}, {"table_number": "18", "show_table_number": false}], "payment": {"subtotal": "16.000", "discount_items": "1.000", "global_discount": "0", "grand_total": "15.000", "show_subtotal": true, "show_global_discount": true, "show_grand_total": true, "payment_method": "QRIS", "show_payment_method": true}}}') ON CONFLICT DO NOTHING;

-- printer_configurations

-- printer_routing

-- products (WHERE NOT EXISTS — aman re-run, tidak timpa yang sudah ada)
INSERT INTO products (category_id, name, price, hpp, member_price, image_url, stock, status)
SELECT cat.id, p.name, p.price, 0, NULL, NULL, 10000, 'active'
FROM (VALUES
  ('Kopi Susu', 'ESKA Kopsu Ice',    17000),
  ('Kopi Susu', 'Butterscoth',       17000),
  ('Kopi Susu', 'Savana Kopsu Ice',  17000),
  ('Kopi Susu', 'Avocado Kopsu Ice', 15000),
  ('Kopi Susu', 'Caramel Kopsu Ice', 15000),
  ('Kopi Susu', 'Pandan Wangi',      13000),
  ('Kopi Susu', 'Vanila Kopsu Ice',  13000),
  ('Kopi Susu', 'Kopsu Original',    12000),
  ('Non-Coffee', 'Matcha Latte Ice',   15000),
  ('Non-Coffee', 'Taro Full Cream',    15000),
  ('Non-Coffee', 'Red Velvet Ice',     12000),
  ('Non-Coffee', 'Ocean Blue',         12000),
  ('Non-Coffee', 'Coklat',             10000),
  ('Non-Coffee', 'Coklat Manja',       15000),
  ('Non-Coffee', 'Tea',                 5000),
  ('Non-Coffee', 'Lychee Tea',         10000),
  ('Non-Coffee', 'Lemon / Lemon Tea',   7000),
  ('Non-Coffee', 'Wedang Ndoro',        8000),
  ('Hot Latte', 'Coffee Latte',     15000),
  ('Hot Latte', 'Coklat Latte',     15000),
  ('Hot Latte', 'Red Velvet Latte', 15000),
  ('Hot Latte', 'Kopi Susu Clasic', 10000),
  ('Black Coffee', 'V60 Filter / Japanese',  17000),
  ('Black Coffee', 'Tubruk Arabika/Robusta', 10000),
  ('Black Coffee', 'Lemon Black',            12000),
  ('Black Coffee', 'Black Panther',          17000),
  ('Black Coffee', 'Americano',              10000),
  ('Moktail Coffee', 'Sweda Coffee Reborn', 17000),
  ('Moktail Coffee', 'Mont Blanc',          17000),
  ('Moktail Coffee', 'Long Peach',          15000),
  ('Moktail Coffee', 'Manisan',             13000),
  ('Moktail Coffee', 'Perkecut',            13000),
  ('Food', 'Nasi Kulit Asam Manis',   16000),
  ('Food', 'Nasi Kulit Tambah Telur', 20000),
  ('Food', 'Mie Nyemek',              12000),
  ('Food', 'Mie Goreng Telur',         8000),
  ('Food', 'Mie Rebus Telur',          8000),
  ('Food', 'Jamur Krispy Saos Pedas',  8000),
  ('Food', 'Mendoan Sambel Kecap',     8000),
  ('Food', 'French Fries',             8000),
  ('Food', 'Pisang Goreng Manis',     10000)
) AS p(category_name, name, price)
JOIN categories cat ON cat.name = p.category_name
WHERE NOT EXISTS (SELECT 1 FROM products WHERE products.name = p.name);


-- promos
