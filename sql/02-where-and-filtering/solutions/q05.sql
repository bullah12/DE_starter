-- q05 — Customers with no country
-- IS NULL is the only test that works. country = NULL runs happily and
-- returns nothing, which looks like "there are none" and is not.
SELECT customer_id, customer_name, currency
FROM customers
WHERE country IS NULL
ORDER BY customer_id;

-- Five accounts, and note their currencies: EUR and USD. These are almost
-- certainly overseas customers, so the missing country is not random — it
-- distorts exactly the analysis you would want it for.
