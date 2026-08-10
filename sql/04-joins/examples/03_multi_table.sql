-- Example 3: three tables at once — sales by region
--
-- invoices knows the customer. customers knows the cost centre. cost_centres
-- knows the region. Each join is a separate step, and the order you write the
-- joins in does not change the answer.

SELECT
    cc.region,
    count(*)                            AS invoices,
    round(sum(i.gross_amount_gbp), 2)   AS gross_gbp
FROM invoices AS i
INNER JOIN customers    AS c  ON c.customer_id = i.customer_id
INNER JOIN cost_centres AS cc ON cc.cost_centre_code = c.cost_centre_code
WHERE i.invoice_type = 'SALES'
GROUP BY cc.region
ORDER BY gross_gbp DESC;
