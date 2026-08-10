-- q14 — Page three of the invoice list
--
-- Page 1 is rows 1-20 (OFFSET 0), page 2 is 21-40 (OFFSET 20), page 3 is
-- 41-60 (OFFSET 40). The offset is (page - 1) * page_size, and getting it
-- wrong shows up as a report that quietly repeats or skips a page.
SELECT
    invoice_id,
    due_date,
    gross_amount
FROM invoices
ORDER BY invoice_id
LIMIT 20 OFFSET 40;
