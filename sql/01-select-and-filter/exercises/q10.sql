-- q10 (core) — The largest postings, either way round
--
-- The ten ledger lines with the largest movement in absolute terms —
-- that is, ignoring whether they are debits or credits.
--
-- Expected output: Five columns — gl_id, journal_id, account_code,
-- movement, abs_movement — ten rows, largest absolute movement first.
--
-- Hint: abs() strips the sign. Sorting on the signed movement would give
-- you the ten biggest debits and no credits at all.

-- Write your query below. One statement, ending in a semicolon.

