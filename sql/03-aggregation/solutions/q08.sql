-- q08 — Big spending accounts
-- "More than a million of debits" is a fact about the group, so it belongs in
-- HAVING. Putting it in WHERE gives:
--     Binder Error: aggregate functions are not allowed in WHERE
SELECT
    account_code,
    count(*)   AS line_count,
    sum(debit) AS total_debit
FROM general_ledger
GROUP BY account_code
HAVING sum(debit) > 1000000
ORDER BY total_debit DESC, account_code;
