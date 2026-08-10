-- q20 — Revenue concentration
--
-- The percentage needs a denominator that spans the whole table while the
-- rest of the query is grouped by customer. A scalar subquery — a subquery
-- returning exactly one value — supplies it. It is evaluated once, not once
-- per row.
--
-- Topic 06 does the same thing with sum(...) OVER (), which is shorter and
-- reads better. Both are correct; the subquery works in every database.
SELECT
    customer_id,
    round(sum(gross_amount_gbp), 2) AS total_gbp,
    round(100.0 * sum(gross_amount_gbp) /
          (SELECT sum(gross_amount_gbp) FROM invoices WHERE invoice_type = 'SALES'),
          2) AS pct_of_total
FROM invoices
WHERE invoice_type = 'SALES'
GROUP BY customer_id
ORDER BY total_gbp DESC, customer_id
LIMIT 10;

-- The top ten customers are roughly a quarter of revenue. Concentration is a
-- risk disclosure, and this is the query behind it.
