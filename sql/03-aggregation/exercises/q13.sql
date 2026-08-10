-- q13 (core) — Accounts that only ever get credited
--
-- Which accounts have credits but no debits at all across the whole
-- ledger? These are the accumulating credit balances.
--
-- Expected output: Three columns — account_code, line_count, total_credit —
-- largest credit first.
--
-- Hint: A group where sum(debit) = 0. That is a HAVING condition.

-- Write your query below. One statement, ending in a semicolon.

