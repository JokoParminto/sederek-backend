-- Migration 041: Sync printer template store_info into preview_content
-- Purpose: Update preview_content header (store_name, store_address, store_phone, logo, footer_text)
--          from each template's content.sections.store_info so printed receipts show current store data.
--          Also fixes masterdata template logo path from logoblack.webp -> /logo.webp.

-- 1. Fix masterdata receipt template: update logo path in preview_content
UPDATE printer_masterdata_template
SET preview_content = jsonb_set(
  preview_content,
  '{sections,header}',
  (
    SELECT jsonb_agg(
      CASE
        WHEN elem ? 'logo' THEN jsonb_set(elem, '{logo}', '"/logo.webp"'::jsonb)
        ELSE elem
      END
    )
    FROM jsonb_array_elements(preview_content->'sections'->'header') elem
  )
)
WHERE printer_type = 'receipt'
  AND jsonb_typeof(preview_content->'sections'->'header') = 'array';

-- 2. Sync preview_content header fields from content.sections.store_info for all receipt templates
UPDATE printer_templates
SET preview_content = jsonb_set(
  preview_content,
  '{sections,header}',
  (
    SELECT jsonb_agg(
      CASE
        WHEN elem ? 'store_name' AND (content->'sections'->'store_info'->>'store_name') IS NOT NULL AND (content->'sections'->'store_info'->>'store_name') != ''
          THEN jsonb_set(elem, '{store_name}', to_jsonb(content->'sections'->'store_info'->>'store_name'))
        WHEN elem ? 'store_address' AND (content->'sections'->'store_info'->>'store_address') IS NOT NULL AND (content->'sections'->'store_info'->>'store_address') != ''
          THEN jsonb_set(elem, '{store_address}', to_jsonb(content->'sections'->'store_info'->>'store_address'))
        WHEN elem ? 'store_phone' AND (content->'sections'->'store_info'->>'store_phone') IS NOT NULL AND (content->'sections'->'store_info'->>'store_phone') != ''
          THEN jsonb_set(elem, '{store_phone}', to_jsonb(content->'sections'->'store_info'->>'store_phone'))
        WHEN elem ? 'logo'
          THEN jsonb_set(
            elem,
            '{logo}',
            to_jsonb(COALESCE(
              NULLIF(content->'sections'->'store_info'->>'logo_url', ''),
              '/logo.webp'
            ))
          )
        ELSE elem
      END
    )
    FROM jsonb_array_elements(preview_content->'sections'->'header') elem
  )
)
WHERE template_type = 'receipt'
  AND jsonb_typeof(preview_content->'sections'->'header') = 'array'
  AND content->'sections'->'store_info' IS NOT NULL;

-- 3. Add discount_items field to preview_content.sections.payment (for layout preview)
UPDATE printer_masterdata_template
SET preview_content = jsonb_set(
  jsonb_set(
    preview_content,
    '{sections,payment,discount_items}',
    '"1.000"'::jsonb
  ),
  '{sections,payment,subtotal}',
  '"16.000"'::jsonb
)
WHERE printer_type = 'receipt'
  AND preview_content->'sections'->'payment' IS NOT NULL;

UPDATE printer_templates
SET preview_content = jsonb_set(
  jsonb_set(
    preview_content,
    '{sections,payment,discount_items}',
    '"1.000"'::jsonb
  ),
  '{sections,payment,subtotal}',
  '"16.000"'::jsonb
)
WHERE template_type = 'receipt'
  AND preview_content->'sections'->'payment' IS NOT NULL;

-- 4. Sync footer_text from store_info into preview_content.sections.footer
UPDATE printer_templates
SET preview_content = jsonb_set(
  preview_content,
  '{sections,footer,footer_text}',
  to_jsonb(content->'sections'->'store_info'->>'footer_text')
)
WHERE template_type = 'receipt'
  AND (content->'sections'->'store_info'->>'footer_text') IS NOT NULL
  AND (content->'sections'->'store_info'->>'footer_text') != ''
  AND preview_content->'sections'->'footer' IS NOT NULL;
