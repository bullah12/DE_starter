-- q19 — Prove the NULL trap for yourself
--
-- 22 against 27 out of 64. The naive test understates the overseas customer
-- base by five accounts — nearly 20% of it.
--
-- count(*) FILTER (WHERE ...) counts only the rows matching a condition,
-- inside one pass over the table. It is far easier to read than three
-- separate queries pasted into a spreadsheet, and it lets you put the naive
-- and correct answers side by side where the difference is impossible to
-- miss.
SELECT
    count(*) FILTER (WHERE country <> 'United Kingdom')                        AS naive_non_uk,
    count(*) FILTER (WHERE country <> 'United Kingdom' OR country IS NULL)     AS correct_non_uk,
    count(*)                                                                   AS all_customers
FROM customers;

-- ALTERNATIVE, and the portable version you will meet in topic 07:
--     sum(CASE WHEN country <> 'United Kingdom' THEN 1 ELSE 0 END)
-- FILTER is cleaner and works in DuckDB and PostgreSQL. CASE works
-- everywhere. Know both.
