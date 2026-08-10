-- q22 (stretch) — The cost of the missing cost centre
--
-- For each account that has ledger lines with no cost centre, show how
-- many lines and how much value are unattributable, and what percentage
-- of that account's total value they represent.
--
-- Expected output: Five columns — account_code, unattributed_lines,
-- unattributed_gbp, account_total_gbp, pct_unattributed — largest
-- unattributed value first.
--
-- Hint: You need both a filtered total and an unfiltered total in the same
-- row. count(*) FILTER (WHERE ...) and sum(...) FILTER (WHERE ...) do
-- exactly that.

-- Write your query below. One statement, ending in a semicolon.

