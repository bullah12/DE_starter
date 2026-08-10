-- q13 — Which regions run which kinds of cost centre?
-- DISTINCT applies to the whole selected row. Two regions with the same type
-- stay as two rows; the same region and type twice collapses to one.
SELECT DISTINCT region, cost_centre_type
FROM cost_centres
ORDER BY region, cost_centre_type;
