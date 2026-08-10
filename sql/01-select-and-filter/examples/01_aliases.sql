-- Example 1: aliases turn a query into a report
--
-- AS renames a column in the output. It changes nothing about the data; it
-- changes whether the person reading the result understands it.

SELECT
    account_code AS code,
    account_name AS account,
    account_type AS type
FROM chart_of_accounts
ORDER BY account_code
LIMIT 5;
