-- q19 (stretch) — Prove the ledger does not balance, and size the hole
--
-- One row: total debits, total credits, the difference, and how many
-- distinct journals are involved in creating it.
--
-- Expected output: Four columns — total_debit, total_credit, difference,
-- broken_journals — one row.
--
-- Hint: The first three are easy. The fourth needs a count of journals
-- where the debits and credits disagree, which is a group-level test —
-- think about how to count groups rather than rows. A subquery (topic 05)
-- is the clean way; count(DISTINCT ...) with a FILTER will not get you
-- there on its own.

-- Write your query below. One statement, ending in a semicolon.

