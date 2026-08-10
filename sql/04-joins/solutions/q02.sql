-- q02 — Ten largest sales invoices
--
-- WHY THIS SHAPE
-- One invoice has exactly one customer, so joining customers on cannot
-- multiply rows. Check that claim rather than assuming it:
--     SELECT customer_id, count(*) FROM customers
--     GROUP BY customer_id HAVING count(*) > 1;      -- returns nothing
--
-- Note this uses an INNER JOIN, which quietly drops SI-2023-90002 (customer
-- C2999 does not exist). It is not in the top ten anyway, but you should know
-- it happened rather than find out later.

SELECT
    i.invoice_id,
    c.customer_name,
    i.due_date,
    i.gross_amount_gbp
FROM invoices AS i
INNER JOIN customers AS c
        ON c.customer_id = i.customer_id
WHERE i.invoice_type = 'SALES'
ORDER BY i.gross_amount_gbp DESC, i.invoice_id
LIMIT 10;
