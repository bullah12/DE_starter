-- q19 (stretch) — A complete cost centre by source grid
--
-- Produce a grid of every cost centre against every journal source, with
-- the number of ledger lines for that combination — including the
-- combinations that have never occurred, which must show zero.
--
-- Expected output: Three columns — cost_centre_code, source, line_count — 8
-- cost centres x 5 sources = 40 rows, ordered by cost centre then source.
--
-- Hint: Build the skeleton first with a CROSS JOIN, then LEFT JOIN the
-- activity onto it. Where do the sources come from if you only have five of
-- them?

-- Write your query below. One statement, ending in a semicolon.

