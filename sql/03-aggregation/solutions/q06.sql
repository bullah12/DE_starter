-- q06 — Payments by method, cleaned up
--
-- Grouping by upper(method) folds the two spellings together. Note that you
-- group by the expression and select the same expression, aliased — you
-- cannot group by an alias defined in the same SELECT, because GROUP BY runs
-- first.
--
-- Cleaning in the query like this is fine for analysis. For anything that
-- runs repeatedly, fix it once on the way in instead (topic 09, and
-- python/13).
SELECT
    upper(method)             AS method,
    count(*)                  AS payment_count,
    round(sum(amount_gbp), 2) AS total_gbp
FROM payments
GROUP BY upper(method)
ORDER BY payment_count DESC, method;
