-- q02 — The revenue accounts
-- account_type is stored upper case, so 'Income' would return nothing at all
-- — no error, no rows, and no clue why. When a filter returns nothing, check
-- the casing before you check your logic.
SELECT account_code, account_name, report_section
FROM chart_of_accounts
WHERE account_type = 'INCOME'
ORDER BY account_code;
