-- q01 — Expenses by account, 2024
--
-- WHY THIS SHAPE
-- general_ledger is the population: it holds the numbers, and every question
-- about "how much" starts there. chart_of_accounts is a lookup that adds one
-- matching row per ledger line, so an INNER JOIN adds columns without adding
-- rows. That is the safe kind of join.
--
-- Expenses are debit-normal, so sum(debit - credit) gives a positive figure.
-- Get this the wrong way round and every number comes back negative.

SELECT
    coa.account_code,
    coa.account_name,
    round(sum(gl.debit - gl.credit), 2) AS total_gbp
FROM general_ledger AS gl
INNER JOIN chart_of_accounts AS coa
        ON coa.account_code = gl.account_code
WHERE coa.account_type = 'EXPENSE'
  AND gl.entry_date >= DATE '2024-01-01'
  AND gl.entry_date <  DATE '2025-01-01'
GROUP BY coa.account_code, coa.account_name
ORDER BY total_gbp DESC, coa.account_code;

-- The trailing sort on account_code is not decoration. Without it, two
-- accounts with the same total could come back in either order, and a report
-- that reorders itself between runs is a report nobody trusts.
