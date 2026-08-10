-- q12 — Is a ledger line identified by journal and line number?
--
-- A key can span several columns — a *composite* key. Here the pair is
-- unique, which is what you would hope: line 3 of journal JE-2023-00042 is
-- one specific posting.
--
-- No rows back. Good.
SELECT journal_id, line_number, count(*) AS times_it_appears
FROM general_ledger
GROUP BY journal_id, line_number
HAVING count(*) > 1
ORDER BY journal_id, line_number;
