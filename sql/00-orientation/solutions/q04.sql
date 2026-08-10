-- q04 — How many payments?
SELECT count(*) AS payment_rows
FROM payments;

-- 3,050 rows, of which three are duplicates (see q08). A row count on its own
-- never tells you the data is right — only that you know how much of it there
-- is.
