-- q13 — Unpaid sales invoices by due year
--
-- WHY THIS SHAPE
-- Another anti-join. LEFT JOIN to payments, then keep only the invoices where
-- nothing matched.
--
-- The question says not to trust invoices.status, and it is right: the status
-- column is inconsistently cased and out of step with the cash. Settlement is
-- a fact about the payments table, so ask the payments table.

SELECT
    year(i.due_date)                  AS due_year,
    count(*)                          AS invoice_count,
    round(sum(i.gross_amount_gbp), 2) AS outstanding_gbp
FROM invoices AS i
LEFT JOIN payments AS p
       ON p.invoice_id = i.invoice_id
WHERE i.invoice_type = 'SALES'
  AND p.payment_id IS NULL
GROUP BY year(i.due_date)
ORDER BY due_year;

-- Note where the two conditions sit. i.invoice_type is a condition on the
-- LEFT table, so it belongs in WHERE. p.payment_id IS NULL is the anti-join
-- test, which also belongs in WHERE — it is the whole point of the query. A
-- condition on the right table that is NOT part of an anti-join would go in
-- ON instead. That distinction is worth re-reading until it sticks.
