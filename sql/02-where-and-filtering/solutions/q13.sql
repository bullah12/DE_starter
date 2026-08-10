-- q13 — Operating expenses excluding payroll
--
-- NOT IN with a literal list is safe: the list contains no NULLs. NOT IN
-- against a subquery that might return a NULL is a different matter, and
-- returns nothing at all. That trap is waiting in topic 05.
SELECT gl_id, account_code, entry_date, debit
FROM general_ledger
WHERE account_code BETWEEN 6000 AND 6999
  AND account_code NOT IN (6000, 6010, 6020)
  AND entry_date >= DATE '2023-04-01'
  AND entry_date <  DATE '2024-04-01'
ORDER BY debit DESC, gl_id
LIMIT 20;
