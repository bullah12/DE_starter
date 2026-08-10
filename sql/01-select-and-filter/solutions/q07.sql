-- q07 — Budget lines in thousands
-- Reporting in thousands is a presentation decision, so it belongs in the
-- SELECT, not in the source data. Never store a rounded number when you can
-- round it on the way out.
SELECT
    fiscal_year,
    fiscal_period,
    account_code,
    budget_amount_gbp,
    round(budget_amount_gbp / 1000, 1) AS amount_k
FROM budgets
ORDER BY budget_amount_gbp DESC, budget_id
LIMIT 10;
