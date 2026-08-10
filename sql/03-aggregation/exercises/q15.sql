-- q15 (core) — Does the ledger balance, year by year?
--
-- Total debits and credits by calendar year, with the difference. In a
-- double-entry ledger the difference must be zero. Find the years where
-- it is not.
--
-- Expected output: Five columns — year, line_count, total_debit,
-- total_credit, difference — year order.
--
-- Hint: year(entry_date) as the grouping column. The difference is an
-- expression built from two aggregates, which is allowed.

-- Write your query below. One statement, ending in a semicolon.

