-- q03 — Does net plus tax equal gross?
-- Recomputing a stored figure and putting the two side by side is the
-- cheapest control there is. Here they agree on every row. On a client
-- extract they often do not, and that is your first finding.
SELECT
    invoice_id,
    net_amount,
    tax_amount,
    gross_amount,
    net_amount + tax_amount AS recalculated
FROM invoices
ORDER BY invoice_id
LIMIT 8;
