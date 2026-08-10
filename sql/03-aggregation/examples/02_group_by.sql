-- Example 2: GROUP BY is a pivot table
--
-- Row labels = the GROUP BY columns. Values = the aggregate functions.
-- This is a trial balance.

SELECT
    account_code,
    sum(debit)  AS total_debit,
    sum(credit) AS total_credit,
    sum(debit) - sum(credit) AS balance
FROM general_ledger
WHERE entry_date >= DATE '2024-01-01'
GROUP BY account_code
ORDER BY account_code
LIMIT 10;
