-- Migration 043: Add kitchen printer type
BEGIN;

-- Extend printers.printer_type constraint
ALTER TABLE printers DROP CONSTRAINT IF EXISTS printers_printer_type_check;
ALTER TABLE printers ADD CONSTRAINT printers_printer_type_check
  CHECK (printer_type IN ('receipt', 'barista', 'kitchen', 'label', 'a4', 'network'));

-- Extend printer_routing.print_type constraint
ALTER TABLE printer_routing DROP CONSTRAINT IF EXISTS printer_routing_print_type_check;
ALTER TABLE printer_routing ADD CONSTRAINT printer_routing_print_type_check
  CHECK (print_type IN ('customer_receipt', 'barista_ticket', 'kitchen_ticket', 'label'));

-- Extend printer_masterdata_template.printer_type constraint
ALTER TABLE printer_masterdata_template DROP CONSTRAINT IF EXISTS printer_masterdata_template_printer_type_check;
ALTER TABLE printer_masterdata_template ADD CONSTRAINT printer_masterdata_template_printer_type_check
  CHECK (printer_type IN ('receipt', 'barista', 'kitchen'));

-- Insert default kitchen masterdata template (idempotent)
INSERT INTO printer_masterdata_template (name, printer_type, content, description, is_active)
SELECT
  'Default Kitchen Template',
  'kitchen',
  '{"sections": {"items": {"show_notes": true, "show_add_ons": true, "show_quantity": true, "show_item_name": true}, "footer": {"preparation_text": "Siapkan segera", "show_preparation_reminder": true}, "header": {"show_time": true, "show_channel": true, "show_queue_number": true, "show_table_number": true, "show_customer_name": true}}}',
  'Master template for kitchen tickets - Complete with all sections',
  true
WHERE NOT EXISTS (
  SELECT 1 FROM printer_masterdata_template WHERE printer_type = 'kitchen'
);

COMMIT;
