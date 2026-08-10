-- q17 — Annualised budget lines
-- Multiplying a month by 12 assumes the month is typical. For rent it is; for
-- audit fees, which land in one month, it is nonsense. Annualising is a
-- statement about the business, not about the arithmetic — label it clearly.
SELECT
    budget_id,
    fiscal_year,
    account_code,
    budget_amount_gbp,
    round(budget_amount_gbp * 12, 2) AS annualised_gbp
FROM budgets
ORDER BY budget_amount_gbp DESC, budget_id
LIMIT 10;
