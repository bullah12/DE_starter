-- q22 — The other end of the distribution
--
-- The smallest value is SI-2022-90001, a credit note, with status CREDITED
-- and negative amounts throughout. It is stored in the invoices table because
-- that is where the accounting system puts it, and it will quietly reduce any
-- revenue total you compute — which is correct, and which you should know
-- about rather than discover.
SELECT
    invoice_id,
    invoice_type,
    status,
    gross_amount_gbp
FROM invoices
ORDER BY gross_amount_gbp, invoice_id
LIMIT 10;

-- Sorting ascending as well as descending on any new numeric column takes ten
-- seconds and finds negatives, zeroes and placeholder values like -1 or
-- 999999. Do both, every time.
