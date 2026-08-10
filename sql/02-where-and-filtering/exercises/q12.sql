-- q12 (core) — Overdue at the year end
--
-- Sales invoices that fell due on or before 30 November 2024 and are
-- still marked as anything other than paid. Take the status column at
-- face value for this question, casing and all.
--
-- Expected output: Five columns — invoice_id, due_date, status, currency,
-- gross_amount_gbp — due_date order then invoice_id.
--
-- Hint: 'PAID', 'Paid', 'paid' and 'PAID ' are four different strings. You
-- will need all four, and this is exactly why nobody should filter on this
-- column.

-- Write your query below. One statement, ending in a semicolon.

