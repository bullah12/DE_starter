-- q11 — Journals nobody approved
-- Missing approval is a NULL, not an empty string. In the CSV the field was
-- blank, and DuckDB loaded a blank unquoted field as NULL — so IS NULL is the
-- right test. If it had been loaded as '' you would need approved_by = ''
-- instead, and the two are not interchangeable.
SELECT journal_id, journal_date, source, description, prepared_by
FROM journal_entries
WHERE status = 'POSTED'
  AND approved_by IS NULL
ORDER BY journal_id;
