-- q05 — Payments by method
-- Eight groups for four methods. Every one of these totals is understated,
-- because its lower case twin is sitting in a different row. A report built
-- straight off this would be quietly wrong in a way nobody spots.
SELECT
    method,
    count(*)              AS payment_count,
    round(sum(amount_gbp), 2) AS total_gbp
FROM payments
GROUP BY method
ORDER BY payment_count DESC, method;
