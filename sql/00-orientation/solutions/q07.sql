-- q07 — Is invoice_id a key?
-- No rows back means every invoice_id appears exactly once, so invoice_id is
-- a genuine key and is safe to join on. An empty result is an answer, and in
-- this case a reassuring one.
SELECT invoice_id, count(*) AS times_it_appears
FROM invoices
GROUP BY invoice_id
HAVING count(*) > 1
ORDER BY invoice_id;
