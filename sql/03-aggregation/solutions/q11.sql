-- q11 — Customer invoice profile
-- Four aggregates over one group. The average is the interesting one: two
-- customers with the same total can have completely different risk profiles
-- if one of them got there in three invoices and the other in ninety.
SELECT
    customer_id,
    count(*)                            AS invoice_count,
    round(sum(gross_amount_gbp), 2)     AS total_gbp,
    round(avg(gross_amount_gbp), 2)     AS average_gbp,
    max(gross_amount_gbp)               AS largest_gbp
FROM invoices
WHERE invoice_type = 'SALES'
GROUP BY customer_id
ORDER BY total_gbp DESC, customer_id;

-- C2999 appears — the customer who does not exist on the master file. The
-- invoices table knows about them; the customer table does not. Aggregating
-- one table at a time keeps that visible, and a join would have hidden it.
