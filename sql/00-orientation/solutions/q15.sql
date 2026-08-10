-- q15 — The largest budget lines
SELECT fiscal_year, fiscal_period, account_code, cost_centre_code,
       budget_amount_gbp
FROM budgets
ORDER BY budget_amount_gbp DESC, budget_id
LIMIT 10;

-- Budgets are held per account, per cost centre, per period. That is the
-- *grain* of the table, and it is why a single line is small: nobody budgets
-- a whole year in one row.
