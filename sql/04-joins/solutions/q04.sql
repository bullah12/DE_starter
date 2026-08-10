-- q04 — Customers we have never invoiced
--
-- WHY THIS SHAPE
-- This is an *anti-join*: keep the rows that did NOT match. Two steps.
--   1. LEFT JOIN, so unmatched customers survive with NULLs on the right.
--   2. WHERE <right-hand column> IS NULL, which keeps only those unmatched
--      rows.
--
-- Test a column that can never legitimately be NULL — invoice_id is the key,
-- so a NULL there can only mean "nothing matched". Testing a nullable column
-- would mix genuine NULLs in with unmatched rows.

SELECT
    c.customer_id,
    c.customer_name,
    c.is_active
FROM customers AS c
LEFT JOIN invoices AS i
       ON i.customer_id = c.customer_id
      AND i.invoice_type = 'SALES'
WHERE i.invoice_id IS NULL
ORDER BY c.customer_id;

-- Three rows, and two of them are the near-duplicate customer records C2900
-- and C2901. They have no invoices because the trade sits under the original
-- account. Deactivating them is right; merging them is more right.
--
-- ALTERNATIVE: NOT IN or NOT EXISTS express the same idea more directly, and
-- you will meet both in topic 05. NOT IN has a nasty edge case when the
-- subquery returns any NULL, which is exactly why the LEFT JOIN version is
-- worth knowing first.
