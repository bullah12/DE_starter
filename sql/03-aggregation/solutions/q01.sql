-- q01 — Size up the invoice table
-- No GROUP BY, so the whole table is one group. Four facts, one query, and
-- the first thing to run against any new table.
SELECT
    count(*)                        AS invoice_count,
    round(sum(gross_amount_gbp), 2) AS total_gbp,
    min(gross_amount_gbp)           AS smallest_gbp,
    max(gross_amount_gbp)           AS largest_gbp
FROM invoices;

-- smallest_gbp is negative: that is the credit note. min() and max() are the
-- cheapest outlier detector there is.
