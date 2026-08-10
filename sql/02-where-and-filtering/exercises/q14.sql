-- q14 (core) — Customers on unusual terms
--
-- Active customers whose payment terms are not the standard 30 days —
-- including any where the terms are missing entirely, because those
-- need chasing too.
--
-- Expected output: Four columns — customer_id, customer_name,
-- payment_terms_days, is_active — terms then customer_id, NULLs last.
--
-- Hint: This is the <> and NULL problem from example 6. Two conditions, one
-- of them about absence.

-- Write your query below. One statement, ending in a semicolon.

