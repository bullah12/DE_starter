-- Example 4: a self-join — finding the contra account
--
-- "What did we credit when we debited bank charges?" needs the ledger joined
-- to itself: one copy for the debit line, one for the credit line, matched on
-- the journal they share.

SELECT
    dr.journal_id,
    dr.account_code   AS debit_account,
    cr.account_code   AS credit_account,
    dr.debit          AS amount_gbp
FROM general_ledger AS dr
INNER JOIN general_ledger AS cr
        ON cr.journal_id = dr.journal_id
       AND cr.credit > 0
WHERE dr.account_code = 6520
  AND dr.debit > 0
ORDER BY dr.journal_id
LIMIT 5;
