-- q21 — Weekend-dated postings
--
-- 54 ledger lines dated on a Saturday or a Sunday. Look at what they are:
-- every one is a month-end journal — depreciation, bank charges, accruals —
-- posted on the last calendar day of the month regardless of whether that day
-- was a working day.
--
-- So this is not an error. It is a convention, and now you know it. The value
-- of the query is that you asked rather than assumed: had these turned out to
-- be sales invoices dated at the weekend, that would be a genuine control
-- issue about back-dating.
--
-- dayofweek() returns 0 for Sunday through 6 for Saturday in DuckDB. Other
-- databases number the week differently, which is exactly the kind of detail
-- to check rather than remember.
SELECT
    gl_id,
    journal_id,
    entry_date,
    dayname(entry_date) AS day_name
FROM general_ledger
WHERE dayofweek(entry_date) IN (0, 6)
ORDER BY entry_date, gl_id;
