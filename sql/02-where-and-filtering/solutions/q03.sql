-- q03 — Ledger activity in March 2024
--
-- The date range is written as >= 1 March AND < 1 April rather than BETWEEN 1
-- and 31 March. Both give the same answer on a pure DATE column. Only one of
-- them keeps giving the right answer if the column ever gains a time
-- component, which is why it is the habit worth building.
SELECT gl_id, journal_id, account_code, entry_date, debit
FROM general_ledger
WHERE entry_date >= DATE '2024-03-01'
  AND entry_date <  DATE '2024-04-01'
  AND debit > 5000
ORDER BY entry_date, gl_id;
