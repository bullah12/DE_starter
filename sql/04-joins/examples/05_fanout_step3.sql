-- Example 5, step 3: what the duplication costs you
--
-- The same total, computed two ways. The join version is overstated by the
-- duplicated payment rows.

SELECT
    round(sum(p.amount_gbp), 2) AS settled_via_join
FROM invoices AS i
INNER JOIN payments AS p ON p.invoice_id = i.invoice_id
WHERE i.invoice_id IN ('PI-2022-00048', 'PI-2022-00102', 'SI-2022-00313');
