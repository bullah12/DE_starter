-- What makes a key a key: one row per value, no repeats.
--
-- If this returns no rows, account_code is unique and can safely be used to
-- join to. If it returns rows, it cannot.

SELECT account_code, count(*) AS times_it_appears
FROM chart_of_accounts
GROUP BY account_code
HAVING count(*) > 1;
