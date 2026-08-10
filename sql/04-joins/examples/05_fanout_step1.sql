-- Example 5, step 1: the check that catches a fan-out
--
-- Count the rows AND count the distinct keys. If they differ, the join has
-- duplicated something. This is the reconciliation instinct you already have,
-- written as SQL.

SELECT
    count(*)                    AS joined_rows,
    count(DISTINCT i.invoice_id) AS distinct_invoices
FROM invoices AS i
INNER JOIN payments AS p ON p.invoice_id = i.invoice_id;
