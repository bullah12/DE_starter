-- q09 (core) — Monthly revenue
--
-- Revenue by calendar month across the whole ledger — income accounts
-- only, using the account code range 4000 to 4999.
--
-- Expected output: Three columns — month, line_count, revenue_gbp — month
-- order. Month as the first day of the month.
--
-- Hint: date_trunc('month', entry_date) collapses a date to the first of
-- its month. Dates are topic 08 — this one function is worth borrowing
-- early. Income is credit-normal.

-- Write your query below. One statement, ending in a semicolon.

