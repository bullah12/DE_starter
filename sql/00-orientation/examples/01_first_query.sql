-- Your first query: show me the chart of accounts
--
-- SELECT chooses columns. FROM chooses the table. That is a whole query.

SELECT account_code, account_name, account_type
FROM chart_of_accounts
ORDER BY account_code
LIMIT 10;
