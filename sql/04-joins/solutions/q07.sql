-- q07 — Headcount by cost centre, including the unassigned
--
-- WHY THIS SHAPE
-- The four employees with no cost centre are the entire point of the
-- question, so employees must be the left table and the join must be LEFT.
--
-- Grouping by cc.cost_centre_name gives those four a group of their own, with
-- NULL as the key. NULL groups together in GROUP BY even though NULL never
-- equals NULL in a comparison — an inconsistency worth remembering.

SELECT
    cc.cost_centre_name,
    count(*)                        AS headcount,
    sum(e.annual_salary_gbp)        AS total_salary
FROM employees AS e
LEFT JOIN cost_centres AS cc
       ON cc.cost_centre_code = e.cost_centre_code
GROUP BY cc.cost_centre_name
ORDER BY total_salary DESC;

-- count(*) is right here: you are counting employees, and every employee is a
-- row on the left whether or not the join matched.
