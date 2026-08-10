-- q09 — Large overseas sales
--
-- currency has no NULLs on the invoice table, so <> 'GBP' is safe here. That
-- is a fact you check, not a fact you assume:
--     SELECT count(*), count(currency) FROM invoices;
-- Equal counts, no NULLs, <> is safe.
SELECT invoice_id, currency, due_date, gross_amount, gross_amount_gbp
FROM invoices
WHERE invoice_type = 'SALES'
  AND currency <> 'GBP'
  AND gross_amount_gbp > 20000
  AND due_date >= DATE '2024-01-01'
  AND due_date <  DATE '2025-01-01'
ORDER BY gross_amount_gbp DESC, invoice_id;
