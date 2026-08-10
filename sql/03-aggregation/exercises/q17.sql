-- q17 (core) — How long has each customer been trading with us?
--
-- For every customer with sales invoices, the number of invoices, the
-- earliest and latest due date, and the number of days between them.
--
-- Expected output: Five columns — customer_id, invoice_count, first_due,
-- last_due, days_span — longest span first then customer_id.
--
-- Hint: min() and max() work on dates. Subtracting one date from another
-- gives whole days, and you can subtract two aggregates.

-- Write your query below. One statement, ending in a semicolon.

