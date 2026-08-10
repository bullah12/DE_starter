-- q12 — Monthly salary cost
-- Without round(), monthly_gbp comes back as 7418.583333333333. Not wrong,
-- just unusable.
SELECT
    employee_id,
    last_name || ', ' || first_name        AS employee,
    annual_salary_gbp,
    round(annual_salary_gbp / 12, 2)       AS monthly_gbp
FROM employees
ORDER BY annual_salary_gbp DESC, employee_id
LIMIT 12;
