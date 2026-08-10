-- q20 — A staff directory line
-- Four literals and three columns, all joined with ||. Fiddly, and worth
-- doing once by hand so that you can spot a missing space at fifty paces.
SELECT
    first_name || ' ' || last_name || ' (' || job_title || ')' AS directory_line,
    round(annual_salary_gbp / 12, 2)                           AS monthly_gbp
FROM employees
ORDER BY annual_salary_gbp DESC, employee_id
LIMIT 10;

-- ALTERNATIVE: concat(first_name, ' ', last_name) does the same job and
-- copes better with NULLs — || returns NULL if any part is NULL, which would
-- wipe out the whole line for an employee with no job title. Worth knowing
-- before you use || on a column that can be empty.
