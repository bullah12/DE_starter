-- Example 5, step 4: the same three invoices, counted from one table only
--
-- No join, so no fan-out. Compare this figure with step 3.

SELECT round(sum(gross_amount_gbp), 2) AS settled_direct
FROM invoices
WHERE invoice_id IN ('PI-2022-00048', 'PI-2022-00102', 'SI-2022-00313');
