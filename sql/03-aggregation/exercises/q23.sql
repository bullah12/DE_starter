-- q23 (stretch) — Does the sales ledger agree with the nominal ledger?
--
-- Compare, by calendar year, the total of sales invoices raised
-- (invoices table) with the revenue posted to the ledger (accounts 4000
-- to 4999). They should be close but not identical — explain the
-- difference in a comment.
--
-- Expected output: Four columns — year, invoiced_gbp, posted_gbp,
-- difference — year order.
--
-- Hint: Two independent aggregations that have to end up side by side. Two
-- subqueries and a join, or a UNION and a regroup. Both are later topics —
-- pick one, make it work, and note which parts you had to look up.

-- Write your query below. One statement, ending in a semicolon.

