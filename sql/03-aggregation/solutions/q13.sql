-- q13 — Accounts that only ever get credited
--
-- HAVING sum(debit) = 0 keeps the groups where no debit was ever posted.
-- These are the accumulating credit balances: accumulated depreciation, PAYE,
-- pension, accruals.
--
-- Accounts that only ever move one way are worth a second look. In a real
-- ledger, an account that has never been debited in three years is either
-- correct by design, or a reconciliation nobody has done.
SELECT
    account_code,
    count(*)    AS line_count,
    sum(credit) AS total_credit
FROM general_ledger
GROUP BY account_code
HAVING sum(debit) = 0
ORDER BY total_credit DESC, account_code;
