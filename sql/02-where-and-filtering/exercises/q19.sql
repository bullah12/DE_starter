-- q19 (stretch) — Prove the NULL trap for yourself
--
-- Produce one row with three counts: customers outside the United
-- Kingdom using a simple <> test, the same test plus the missing
-- countries, and the total number of customers. Show that the naive
-- answer is understated.
--
-- Expected output: Three columns — naive_non_uk, correct_non_uk,
-- all_customers — one row.
--
-- Hint: count(*) FILTER (WHERE ...) counts rows matching a condition inside
-- a single query. It is a DuckDB and PostgreSQL feature worth learning now
-- — you will meet the portable version, conditional aggregation, in topic
-- 07.

-- Write your query below. One statement, ending in a semicolon.

