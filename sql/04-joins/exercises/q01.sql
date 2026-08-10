-- q01 (warmup) — Expenses by account, 2024
--
-- The FD wants total expenditure for calendar 2024 broken down by
-- account, with the account name rather than the code. Use account_type
-- to identify expenses.
--
-- Expected output: Three columns — account_code, account_name, total_gbp —
-- one row per expense account with activity, biggest first.
--
-- Hint: Expenses are debit-normal, so sum(debit - credit). Filter the date
-- on general_ledger and the type on chart_of_accounts.

-- Write your query below. One statement, ending in a semicolon.

