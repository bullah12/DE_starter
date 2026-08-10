-- Example 5: sorting by something you computed, and paging with OFFSET
--
-- You can ORDER BY an alias you defined in the same SELECT. OFFSET skips
-- rows, so this is the *second* page of five.

SELECT
    invoice_id,
    net_amount,
    gross_amount,
    gross_amount - net_amount AS tax_element
FROM invoices
ORDER BY tax_element DESC, invoice_id
LIMIT 5 OFFSET 5;
