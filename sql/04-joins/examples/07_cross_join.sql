-- Example 7: CROSS JOIN — building a report skeleton on purpose
--
-- Every cost centre against every quarter, whether or not anything happened.
-- 8 cost centres x 4 quarters = 32 rows, guaranteed, before any data is
-- joined on. This is how you stop a report quietly omitting an empty month.

SELECT
    cc.cost_centre_code,
    cc.cost_centre_name,
    q.quarter
FROM cost_centres AS cc
CROSS JOIN (SELECT unnest([1, 2, 3, 4]) AS quarter) AS q
ORDER BY cc.cost_centre_code, q.quarter;
