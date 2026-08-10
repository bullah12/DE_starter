-- q04 — Headcount and salary by cost centre code
--
-- The four employees with no cost centre form their own group, keyed on NULL.
-- GROUP BY treats all NULLs as one group even though NULL = NULL is never
-- true in a comparison. It is an inconsistency, and it is the useful
-- behaviour.
SELECT
    cost_centre_code,
    count(*)                 AS headcount,
    sum(annual_salary_gbp)   AS total_salary
FROM employees
GROUP BY cost_centre_code
ORDER BY cost_centre_code NULLS LAST;
