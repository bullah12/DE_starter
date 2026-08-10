-- q23 — Budget against actual, both ways round
--
-- WHY THIS SHAPE
-- Both sides must be aggregated *before* the join. Join the raw tables and
-- every budget line meets every ledger line for that cost centre, which is a
-- fan-out of thousands of rows and a total that is nonsense.
--
-- So: two subqueries, each already at one row per cost centre, joined with
-- FULL JOIN so that a cost centre appearing on only one side still shows.
-- Subqueries are topic 05 — the shape is copied from
-- examples/06_full_join.sql.
--
-- FY2025 period 1 is April 2024. Cost accounts are 5000 and above, and cost
-- is debit-normal, so actual is sum(debit - credit).

SELECT
    coalesce(b.cost_centre_code, a.cost_centre_code) AS cost_centre_code,
    round(coalesce(b.budget, 0), 2)                  AS budget_gbp,
    round(coalesce(a.actual, 0), 2)                  AS actual_gbp,
    round(coalesce(b.budget, 0) - coalesce(a.actual, 0), 2) AS variance_gbp
FROM (
    SELECT cost_centre_code, sum(budget_amount_gbp) AS budget
    FROM budgets
    WHERE fiscal_year = 'FY2025'
      AND fiscal_period = 1
      AND account_code >= 5000
    GROUP BY cost_centre_code
) AS b
FULL JOIN (
    SELECT cost_centre_code, sum(debit - credit) AS actual
    FROM general_ledger
    WHERE entry_date >= DATE '2024-04-01'
      AND entry_date <  DATE '2024-05-01'
      AND account_code >= 5000
    GROUP BY cost_centre_code
) AS a ON a.cost_centre_code = b.cost_centre_code
ORDER BY cost_centre_code;

-- coalesce on the join key is not optional. In a FULL JOIN either key can be
-- NULL, so selecting b.cost_centre_code alone would leave blanks on every
-- actual-only row. Taking the first non-NULL of the two gives one clean key
-- column.
--
-- Variance is signed budget minus actual, so positive means underspent. State
-- which way round you have defined it on the face of the report — half the
-- arguments about variance reports are really arguments about the sign.
