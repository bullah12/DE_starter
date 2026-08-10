-- q07 — Budget by fiscal year
-- Three years, roughly equal, which is what you would expect from a budget
-- built by uplifting the prior year. A budget that jumps 40% between years is
-- either a real change in the business or a mistake, and either way it is a
-- question.
SELECT
    fiscal_year,
    count(*)                        AS budget_lines,
    round(sum(budget_amount_gbp), 2) AS total_budget_gbp
FROM budgets
GROUP BY fiscal_year
ORDER BY fiscal_year;
