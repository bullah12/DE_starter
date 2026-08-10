-- q15 — Does the ledger balance, year by year?
--
-- The difference column is an expression built from two aggregates, which is
-- perfectly legal — SQL evaluates the aggregates first and then the
-- arithmetic.
--
-- All three years are out. That narrows the search: the broken journals are
-- spread across the whole period rather than being one bad month, which
-- points at data entry rather than a failed load.
SELECT
    year(entry_date) AS year,
    count(*)         AS line_count,
    sum(debit)       AS total_debit,
    sum(credit)      AS total_credit,
    sum(debit) - sum(credit) AS difference
FROM general_ledger
GROUP BY year(entry_date)
ORDER BY year;
