-- q03 — Ledger lines per cost centre
--
-- WHY THIS SHAPE
-- "Every cost centre must appear" fixes the join type before you write a
-- word: cost_centres is the population, so it goes on the left and the ledger
-- is LEFT JOINed onto it.
--
-- count(gl.gl_id) rather than count(*) is the important detail. count(*)
-- counts rows, and an unmatched cost centre still produces one row — so a
-- cost centre with no activity would report 1 instead of 0. Counting a column
-- from the right-hand table ignores the NULLs and gives you 0.

SELECT
    cc.cost_centre_code,
    cc.cost_centre_name,
    count(gl.gl_id) AS line_count
FROM cost_centres AS cc
LEFT JOIN general_ledger AS gl
       ON gl.cost_centre_code = cc.cost_centre_code
GROUP BY cc.cost_centre_code, cc.cost_centre_name
ORDER BY cc.cost_centre_code;

-- Every cost centre happens to have activity here, so the LEFT JOIN and the
-- INNER JOIN give the same answer today. They would not next month, when
-- someone opens CC700. Write the join the question asks for, not the join
-- that happens to work.
