-- q16 (core) — Invoice value bands by count
--
-- How many sales invoices fall in each thousand-pound band of gross
-- GBP value, up to the tenth band? Band 0 is under £1,000, band 1 is
-- £1,000 to £1,999, and so on.
--
-- Expected output: Three columns — band, invoice_count, total_gbp — band
-- order, bands 0 to 10 only.
--
-- Hint: Integer division by 1000 gives the band. floor(x / 1000) or x //
-- 1000 both work.

-- Write your query below. One statement, ending in a semicolon.

