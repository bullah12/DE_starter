-- q18 — The credit control list
--
-- WHY THIS SHAPE
-- Two different join types in one query, each doing a different job.
--   LEFT JOIN to payments + WHERE p.payment_id IS NULL — the anti-join that
--     isolates the unpaid invoices.
--   INNER JOIN to customers — every unpaid invoice needs a name against it,
--     and a customer with nothing outstanding has no place on this list.
--
-- Group by customer_id as well as name, because the name is neither unique
-- nor clean. The id is the key.

SELECT
    c.customer_id,
    c.customer_name,
    count(*)                          AS unpaid_invoices,
    round(sum(i.gross_amount_gbp), 2) AS outstanding_gbp
FROM invoices AS i
LEFT JOIN payments AS p
       ON p.invoice_id = i.invoice_id
INNER JOIN customers AS c
        ON c.customer_id = i.customer_id
WHERE i.invoice_type = 'SALES'
  AND p.payment_id IS NULL
GROUP BY c.customer_id, c.customer_name
ORDER BY outstanding_gbp DESC, c.customer_id;

-- The invoice with the missing customer (SI-2023-90002, customer C2999) is
-- unpaid and is NOT on this list, because the INNER JOIN dropped it. That
-- should bother you: it is real money owed, and this report will never chase
-- it. Swap to a LEFT JOIN and it reappears with a NULL name — uglier, and
-- more honest. Which you ship depends on who reads it, but you should be the
-- one deciding rather than the join type deciding for you.
--
-- Note also that this counts invoices with no payment at all. Part payments
-- do not exist in this dataset, so that is the same thing as "outstanding"
-- here — but it would not be on a real ledger, and the query would need to
-- compare the sum of payments to the invoice value instead.
