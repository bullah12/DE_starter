-- q23 (stretch) — Budget against actual, both ways round
--
-- For fiscal year 2025 period 1 (April 2024), compare budgeted cost
-- against actual cost by cost centre, keeping cost centres that appear on
-- only one side. Cost accounts are 5000 and above.
--
-- Expected output: Four columns — cost_centre_code, budget_gbp, actual_gbp,
-- variance_gbp — one row per cost centre appearing on either side, cost
-- centre code order. Missing sides show as 0.00.
--
-- Hint: A FULL JOIN between two aggregated sets. Each side has to be
-- aggregated before the join or you will fan out. This needs a subquery,
-- which is topic 05 — look at examples/06_full_join.sql and copy the shape.

-- Write your query below. One statement, ending in a semicolon.

