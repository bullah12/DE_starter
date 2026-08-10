-- Example 4: LIKE for pattern matching
--
-- % matches any number of characters, _ matches exactly one. ILIKE is the
-- case-insensitive version, which this messy customer table badly needs.

SELECT customer_id, customer_name, country
FROM customers
WHERE customer_name ILIKE '%motors%'
ORDER BY customer_id;
