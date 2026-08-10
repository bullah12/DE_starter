-- q11 — Purchase spend by supplier country
--
-- WHY THIS SHAPE
-- WHERE filters rows before grouping; HAVING filters groups after. "Countries
-- where we spent more than 250,000" is a statement about the group, so it is
-- HAVING.
--
-- count(DISTINCT s.supplier_id) not count(*): every invoice would otherwise
-- count its supplier again, and you would report hundreds of suppliers per
-- country.

SELECT
    s.country,
    count(DISTINCT s.supplier_id)     AS supplier_count,
    round(sum(i.gross_amount_gbp), 2) AS total_gbp
FROM invoices AS i
INNER JOIN suppliers AS s
        ON s.supplier_id = i.supplier_id
WHERE i.invoice_type = 'PURCHASE'
GROUP BY s.country
HAVING sum(i.gross_amount_gbp) > 250000
ORDER BY total_gbp DESC;

-- The NULL country row is suppliers with no country on file. It is a real
-- group with real spend in it, and hiding it would understate the total. If
-- the FD wants it labelled, that is topic 07 (coalesce).
--
-- Careful: supplier S3003 is duplicated in the suppliers table, so its
-- invoices join twice and its spend is double counted. Try the query with
-- count(*) instead of count(DISTINCT ...) to see the same defect from the
-- other direction.
