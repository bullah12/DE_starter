-- q13 — The oldest journals
-- The earliest journal is dated 3 January 2022 — the first working day of the
-- dataset. Knowing where the data starts and stops is part of knowing what
-- you can be asked.
SELECT journal_id, journal_date, source, description
FROM journal_entries
ORDER BY journal_date, journal_id
LIMIT 15;
