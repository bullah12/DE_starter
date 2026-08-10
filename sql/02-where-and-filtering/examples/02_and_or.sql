-- Example 2: AND, OR and why the brackets matter
--
-- AND binds tighter than OR, exactly like x + y * z. Without the brackets
-- this query would mean "UK sales invoices, OR any purchase invoice at all".

SELECT invoice_id, invoice_type, currency, gross_amount_gbp
FROM invoices
WHERE (invoice_type = 'SALES' OR invoice_type = 'PURCHASE')
  AND currency = 'USD'
  AND gross_amount_gbp > 40000
ORDER BY gross_amount_gbp DESC, invoice_id;
