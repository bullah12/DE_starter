-- q07 — Mid-sized credit limits
-- BETWEEN includes both endpoints, so 50,000 and 150,000 are both in. That is
-- what "inclusive" means and it is worth confirming with the person asking —
-- "between 50 and 150" is ambiguous in English and precise in SQL.
SELECT customer_id, customer_name, credit_limit_gbp
FROM customers
WHERE credit_limit_gbp BETWEEN 50000 AND 150000
ORDER BY credit_limit_gbp DESC, customer_id;
