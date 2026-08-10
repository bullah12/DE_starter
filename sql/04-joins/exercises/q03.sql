-- q03 (warmup) — Ledger lines per cost centre
--
-- How many general ledger lines does each cost centre carry? Every cost
-- centre must appear, including any with no activity at all.
--
-- Expected output: Three columns — cost_centre_code, cost_centre_name,
-- line_count — one row per cost centre, code order.
--
-- Hint: cost_centres is the population, so it goes first and the join is a
-- LEFT JOIN. Count a column from the ledger, not count(*).

-- Write your query below. One statement, ending in a semicolon.

