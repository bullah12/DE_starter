-- q16 (core) — Journals that do not balance
--
-- Six journals in the ledger have debits that do not equal credits. Find
-- them, and show the header details so someone can investigate.
--
-- Expected output: Six columns — journal_id, journal_date, source,
-- description, total_debit, total_credit — six rows, journal_id order.
--
-- Hint: Aggregate the lines by journal_id and use HAVING. You still need
-- the header columns, so the header must be in the join and in the GROUP
-- BY.

-- Write your query below. One statement, ending in a semicolon.

