-- q04 — What currencies do we invoice in?
SELECT DISTINCT currency
FROM invoices
ORDER BY currency;

-- Three: EUR, GBP, USD. Clean, because currency codes came from a controlled
-- list. Compare with q05, where they did not.
