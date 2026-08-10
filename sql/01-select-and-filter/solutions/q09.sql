-- q09 — The biggest VAT elements
--
-- "Worked out from gross less net rather than trusting the tax column" is the
-- interesting part of this question. Deriving a figure two ways and comparing
-- is how you find out whether a column means what it says.
SELECT
    invoice_id,
    net_amount,
    gross_amount,
    gross_amount - net_amount AS tax_element
FROM invoices
ORDER BY tax_element DESC, invoice_id
LIMIT 15;

-- ORDER BY can see the alias tax_element. WHERE cannot — it runs before the
-- SELECT list is evaluated. That ordering is topic 12.
