-- q04 — Three specific accounts
-- IN is three ORs without the brackets to get wrong. Rent, rates and light
-- and heat: the property cost block.
SELECT gl_id, account_code, entry_date, debit
FROM general_ledger
WHERE account_code IN (6100, 6110, 6120)
  AND entry_date >= DATE '2023-01-01'
  AND entry_date <  DATE '2024-01-01'
ORDER BY entry_date, gl_id;
