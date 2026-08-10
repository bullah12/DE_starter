-- q21 (stretch) — Weekend-dated postings
--
-- Ledger lines dated on a Saturday or Sunday. There should be none, and
-- if there are, that is a finding.
--
-- Expected output: Four columns — gl_id, journal_id, entry_date, day_name —
-- entry_date then gl_id.
--
-- Hint: dayofweek() returns 0 for Sunday through 6 for Saturday in DuckDB.
-- dayname() gives the label. Dates are topic 08 — this is a look ahead.

-- Write your query below. One statement, ending in a semicolon.

