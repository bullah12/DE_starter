-- Example 2: LEFT JOIN — every customer, including the ones who bought nothing
--
-- An INNER JOIN here would silently drop customers with no 2024 invoices,
-- which is precisely the population you were asked about.

SELECT
    c.customer_id,
    c.customer_name,
    count(i.invoice_id)                        AS invoice_count,
    round(coalesce(sum(i.gross_amount_gbp), 0), 2) AS invoiced_gbp
FROM customers AS c
LEFT JOIN invoices AS i
       ON i.customer_id = c.customer_id
      AND i.invoice_type = 'SALES'
      AND i.due_date >= DATE '2024-01-01'
GROUP BY c.customer_id, c.customer_name
ORDER BY invoice_count, c.customer_id
LIMIT 10;
