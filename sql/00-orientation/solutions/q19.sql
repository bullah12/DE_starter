-- q19 — The biggest journals
-- Every one of them is a payroll journal: three cost lines for each of eight
-- cost centres plus three control lines. Journal size is a fingerprint — once
-- you know the shapes, an unusual one stands out immediately.
SELECT journal_id, count(*) AS line_count
FROM general_ledger
GROUP BY journal_id
HAVING count(*) > 20
ORDER BY line_count DESC, journal_id;
