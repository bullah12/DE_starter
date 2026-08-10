-- The same test on suppliers, where the answer is different.
--
-- One supplier id appears twice. Anything joining to suppliers on this column
-- will double count that supplier. This test takes five seconds and saves
-- afternoons.

SELECT supplier_id, count(*) AS times_it_appears
FROM suppliers
GROUP BY supplier_id
HAVING count(*) > 1;
