-- q18 — Find the exactly duplicated supplier
--
-- Grouping by the id alone tells you an id repeats. Grouping by *every*
-- column proves the two rows are identical — which matters, because a
-- repeated id with different values is a different problem (a genuine change
-- someone re-keyed) from a repeated id with identical values (a load run
-- twice).
SELECT
    supplier_id, supplier_name, country, currency,
    payment_terms_days, created_date, is_active,
    count(*) AS times_it_appears
FROM suppliers
GROUP BY supplier_id, supplier_name, country, currency,
         payment_terms_days, created_date, is_active
HAVING count(*) > 1
ORDER BY supplier_id;

-- One row: S3003, loaded twice, byte for byte. That is an extraction problem,
-- not a data entry problem, and the fix belongs upstream.
