-- Example 1: WHERE keeps the rows you want
--
-- Read the WHERE clause as the criteria range of an Advanced Filter: a test
-- applied to every row, one row at a time.

SELECT invoice_id, invoice_type, due_date, gross_amount_gbp
FROM invoices
WHERE invoice_type = 'SALES'
  AND gross_amount_gbp > 100000
ORDER BY gross_amount_gbp DESC, invoice_id;
