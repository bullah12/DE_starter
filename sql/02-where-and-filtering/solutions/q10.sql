-- q10 — Draft journals
-- Eight journals that were never posted properly, and every one of them still
-- has live ledger lines. Any report built on general_ledger without joining
-- to this status includes them.
SELECT journal_id, journal_date, source, description, prepared_by, approved_by
FROM journal_entries
WHERE status = 'DRAFT'
ORDER BY journal_id;
