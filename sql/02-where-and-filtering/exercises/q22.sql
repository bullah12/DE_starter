-- q22 (stretch) — Which customer names are duplicated once you ignore the mess?
--
-- Two customer records are near-duplicates of existing accounts, hidden
-- behind different capitalisation and stray spaces. Find every customer
-- name that appears more than once after trimming the whitespace and
-- folding the case.
--
-- Expected output: Two columns — clean_name, times_it_appears — name order.
--
-- Hint: lower(trim(customer_name)) normalises the name. Group by the
-- normalised version, not the raw one. Strings are topic 09 — these two
-- functions are all you need here.

-- Write your query below. One statement, ending in a semicolon.

