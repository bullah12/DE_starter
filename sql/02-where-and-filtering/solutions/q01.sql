-- q01 — Sales invoices in euros
-- Two conditions, both on the same table, joined with AND.
SELECT invoice_id, due_date, gross_amount
FROM invoices
WHERE invoice_type = 'SALES'
  AND currency = 'EUR'
ORDER BY invoice_id;
