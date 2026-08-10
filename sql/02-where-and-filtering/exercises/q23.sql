-- q23 (stretch) — Invoices due on the last day of a month
--
-- Sales invoices over £30,000 falling due on the last day of any month.
-- Payment terms of 30 or 60 days from a month end cluster there, and it
-- matters for cash forecasting.
--
-- Expected output: Four columns — invoice_id, due_date, currency,
-- gross_amount_gbp — due_date then invoice_id.
--
-- Hint: last_day(d) returns the last date of that date's month. Compare the
-- due date with it.

-- Write your query below. One statement, ending in a semicolon.

