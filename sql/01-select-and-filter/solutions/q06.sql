-- q06 — Best paid staff, formatted
-- || joins text. The ', ' in the middle is a text literal in single quotes —
-- double quotes there would make DuckDB look for a column called ", ".
SELECT
    last_name || ', ' || first_name AS employee,
    job_title,
    annual_salary_gbp
FROM employees
ORDER BY annual_salary_gbp DESC, employee_id
LIMIT 10;
