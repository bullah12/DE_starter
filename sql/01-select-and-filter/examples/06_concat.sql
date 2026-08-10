-- Example 6: building a label out of several columns
--
-- || glues text together. Anything you would do with CONCATENATE or & in
-- Excel, you do with || here. Deeper string work is topic 09.

SELECT
    employee_id,
    last_name || ', ' || first_name AS employee,
    job_title,
    annual_salary_gbp / 12 AS monthly_gbp
FROM employees
ORDER BY annual_salary_gbp DESC, employee_id
LIMIT 5;
