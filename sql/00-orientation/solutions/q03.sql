-- q03 — How many invoices?
-- count(*) counts rows, including rows that are entirely NULL. It is the
-- number to write down before you start work, so you can prove later that you
-- have not lost any.
SELECT count(*) AS invoice_rows
FROM invoices;
