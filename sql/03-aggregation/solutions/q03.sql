-- q03 — Ledger lines by account
-- A trial balance in three aggregates. Accounts with no activity do not
-- appear at all, because GROUP BY can only produce groups that have rows in
-- them.
SELECT
    account_code,
    count(*)    AS line_count,
    sum(debit)  AS total_debit,
    sum(credit) AS total_credit
FROM general_ledger
GROUP BY account_code
ORDER BY account_code;
