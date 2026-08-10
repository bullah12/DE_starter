-- q09 — The twenty largest debits
-- Scanning the biggest numbers in a new dataset is a five-minute job that
-- routinely finds the decimal-point errors. Two of these are one of them.
SELECT gl_id, account_code, entry_date, debit
FROM general_ledger
ORDER BY debit DESC, gl_id
LIMIT 20;
