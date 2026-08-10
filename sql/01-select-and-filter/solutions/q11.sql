-- q11 — Credit limits in euros
-- A fixed planning rate, not a market rate: budgeting and credit control use
-- one rate for a whole year so that limits do not move with the market. Put
-- the rate in the query where a reader can see it.
SELECT
    customer_id,
    customer_name,
    credit_limit_gbp,
    round(credit_limit_gbp * 1.18, 0) AS credit_limit_eur
FROM customers
ORDER BY credit_limit_gbp DESC, customer_id
LIMIT 10;
