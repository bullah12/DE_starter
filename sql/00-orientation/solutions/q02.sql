-- q02 — The first fifteen accounts
-- ORDER BY runs before LIMIT, so this is the first fifteen *in code order*,
-- not fifteen arbitrary rows that then got sorted.
SELECT account_code, account_name
FROM chart_of_accounts
ORDER BY account_code
LIMIT 15;
