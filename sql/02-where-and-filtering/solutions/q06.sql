-- q06 — Suppliers whose name mentions metals or tooling
--
-- ILIKE is case-insensitive; LIKE is not. This table holds names in three
-- different casings, so LIKE '%Metals%' would find perhaps a third of them
-- and give you no reason to suspect the rest existed.
SELECT supplier_id, supplier_name, country
FROM suppliers
WHERE supplier_name ILIKE '%metals%'
   OR supplier_name ILIKE '%tooling%'
ORDER BY supplier_id;
