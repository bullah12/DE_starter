-- q15 — Payroll cost by cost centre and fiscal year
--
-- WHY THIS SHAPE
-- Accounts 6000, 6010 and 6020 are gross pay, employer NI and pension. IN is
-- the readable way to say "any of these three".
--
-- The payroll journal posts the cost lines against cost centres and the
-- control lines (PAYE, pension creditor, net pay) with no cost centre at all.
-- Filtering to the three cost accounts sidesteps that, so an INNER JOIN to
-- cost_centres loses nothing. Drop the account filter and you would silently
-- lose the control lines instead.

SELECT
    je.fiscal_year,
    cc.cost_centre_name,
    count(*)                             AS line_count,
    round(sum(gl.debit - gl.credit), 2)  AS payroll_gbp
FROM general_ledger AS gl
INNER JOIN journal_entries AS je ON je.journal_id       = gl.journal_id
INNER JOIN cost_centres    AS cc ON cc.cost_centre_code = gl.cost_centre_code
WHERE gl.account_code IN (6000, 6010, 6020)
GROUP BY je.fiscal_year, cc.cost_centre_name
ORDER BY je.fiscal_year, cc.cost_centre_name;

-- FY2022 covers only January to March 2022 in this dataset, so its numbers
-- are a quarter of a year. Fiscal years that are not full years are a classic
-- source of "why has our payroll collapsed" questions.
