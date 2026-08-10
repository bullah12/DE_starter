-- Example 3: IN and BETWEEN
--
-- IN is a tidy way of writing several ORs. BETWEEN is inclusive at both ends
-- — which is exactly what you want for account code ranges and exactly what
-- catches people out with dates.

SELECT account_code, account_name, report_section
FROM chart_of_accounts
WHERE account_code BETWEEN 6000 AND 6099
   OR account_code IN (4000, 4010, 5000)
ORDER BY account_code;
