-- q22 — Which revenue accounts sit behind trade debtors?
--
-- WHY THIS SHAPE
-- A self-join again, and a good demonstration of what double entry looks like
-- from the query side. One copy of the ledger pinned to the debit on trade
-- debtors, another pinned to a revenue credit in the same journal, then the
-- chart of accounts for the name.
--
-- BETWEEN 4000 AND 4999 picks up the revenue range. Using the account code
-- range is a shortcut; joining to chart_of_accounts and filtering on
-- account_type = 'INCOME' says the same thing more robustly, because it keeps
-- working if someone opens account 4100 in a different section.

SELECT
    cr.account_code                AS revenue_account,
    coa.account_name,
    count(DISTINCT dr.journal_id)  AS journal_count,
    round(sum(cr.credit), 2)       AS credited_gbp
FROM general_ledger AS dr
INNER JOIN general_ledger AS cr
        ON cr.journal_id = dr.journal_id
       AND cr.credit > 0
       AND cr.account_code BETWEEN 4000 AND 4999
INNER JOIN chart_of_accounts AS coa
        ON coa.account_code = cr.account_code
WHERE dr.account_code = 1200
  AND dr.debit > 0
GROUP BY cr.account_code, coa.account_name
ORDER BY credited_gbp DESC, cr.account_code;

-- Sanity check: these totals should agree with revenue for the whole period
-- from example 01 extended to all three years, because every sales invoice
-- debits trade debtors. If they do not, something has been posted to revenue
-- without going through the sales ledger — which is exactly the kind of thing
-- you want to find.
