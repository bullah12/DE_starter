-- q04 (warmup) — Customers we have never invoiced
--
-- Sales ledger wants a list of customer accounts with no sales invoice
-- against them at all — candidates for deactivation.
--
-- Expected output: Three columns — customer_id, customer_name, is_active —
-- one row per unused customer, customer_id order.
--
-- Hint: LEFT JOIN then keep the rows where the right-hand side came back
-- NULL. Which column do you test for NULL?

-- Write your query below. One statement, ending in a semicolon.

