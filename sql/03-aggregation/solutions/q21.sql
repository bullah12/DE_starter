-- q21 — Average invoice by month and type
--
-- due_date rather than invoice_date, because invoice_date is text in three
-- different formats and cannot be truncated to a month until it has been
-- cleaned (topic 09). Using the column that is already a DATE is not a
-- shortcut, it is the right call — but say so when you hand the report over,
-- because a due-date month is not an invoice-date month.
SELECT
    date_trunc('month', due_date)   AS month,
    invoice_type,
    count(*)                        AS invoice_count,
    round(avg(gross_amount_gbp), 2) AS average_gbp,
    round(sum(gross_amount_gbp), 2) AS total_gbp
FROM invoices
GROUP BY date_trunc('month', due_date), invoice_type
HAVING count(*) >= 20
ORDER BY month, invoice_type;
