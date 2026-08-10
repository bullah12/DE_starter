-- Example 3: arithmetic across columns, and rounding
--
-- Checking that net + tax = gross is a control, not a curiosity. Run it on
-- any invoice extract you are given.

SELECT
    invoice_id,
    net_amount,
    tax_amount,
    net_amount + tax_amount        AS recalculated_gross,
    gross_amount,
    round(tax_amount / net_amount * 100, 1) AS effective_vat_pct
FROM invoices
ORDER BY invoice_id
LIMIT 6;
