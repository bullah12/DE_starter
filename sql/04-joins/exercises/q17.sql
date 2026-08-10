-- q17 (core) — What did we pay out of the bank account?
--
-- For every journal that credits the bank current account (1400), which
-- accounts were debited, and how much in total? Show the account name.
--
-- Expected output: Four columns — account_code, account_name,
-- journal_count, total_debited — one row per contra account, largest first.
--
-- Hint: Self-join the general ledger on journal_id, then join once more to
-- chart_of_accounts for the name of the debit side.

-- Write your query below. One statement, ending in a semicolon.

