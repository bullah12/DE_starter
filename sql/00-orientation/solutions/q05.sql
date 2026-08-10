-- q05 — The staff list
-- Two sort columns: surname first, and first_name only breaks ties within a
-- surname. Reading ORDER BY left to right is reading it in priority order.
SELECT last_name, first_name, job_title
FROM employees
ORDER BY last_name, first_name
LIMIT 12;
