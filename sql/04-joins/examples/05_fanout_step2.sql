-- Example 5, step 2: which key is duplicated, and on which side?
--
-- Never guess. Go to the table you suspect and count rows per key. The answer
-- is always in one of the two source tables, never in the join itself.

SELECT
    p.invoice_id,
    count(*) AS payment_rows
FROM payments AS p
GROUP BY p.invoice_id
HAVING count(*) > 1
ORDER BY p.invoice_id;
