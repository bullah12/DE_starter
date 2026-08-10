-- q17 — How many accounts of each type?
--
-- The key-check recipe with the HAVING removed. Without HAVING you see every
-- group, not just the duplicated ones — which turns "is this a key" into
-- "what is in this column".
SELECT account_type, count(*) AS account_count
FROM chart_of_accounts
GROUP BY account_type
ORDER BY account_count DESC, account_type;

-- This is the shape of a pivot table: one row per distinct value, with a
-- count against it. Topic 03 is entirely about this idea.
