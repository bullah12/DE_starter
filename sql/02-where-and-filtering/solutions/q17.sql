-- q17 — The VAT control account
--
-- "More than 1,000 on either side" is an OR, and it has to be bracketed away
-- from the AND conditions around it. Without the brackets the query means
-- "VAT lines from April 2024 with a debit over 1,000, OR any line anywhere
-- with a credit over 1,000" — which is most of the ledger.
SELECT gl_id, journal_id, entry_date, line_description, debit, credit
FROM general_ledger
WHERE account_code = 2100
  AND entry_date >= DATE '2024-04-01'
  AND (debit > 1000 OR credit > 1000)
ORDER BY entry_date, gl_id;
