-- q14 — Supplier concentration
-- Grouping the invoice table directly: the supplier master adds nothing here
-- except a name, and joining to it would risk the duplicate-supplier fan-out
-- from topic 00. Use the smallest set of tables that answers the question.
SELECT
    supplier_id,
    count(*)                        AS invoice_count,
    round(sum(gross_amount_gbp), 2) AS total_gbp,
    round(avg(gross_amount_gbp), 2) AS average_gbp
FROM invoices
WHERE invoice_type = 'PURCHASE'
GROUP BY supplier_id
HAVING sum(gross_amount_gbp) > 200000
ORDER BY total_gbp DESC, supplier_id;
