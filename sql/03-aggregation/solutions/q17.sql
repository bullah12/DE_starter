-- q17 — How long has each customer been trading with us?
-- min() and max() work on dates. Subtracting the two aggregates gives whole
-- days, and you can do arithmetic on aggregates in the SELECT list.
SELECT
    customer_id,
    count(*)          AS invoice_count,
    min(due_date)     AS first_due,
    max(due_date)     AS last_due,
    max(due_date) - min(due_date) AS days_span
FROM invoices
WHERE invoice_type = 'SALES'
GROUP BY customer_id
ORDER BY days_span DESC, customer_id;

-- A customer with a span of a few days and one invoice is a one-off sale. A
-- customer with a three-year span and four invoices is a relationship that
-- has gone quiet. The count and the span together say more than either alone.
