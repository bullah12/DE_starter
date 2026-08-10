-- q12 — Overdue at the year end
--
-- Four spellings of "paid" exist in this column: 'PAID', 'Paid', 'paid' and
-- 'PAID ' with a trailing space. Excluding them one by one is possible and
-- awful. upper(trim(status)) collapses all four to one value, and then a
-- single comparison does the job.
--
-- The real lesson is in the question: nobody should be filtering on this
-- column at all. Settlement is a fact about the payments table. This query
-- answers what was asked; the right answer to the underlying business
-- question is the anti-join in topic 04.
SELECT invoice_id, due_date, status, currency, gross_amount_gbp
FROM invoices
WHERE invoice_type = 'SALES'
  AND due_date <= DATE '2024-11-30'
  AND upper(trim(status)) <> 'PAID'
ORDER BY due_date, invoice_id;
