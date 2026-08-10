-- q15 — Receipts in a single week
-- "1 to 7 July inclusive" becomes >= 1 July AND < 8 July. Say it out loud
-- when you write it: greater than or equal to the first, less than the day
-- after the last.
SELECT payment_id, payment_date, invoice_id, method, amount_gbp
FROM payments
WHERE direction = 'RECEIPT'
  AND payment_date >= DATE '2024-07-01'
  AND payment_date <  DATE '2024-07-08'
ORDER BY payment_date, payment_id;
