-- q20 (stretch) — Suspect journal descriptions
--
-- Find ledger lines whose description has been mangled — the ones
-- stored entirely in upper case with padding. Return the twenty with
-- the largest debit.
--
-- Expected output: Four columns — gl_id, journal_id, line_description,
-- debit — largest debit first then gl_id.
--
-- Hint: upper(x) = x is true when a string is already upper case. Does that
-- catch descriptions with no letters in them at all?

-- Write your query below. One statement, ending in a semicolon.

