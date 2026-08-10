-- q08 — Is payment_id a key?
-- Three rows back. payment_id is *supposed* to be unique and is not.
--
-- Anything that joins to payments on this column will count those three
-- payments twice: cash overstated, bank reconciliation broken, and no error
-- message anywhere. This is the defect you will meet again in topic 04.
SELECT payment_id, count(*) AS times_it_appears
FROM payments
GROUP BY payment_id
HAVING count(*) > 1
ORDER BY payment_id;
