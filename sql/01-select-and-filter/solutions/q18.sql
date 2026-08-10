-- q18 — A one-row control summary of the invoice table
--
-- 3,225 rows: 1,888 with a customer, 1,337 with a supplier. They add up
-- exactly, which proves every invoice has one counterparty and never both.
--
-- One query, three counts, and a structural fact about the table established
-- beyond argument. Do this on every table you are handed.
SELECT
    count(*)           AS invoice_rows,
    count(customer_id) AS with_customer,
    count(supplier_id) AS with_supplier
FROM invoices;

-- Had they NOT added up, there would be two possible causes: rows with
-- neither (orphans) or rows with both (a data model problem). Either is worth
-- a conversation before you build anything on top of the table.
