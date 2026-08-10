-- q13 (core) — Unpaid sales invoices by due year
--
-- Sales invoices with no payment recorded against them at all, summarised
-- by the calendar year they fell due.
--
-- Expected output: Three columns — due_year, invoice_count, outstanding_gbp
-- — one row per year, earliest first.
--
-- Hint: An anti-join: LEFT JOIN to payments and keep the rows where no
-- payment matched. Do not trust invoices.status.

-- Write your query below. One statement, ending in a semicolon.

