-- q12 — Cost of sales by cost centre, FY2024
--
-- WHY THIS SHAPE
-- Four tables, each earning its place:
--   general_ledger  the numbers
--   journal_entries fiscal_year and status, which only exist on the header
--   chart_of_accounts  report_section, to identify cost of sales
--   cost_centres    the readable name
--
-- The status filter matters. Draft journals still have ledger lines, so
-- leaving them in inflates the cost. Nobody will tell you; the number will
-- just be wrong.

SELECT
    cc.cost_centre_name,
    count(*)                             AS line_count,
    round(sum(gl.debit - gl.credit), 2)  AS total_gbp
FROM general_ledger AS gl
INNER JOIN journal_entries   AS je  ON je.journal_id      = gl.journal_id
INNER JOIN chart_of_accounts AS coa ON coa.account_code   = gl.account_code
INNER JOIN cost_centres      AS cc  ON cc.cost_centre_code = gl.cost_centre_code
WHERE je.fiscal_year = 'FY2024'
  AND je.status = 'POSTED'
  AND coa.report_section = 'Cost of Sales'
GROUP BY cc.cost_centre_name
ORDER BY total_gbp DESC;

-- Note the cost centre comes from the ledger line, not from the journal
-- header — one journal can spread across several cost centres, and payroll
-- does exactly that.
