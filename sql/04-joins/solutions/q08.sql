-- q08 — Receipts with their customer
--
-- WHY THIS SHAPE
-- Three tables in a chain: payments -> invoices -> customers. Each step is an
-- INNER JOIN because every payment has an invoice and (almost) every invoice
-- has a customer.
--
-- Build this one join at a time. Write payments alone, check the row count,
-- add invoices, check it again, then add customers. If a count moves when you
-- did not expect it to, stop and find out why before adding the next table.

SELECT
    p.payment_id,
    p.payment_date,
    c.customer_id,
    c.customer_name,
    p.amount_gbp
FROM payments AS p
INNER JOIN invoices  AS i ON i.invoice_id  = p.invoice_id
INNER JOIN customers AS c ON c.customer_id = i.customer_id
WHERE p.direction = 'RECEIPT'
  AND p.payment_date >= DATE '2024-01-01'
  AND p.payment_date <  DATE '2025-01-01'
ORDER BY p.payment_date, p.payment_id
LIMIT 10;

-- Date ranges are written as >= start AND < the day after the end. It reads
-- awkwardly at first but it is the form that never goes wrong, including when
-- a column later turns out to hold a time as well as a date.
