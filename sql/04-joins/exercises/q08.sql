-- q08 (warmup) — Receipts with their customer
--
-- List the first ten customer receipts of 2024 by payment date, showing
-- which customer they came from.
--
-- Expected output: Five columns — payment_id, payment_date, customer_id,
-- customer_name, amount_gbp — ten rows, earliest first, then by payment_id.
--
-- Hint: payments joins to invoices on invoice_id, and invoices joins to
-- customers. Filter on direction.

-- Write your query below. One statement, ending in a semicolon.

