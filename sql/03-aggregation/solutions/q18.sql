-- q18 — Quiet accounts
-- Low-volume accounts are where the surprises live: they are too small to be
-- noticed and too rare to be understood. Ask about every one of them before
-- you design a report around this chart.
SELECT
    account_code,
    count(*)    AS line_count,
    sum(debit)  AS total_debit,
    sum(credit) AS total_credit
FROM general_ledger
GROUP BY account_code
HAVING count(*) < 10
ORDER BY line_count, account_code;
