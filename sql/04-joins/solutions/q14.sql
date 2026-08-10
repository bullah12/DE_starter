-- q14 — Invoices where the cash does not agree
--
-- WHY THIS SHAPE
-- Compare in the *invoice currency*. The GBP columns are converted at
-- different dates — the invoice at its invoice date, the payment at its
-- payment date — so for every euro and dollar invoice they legitimately
-- differ by the FX movement. Comparing those would return hundreds of rows
-- and tell you nothing.
--
-- i.gross_amount is repeated on every joined row, so it goes in the GROUP BY
-- and can then be used directly in the HAVING and the SELECT.

SELECT
    i.invoice_id,
    i.invoice_type,
    i.gross_amount                              AS invoice_gross,
    round(sum(p.amount), 2)                     AS paid,
    round(sum(p.amount) - i.gross_amount, 2)    AS difference
FROM invoices AS i
INNER JOIN payments AS p
        ON p.invoice_id = i.invoice_id
GROUP BY i.invoice_id, i.invoice_type, i.gross_amount
HAVING sum(p.amount) <> i.gross_amount
ORDER BY difference DESC, i.invoice_id;

-- Three rows, each paid exactly twice. These are the duplicate payment rows
-- from the data quality list, seen from the business end: on this evidence
-- the company appears to have paid two suppliers twice and been paid twice by
-- a customer. In real life that is a phone call, not a footnote.
