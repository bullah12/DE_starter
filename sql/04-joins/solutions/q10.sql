-- q10 — Top ten customers by value
--
-- WHY THIS SHAPE
-- The credit note has negative amounts, and the question says to exclude it,
-- so it is filtered in WHERE before any aggregation happens.
--
-- Group by customer_id as well as name: names in this table are not unique
-- (two customers appear twice under different ids) and are not clean. The id
-- is the key. Always group by the key and carry the label along.

SELECT
    c.customer_id,
    c.customer_name,
    c.country,
    round(sum(i.gross_amount_gbp), 2) AS total_gbp
FROM invoices AS i
INNER JOIN customers AS c
        ON c.customer_id = i.customer_id
WHERE i.invoice_type = 'SALES'
  AND i.gross_amount_gbp > 0
GROUP BY c.customer_id, c.customer_name, c.country
ORDER BY total_gbp DESC, c.customer_id
LIMIT 10;
