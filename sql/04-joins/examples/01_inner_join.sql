-- Example 1: INNER JOIN — putting account names on ledger lines
--
-- The general ledger stores account_code but not account_name. This is the
-- VLOOKUP you would reach for in Excel, except SQL does it for every row at
-- once and complains if the key is ambiguous.

SELECT
    coa.account_code,
    coa.account_name,
    round(sum(gl.credit - gl.debit), 2) AS revenue_gbp
FROM general_ledger AS gl
INNER JOIN chart_of_accounts AS coa
       ON gl.account_code = coa.account_code
WHERE coa.account_type = 'INCOME'
  AND gl.entry_date >= DATE '2024-01-01'
  AND gl.entry_date <  DATE '2025-01-01'
GROUP BY coa.account_code, coa.account_name
ORDER BY revenue_gbp DESC;
