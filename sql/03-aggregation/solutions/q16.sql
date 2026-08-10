-- q16 — Invoice value bands by count
--
-- floor(x / 1000) turns a value into a band number. Grouping by a computed
-- band is how you build a histogram, and it is the same idea as the ageing
-- buckets you will build properly with CASE in topic 07.
--
-- Note the band filter is in HAVING rather than WHERE because it is stated in
-- terms of the band. You could equally put gross_amount_gbp < 11000 in WHERE;
-- both work, and the WHERE version is faster because it discards rows earlier.
SELECT
    floor(gross_amount_gbp / 1000)  AS band,
    count(*)                        AS invoice_count,
    round(sum(gross_amount_gbp), 2) AS total_gbp
FROM invoices
WHERE invoice_type = 'SALES'
  AND gross_amount_gbp >= 0
GROUP BY floor(gross_amount_gbp / 1000)
HAVING floor(gross_amount_gbp / 1000) <= 10
ORDER BY band;
