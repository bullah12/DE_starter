-- q21 — Cost of the duplicate payments
--
-- WHY THIS SHAPE
-- The trap here is that the invoice value is repeated on every joined row. If
-- you write sum(i.gross_amount_gbp) you sum it once per payment row, and your
-- "correct" figure is as wrong as the wrong one.
--
-- max() (or min()) of a value that is constant within the group returns the
-- value itself, once. That is the standard fix and you will use it often.

SELECT
    i.invoice_id,
    count(*)                                              AS payment_rows,
    max(i.gross_amount_gbp)                               AS correct_gbp,
    round(sum(p.amount_gbp) - max(i.gross_amount_gbp), 2) AS overstatement_gbp
FROM invoices AS i
INNER JOIN payments AS p
        ON p.invoice_id = i.invoice_id
GROUP BY i.invoice_id
HAVING count(*) > 1
ORDER BY i.invoice_id;

-- Every overstatement equals the invoice value: each of these was recorded
-- exactly twice. Cash is overstated, the ledger and the bank statement will
-- not reconcile, and nothing in the database complains.
--
-- ALTERNATIVE: you could work entirely inside payments —
--     SELECT invoice_id, count(*), sum(amount_gbp) - min(amount_gbp)
--     FROM payments GROUP BY invoice_id HAVING count(*) > 1;
-- Fewer moving parts, but it takes the payment rows at face value. Joining to
-- the invoice checks the duplicated rows against an independent source, which
-- is the reconciliation habit and worth the extra join.
