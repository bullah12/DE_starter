-- q22 — Which customer names are duplicated once you ignore the mess?
--
-- Raw, these names all look distinct: 'FALKIRK MOTORS BV' and
-- 'Falkirk Motors BV  ' are different strings to a database. Normalising with
-- lower(trim(...)) collapses the casing and the padding, and the duplicates
-- fall out.
--
-- This is the standard shape of duplicate detection on dirty text: normalise
-- first, group second. Grouping on the raw column would find nothing and you
-- would report, confidently, that there are no duplicates.
SELECT
    lower(trim(customer_name)) AS clean_name,
    count(*)                   AS times_it_appears
FROM customers
GROUP BY lower(trim(customer_name))
HAVING count(*) > 1
ORDER BY clean_name;

-- Two names. Both are the near-duplicate accounts C2900 and C2901, which have
-- no trade against them — so the fix is to close them, not to merge balances.
-- Finding them is the query; deciding what to do is the accounting.
