-- q14 — The ten highest salaries
-- You can sort by a column you did not select. The database sorts the rows,
-- then hands you the columns you asked for.
SELECT last_name, first_name, job_title, annual_salary_gbp
FROM employees
ORDER BY annual_salary_gbp DESC, employee_id
LIMIT 10;
