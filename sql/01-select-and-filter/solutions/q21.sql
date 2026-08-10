-- q21 — Inverse exchange rates
--
-- Order of operations matters. round(1 / rate, 4) divides first and rounds
-- the answer. round(1 / round(rate, 2), 4) would round the rate to two
-- places first and then invert it, and at these magnitudes that shifts the
-- result in the third decimal. Round last, always.
SELECT
    rate_date,
    from_currency,
    rate,
    round(1 / rate, 4) AS inverse_rate
FROM fx_rates
ORDER BY rate_date, from_currency
LIMIT 10;
