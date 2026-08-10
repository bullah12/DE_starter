-- q08 — Exchange rates per thousand units
-- Rates are quoted to six decimal places for a reason: at 1,000 units the
-- fourth decimal is already worth pennies, and on a million-euro balance it
-- is worth hundreds.
SELECT
    rate_date,
    from_currency,
    rate,
    round(rate * 1000, 2) AS gbp_per_1000
FROM fx_rates
ORDER BY rate_date, from_currency
LIMIT 10;
