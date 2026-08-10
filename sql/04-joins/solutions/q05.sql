-- q05 — Ledger lines by journal source
--
-- WHY THIS SHAPE
-- Classic header-and-detail. source lives on the header (journal_entries),
-- the lines live in general_ledger, and journal_id joins them.
--
-- Starting from general_ledger keeps the grain at one row per line, which is
-- what you are counting. Start from the header instead and you would be
-- counting journals.

SELECT
    je.source,
    count(*) AS line_count
FROM general_ledger AS gl
INNER JOIN journal_entries AS je
        ON je.journal_id = gl.journal_id
GROUP BY je.source
ORDER BY line_count DESC, je.source;

-- count(*) is safe here because it is an INNER JOIN — every surviving row is
-- a real ledger line.
