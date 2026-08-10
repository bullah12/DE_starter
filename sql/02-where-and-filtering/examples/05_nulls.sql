-- Example 5: NULL is not a value, it is the absence of one
--
-- NULL means "unknown". Comparing anything to an unknown gives an unknown,
-- not TRUE — so country = NULL never matches, even for the rows that have no
-- country. IS NULL is the only test that works.

SELECT customer_id, customer_name, country, payment_terms_days
FROM customers
WHERE country IS NULL
   OR payment_terms_days IS NULL
ORDER BY customer_id;
