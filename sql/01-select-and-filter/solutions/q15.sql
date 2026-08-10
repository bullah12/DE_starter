-- q15 — Implied exchange rates on payments
--
-- The GBP columns were converted when the row was created. Dividing them back
-- out recovers the rate that was used — which lets you check it against
-- fx_rates and find conversions done at the wrong date. The GBP payments come
-- back at exactly 1.0, as they should.
SELECT
    payment_id,
    currency,
    amount,
    amount_gbp,
    round(amount_gbp / amount, 6) AS implied_rate
FROM payments
ORDER BY amount_gbp DESC, payment_id
LIMIT 10;
