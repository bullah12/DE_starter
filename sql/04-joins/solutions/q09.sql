-- q09 — Revenue by region and year
--
-- WHY THIS SHAPE
-- Three tables, because region is two hops away from the money: invoice ->
-- customer -> cost centre -> region. Each hop is a lookup, so neither join
-- changes the number of rows.
--
-- year() extracts the year from a date. It belongs to topic 08; it is used
-- here because grouping by year is unavoidable in this question.

SELECT
    cc.region,
    year(i.due_date)                  AS year,
    count(*)                          AS invoice_count,
    round(sum(i.gross_amount_gbp), 2) AS gross_gbp
FROM invoices AS i
INNER JOIN customers    AS c  ON c.customer_id      = i.customer_id
INNER JOIN cost_centres AS cc ON cc.cost_centre_code = c.cost_centre_code
WHERE i.invoice_type = 'SALES'
GROUP BY cc.region, year(i.due_date)
ORDER BY cc.region, year;

-- 2025 appears even though the data stops in December 2024: invoices raised
-- late in 2024 on 60 or 90 day terms fall due in 2025. That is correct, and
-- it is the kind of thing to mention when you hand the report over.
