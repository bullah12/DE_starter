-- q20 — What sources post to this ledger?
--
-- Run this against any coded column you have not seen before. In ten seconds
-- it tells you the full list of values and how common each one is — which is
-- usually more useful than the data dictionary, because it describes what is
-- actually in the table rather than what was intended.
SELECT source, count(*) AS journal_count
FROM journal_entries
GROUP BY source
ORDER BY journal_count DESC, source;
