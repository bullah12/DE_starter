-- q16 — Every export sale to a named customer group
-- Each text value in an IN list gets its own quotes. A single pair around the
-- whole list would be one long string that matches nothing.
SELECT invoice_id, customer_id, due_date, currency, gross_amount
FROM invoices
WHERE invoice_type = 'SALES'
  AND customer_id IN ('C2004', 'C2017', 'C2030', 'C2043')
  AND gross_amount > 10000
ORDER BY customer_id, due_date, invoice_id;
