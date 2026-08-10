-- q17 — What did we pay out of the bank account?
--
-- WHY THIS SHAPE
-- A self-join: one copy of the ledger for the bank credit, another for the
-- debit lines in the same journal. The aliases cr and dr stop being optional.
--
--   cr  the credit side, pinned to account 1400 with credit > 0
--   dr  everything in the same journal with a debit on it
--
-- Then a third join to chart_of_accounts for the name of the debit account.
-- The same table can appear as many times as you need; each alias is treated
-- as an independent table.

SELECT
    dr.account_code,
    coa.account_name,
    count(DISTINCT cr.journal_id)       AS journal_count,
    round(sum(dr.debit), 2)             AS total_debited
FROM general_ledger AS cr
INNER JOIN general_ledger AS dr
        ON dr.journal_id = cr.journal_id
       AND dr.debit > 0
INNER JOIN chart_of_accounts AS coa
        ON coa.account_code = dr.account_code
WHERE cr.account_code = 1400
  AND cr.credit > 0
GROUP BY dr.account_code, coa.account_name
ORDER BY total_debited DESC, dr.account_code;

-- count(DISTINCT cr.journal_id) rather than count(*), because a journal with
-- several debit lines would otherwise be counted once per line.
--
-- The result is a plain-English description of where the money goes: trade
-- creditors, net pay, PAYE, VAT, bank charges. This is the query to run when
-- someone asks "what is actually leaving the bank account?"
