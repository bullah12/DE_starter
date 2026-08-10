-- q07 (warmup) — Headcount by cost centre, including the unassigned
--
-- HR wants headcount and total salary by cost centre. Four employees
-- have no cost centre on file and must still be visible.
--
-- Expected output: Three columns — cost_centre_name, headcount,
-- total_salary — one row per cost centre plus one row where the name is
-- NULL, biggest salary bill first.
--
-- Hint: employees is the population. Group by the cost centre name from the
-- joined table, which will be NULL for the unassigned four.

-- Write your query below. One statement, ending in a semicolon.

