-- q09 — Monthly revenue
--
-- date_trunc('month', d) flattens every date in a month to the first of that
-- month, which is the standard way to build a monthly series. Grouping on the
-- raw date would give you one row per day.
--
-- Income is credit-normal, so revenue is sum(credit - debit). Get it the
-- other way round and every month is negative.
SELECT
    date_trunc('month', entry_date)    AS month,
    count(*)                           AS line_count,
    round(sum(credit - debit), 2)      AS revenue_gbp
FROM general_ledger
WHERE account_code BETWEEN 4000 AND 4999
GROUP BY date_trunc('month', entry_date)
ORDER BY month;

-- 36 rows, one per month, with no gaps — because every month has revenue. A
-- month with none would simply be absent, which is the trap in any monthly
-- series built this way.
