-- q12 (core) — Cost of sales by cost centre, FY2024
--
-- Cost of sales (report_section = 'Cost of Sales') for fiscal year 2024,
-- by cost centre name. Ignore journals that are still in draft.
--
-- Expected output: Three columns — cost_centre_name, line_count, total_gbp
-- — one row per cost centre with cost of sales, largest first.
--
-- Hint: Four tables: general_ledger, journal_entries (for fiscal_year and
-- status), chart_of_accounts (for the section) and cost_centres (for the
-- name).

-- Write your query below. One statement, ending in a semicolon.

