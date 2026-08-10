-- q23 — Invoices due on the last day of a month
--
-- last_day(d) returns the last date in that date's month, handling short
-- months and leap years for you. Comparing the due date to it is exact, and
-- far safer than testing for day 30 or 31.
SELECT invoice_id, due_date, currency, gross_amount_gbp
FROM invoices
WHERE invoice_type = 'SALES'
  AND gross_amount_gbp > 30000
  AND due_date = last_day(due_date)
ORDER BY due_date, invoice_id;

-- Month-end due dates cluster because invoices raised on a month end with 30
-- or 60 day terms land on another month end. For cash forecasting that
-- concentration matters more than the average: the average says the cash
-- arrives smoothly, and it does not.
