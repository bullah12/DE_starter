-- q20 — Suspect journal descriptions
--
-- upper(x) = x is TRUE when a string is already entirely upper case. It is
-- also TRUE for any string with no letters in it — '2024-03-01' upper-cased
-- is still '2024-03-01' — so on some columns this test catches innocent rows.
-- Here every description contains words, so it is safe.
--
-- The extra length test excludes descriptions that merely happen to be short
-- acronyms and confirms the padding is really there.
SELECT gl_id, journal_id, line_description, debit
FROM general_ledger
WHERE upper(line_description) = line_description
  AND line_description <> trim(line_description)
ORDER BY debit DESC, gl_id
LIMIT 20;

-- trim() removes leading and trailing spaces. Comparing a value with its own
-- trimmed version is the standard way to find padded text, and it is worth
-- running on every text column in a new extract.
