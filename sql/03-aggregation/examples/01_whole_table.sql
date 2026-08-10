-- Example 1: aggregates over a whole table
--
-- No GROUP BY means one group: everything. Five functions, one row out.

SELECT
    count(*)          AS ledger_lines,
    sum(debit)        AS total_debits,
    sum(credit)       AS total_credits,
    min(entry_date)   AS first_entry,
    max(entry_date)   AS last_entry
FROM general_ledger;
