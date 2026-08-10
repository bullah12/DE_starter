-- q16 — The report sections in use
-- Ten sections. This is the skeleton of the statutory accounts, and it is
-- also the answer to "how should this report be grouped" — the chart already
-- knows.
SELECT DISTINCT report_section
FROM chart_of_accounts
ORDER BY report_section;
