-- q18 — Ledger lines with no cost centre
--
-- Filter first, then count. The accounts that appear tell you *why* the cost
-- centre is missing: PAYE, pension and net pay control lines are company-wide
-- by nature, so a blank cost centre there is correct rather than careless.
--
-- That distinction matters. "231 rows have a missing value" is a data quality
-- statistic. "231 rows are control postings that are not attributable to a
-- cost centre" is an explanation, and it is the sentence your reviewer wants.
SELECT account_code, count(*) AS line_count
FROM general_ledger
WHERE cost_centre_code IS NULL
GROUP BY account_code
ORDER BY line_count DESC, account_code;
