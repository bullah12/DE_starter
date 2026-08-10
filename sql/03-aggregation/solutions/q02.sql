-- q02 — Invoices by type
SELECT
    invoice_type,
    count(*)                        AS invoice_count,
    round(sum(gross_amount_gbp), 2) AS total_gbp
FROM invoices
GROUP BY invoice_type
ORDER BY invoice_type;
