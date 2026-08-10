-- Example 4: DISTINCT — what values are actually in this column?
--
-- The fastest way to find out that a column you assumed was clean contains
-- four spellings of the same thing.

SELECT DISTINCT status
FROM invoices
ORDER BY status;
