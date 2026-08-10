-- q20 — Oldest unpaid invoices at the year end
--
-- WHY THIS SHAPE
-- Anti-join for "unpaid", then a LEFT JOIN to customers rather than an INNER
-- one. That is the judgement call the question was hinting at.
--
-- SI-2023-90002 belongs to customer C2999, who does not exist in the customer
-- master. An INNER JOIN would drop it — and it is one of the oldest debts on
-- the list. An unidentified debtor is a *worse* problem than an identified
-- one, not a reason to hide it. So: LEFT JOIN, let the name come back NULL,
-- and flag it when you hand the report over.
--
-- Subtracting one DATE from another gives a whole number of days.

SELECT
    i.invoice_id,
    c.customer_name,
    c.country,
    i.due_date,
    DATE '2024-12-31' - i.due_date AS days_overdue
FROM invoices AS i
LEFT JOIN customers AS c
       ON c.customer_id = i.customer_id
LEFT JOIN payments AS p
       ON p.invoice_id = i.invoice_id
WHERE i.invoice_type = 'SALES'
  AND p.payment_id IS NULL
  AND i.due_date <= DATE '2024-12-31'
ORDER BY days_overdue DESC, i.invoice_id
LIMIT 15;

-- The due_date filter matters: without it, invoices not yet due would appear
-- with a negative days_overdue. They are unpaid, but they are not overdue,
-- and an ageing report that mixes the two is worse than no ageing report.
