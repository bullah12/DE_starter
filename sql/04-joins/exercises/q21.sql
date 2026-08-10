-- q21 (stretch) — Cost of the duplicate payments
--
-- Quantify the damage done by the duplicated payment rows: for each
-- affected invoice, the number of payment rows, the value that should
-- have been recorded, and the overstatement.
--
-- Expected output: Four columns — invoice_id, payment_rows, correct_gbp,
-- overstatement_gbp — one row per affected invoice, invoice_id order.
--
-- Hint: You need the invoice value once, not once per payment row. min() or
-- max() of a repeated value gives you the value itself.

-- Write your query below. One statement, ending in a semicolon.

