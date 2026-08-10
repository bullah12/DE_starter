-- Example 5: three kinds of count, and what NULLs do to an average
--
--   count(*)                   every row
--   count(country)             rows where country is not NULL
--   count(DISTINCT country)    different non-NULL values
--
-- avg() ignores NULLs entirely: it divides by the number of values it found,
-- not by the number of rows. That is usually what you want and occasionally a
-- disaster.

SELECT
    count(*)                        AS customers,
    count(country)                  AS with_country,
    count(DISTINCT country)         AS distinct_countries,
    count(payment_terms_days)       AS with_terms,
    round(avg(payment_terms_days), 2) AS avg_terms_days,
    round(sum(payment_terms_days) * 1.0 / count(*), 2) AS avg_if_nulls_were_zero
FROM customers;
