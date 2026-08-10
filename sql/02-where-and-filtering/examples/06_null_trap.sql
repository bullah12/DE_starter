-- Example 6: the NULL trap that eats rows
--
-- "Customers not in the United Kingdom" — obvious, and wrong. The five
-- customers with no country are NOT returned, because NULL <> 'United
-- Kingdom' evaluates to unknown, not true.
--
-- Run it, then run it again with the extra OR line uncommented and watch the
-- row count change from 22 to 27.

SELECT count(*) AS rows_returned
FROM customers
WHERE country <> 'United Kingdom';
--    OR country IS NULL
