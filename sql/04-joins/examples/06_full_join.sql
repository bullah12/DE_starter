-- Example 6: FULL JOIN — budget versus actual, where either side can be missing
--
-- LOOKING AHEAD: this one uses a *subquery* — a query written inside another
-- query, in brackets, standing in for a table. That is topic 05, not this one.
-- Read each bracketed block as "a small temporary table of totals" and focus
-- on the FULL JOIN between them.
--
-- Cost accounts only (5000 and above), FY2025 period 1, which is April 2024.
-- The final WHERE keeps only the rows that failed to match, because those are
-- the ones nobody notices until the review meeting.

SELECT
    coalesce(b.account_code, a.account_code)  AS account_code,
    round(coalesce(b.budget, 0), 2)           AS budget_gbp,
    round(coalesce(a.actual, 0), 2)           AS actual_gbp
FROM (
    SELECT account_code, sum(budget_amount_gbp) AS budget
    FROM budgets
    WHERE fiscal_year = 'FY2025'
      AND fiscal_period = 1
      AND account_code >= 5000
    GROUP BY account_code
) AS b
FULL JOIN (
    SELECT account_code, sum(debit - credit) AS actual
    FROM general_ledger
    WHERE entry_date >= DATE '2024-04-01'
      AND entry_date <  DATE '2024-05-01'
      AND account_code >= 5000
    GROUP BY account_code
) AS a ON a.account_code = b.account_code
WHERE b.account_code IS NULL
   OR a.account_code IS NULL
ORDER BY account_code;
