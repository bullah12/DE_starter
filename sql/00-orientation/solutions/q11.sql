-- q11 — How many ledger lines have a cost centre?
-- 231 lines have no cost centre — mostly payroll control postings, which are
-- company-wide by nature. They will silently disappear from any analysis
-- grouped by cost centre, and the total will no longer tie to the ledger.
SELECT
    count(*)                AS ledger_lines,
    count(cost_centre_code) AS with_cost_centre
FROM general_ledger;
