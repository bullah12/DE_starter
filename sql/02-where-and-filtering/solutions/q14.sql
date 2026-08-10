-- q14 — Customers on unusual terms
--
-- This is the NULL trap with money attached. payment_terms_days <> 30 finds
-- the customers on 14, 45, 60 and 90 day terms — and silently drops the four
-- with no terms recorded at all, who are precisely the ones nobody has ever
-- agreed terms with.
--
-- OR payment_terms_days IS NULL puts them back.
SELECT customer_id, customer_name, payment_terms_days, is_active
FROM customers
WHERE is_active = 'Y'
  AND (payment_terms_days <> 30 OR payment_terms_days IS NULL)
ORDER BY payment_terms_days NULLS LAST, customer_id;

-- The brackets around the OR are not optional. Without them, AND binds first
-- and the query means "active customers not on 30 days, OR anyone at all with
-- no terms" — which would include inactive accounts.
