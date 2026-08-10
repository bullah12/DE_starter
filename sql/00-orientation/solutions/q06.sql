-- q06 — Our biggest credit limits
-- DESC reverses one column only. The tie-break on customer_id matters here:
-- several customers share a limit of 500,000, and without it the ten rows you
-- get could differ between runs.
SELECT customer_id, customer_name, credit_limit_gbp
FROM customers
ORDER BY credit_limit_gbp DESC, customer_id
LIMIT 10;
