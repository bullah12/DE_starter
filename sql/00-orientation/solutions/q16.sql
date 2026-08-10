-- q16 — The first FX rates on file
-- Note the dates: 1 and 2 January 2022 were a Saturday and Sunday, so there
-- is no rate for them at all. Rates are published on working days, which
-- means any invoice dated at a weekend has no same-day rate to convert at.
SELECT rate_date, from_currency, to_currency, rate
FROM fx_rates
ORDER BY rate_date, from_currency
LIMIT 10;
