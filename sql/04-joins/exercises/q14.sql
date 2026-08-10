-- q14 (core) — Invoices where the cash does not agree
--
-- Find every invoice where the total of the payments recorded against it
-- does not equal the invoice gross amount in GBP. Show the difference.
--
-- Expected output: Five columns — invoice_id, invoice_type, invoice_gbp,
-- paid_gbp, difference — one row per mismatched invoice, biggest difference
-- first.
--
-- Hint: Group the join by invoice, then use HAVING to keep only the rows
-- that disagree. Beware: this is the fan-out from the lesson.

-- Write your query below. One statement, ending in a semicolon.

