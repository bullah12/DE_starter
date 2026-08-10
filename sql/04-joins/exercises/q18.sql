-- q18 (core) — The credit control list
--
-- For every customer with at least one unpaid sales invoice, how many
-- are outstanding and what do they total? Credit control works this list
-- top down.
--
-- Expected output: Four columns — customer_id, customer_name,
-- unpaid_invoices, outstanding_gbp — one row per customer with unpaid
-- invoices, largest outstanding first.
--
-- Hint: Anti-join invoices to payments first to isolate the unpaid ones,
-- then join customers on and group. The customer whose account does not
-- exist cannot appear — decide whether that bothers you.

-- Write your query below. One statement, ending in a semicolon.

