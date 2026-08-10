-- q08 — Payments that were not made by BACS
--
-- The naive answer, method <> 'BACS', also returns every row where the method
-- is 'bacs' in lower case — which IS a BACS payment. The fix is to compare
-- the upper-cased value, so both spellings are excluded.
--
-- method has no NULLs here (check with count(*) against count(method)), so
-- there is no missing-value trap in this one. Check rather than assume.
SELECT payment_id, payment_date, method, amount_gbp
FROM payments
WHERE upper(method) <> 'BACS'
ORDER BY payment_date, payment_id;

-- ALTERNATIVE: upper(method) NOT IN ('BACS') says the same thing and extends
-- more neatly when a second method has to be excluded next month.
