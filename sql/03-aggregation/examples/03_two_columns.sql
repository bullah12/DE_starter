-- Example 3: grouping by two columns, and counting distinct values
--
-- One row per combination that exists in the data. Combinations that never
-- occurred simply do not appear — which is a real difference from a pivot
-- table, and it bites when a month has no activity.

SELECT
    invoice_type,
    currency,
    count(*)                     AS invoices,
    count(DISTINCT customer_id)  AS customers,
    round(sum(gross_amount_gbp), 2) AS gross_gbp
FROM invoices
GROUP BY invoice_type, currency
ORDER BY invoice_type, currency;
