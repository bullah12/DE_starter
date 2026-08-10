-- q06 — Customers by owning cost centre
--
-- WHY THIS SHAPE
-- customers is the population and cost_centres is the lookup. Every customer
-- has a cost centre in this dataset, so INNER and LEFT agree; INNER states
-- the expectation that a customer without one would be a data error.

SELECT
    cc.cost_centre_name,
    count(*)                     AS customer_count,
    sum(c.credit_limit_gbp)      AS total_credit_limit
FROM customers AS c
INNER JOIN cost_centres AS cc
        ON cc.cost_centre_code = c.cost_centre_code
GROUP BY cc.cost_centre_name
ORDER BY total_credit_limit DESC;

-- Only the three sales cost centres appear, because only they own customer
-- accounts. Nothing is missing — the others genuinely have none.
