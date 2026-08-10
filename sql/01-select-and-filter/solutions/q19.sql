-- q19 — Currency and country pairs
--
-- Note where NULL sorts. DuckDB puts NULLs last by default in ascending
-- order, so the customers with no country appear at the bottom rather than
-- disappearing. On a report you would want them labelled — that is coalesce,
-- topic 07.
SELECT DISTINCT country, currency
FROM customers
ORDER BY country, currency;

-- The rows tell a story: everything outside the UK is invoiced in EUR or USD,
-- and the NULL-country customers are invoiced in a mix — so the missing
-- country is not confined to one region.
