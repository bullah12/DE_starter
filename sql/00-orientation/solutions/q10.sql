-- q10 — How many customers have a country?
--
-- The two counts do different things, and the difference is the point:
--   count(*)        counts rows
--   count(country)  counts rows where country IS NOT NULL
--
-- 64 against 59, so five customers have no country. Any report grouped by
-- country either loses those five or shows them as a NULL group. Neither is
-- wrong; both need a decision.
SELECT
    count(*)       AS customer_rows,
    count(country) AS with_country
FROM customers;
