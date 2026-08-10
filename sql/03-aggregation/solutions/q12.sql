-- q12 — Journals per source per year
-- You can group by an expression. year(journal_date) is computed for every
-- row and then used as the pile label.
SELECT
    year(journal_date) AS year,
    source,
    count(*)           AS journal_count
FROM journal_entries
GROUP BY year(journal_date), source
ORDER BY year, source;
