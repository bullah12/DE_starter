-- q19 — A complete cost centre by source grid
--
-- WHY THIS SHAPE
-- Two moves that go together whenever a report must show empty cells:
--   1. CROSS JOIN to build the skeleton — every cost centre against every
--      source, 8 x 5 = 40 rows, guaranteed, with no data involved.
--   2. LEFT JOIN the activity onto the skeleton, so combinations that never
--      happened survive with NULLs and count as zero.
--
-- The list of sources comes from a subquery (SELECT DISTINCT source ...),
-- which is topic 05. Read it as "a temporary five-row table of sources".

SELECT
    cc.cost_centre_code,
    s.source,
    count(gl.gl_id) AS line_count
FROM cost_centres AS cc
CROSS JOIN (SELECT DISTINCT source FROM journal_entries) AS s
LEFT JOIN journal_entries AS je
       ON je.source = s.source
LEFT JOIN general_ledger AS gl
       ON gl.journal_id = je.journal_id
      AND gl.cost_centre_code = cc.cost_centre_code
GROUP BY cc.cost_centre_code, s.source
ORDER BY cc.cost_centre_code, s.source;

-- Note the second condition on the last LEFT JOIN. The cost centre match has
-- to be part of the join, not a WHERE clause — put it in WHERE and every
-- combination with no activity disappears, which is exactly what the question
-- asked you to prevent.
--
-- The zeroes are the interesting cells: they say which cost centres never see
-- an AR journal, which is a control observation, not an absence of data.
