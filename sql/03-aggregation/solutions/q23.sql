-- q23 — Does the sales ledger agree with the nominal ledger?
--
-- Two independent aggregations, side by side. Each subquery in the FROM
-- clause produces one row per year, and the join lines them up. Subqueries
-- are topic 05 and joins are topic 04 — if you got here without either, a
-- perfectly good answer is to run the two halves separately and compare them
-- by eye. Knowing what the query has to do matters more than the syntax.
--
-- WHY THEY DIFFER, which is the real question:
--   * the invoice figures are GROSS, including VAT; the ledger figures are
--     NET revenue, because VAT is posted to 2100
--   * the invoice year here is the DUE date year, while the ledger year is
--     the posting date year, so invoices raised in December on 30 day terms
--     fall in different years on the two sides
--   * the credit note nets off in one and not the other
-- Any one of those explains a difference. A reconciliation is not complete
-- until you can name all three.
SELECT
    inv.year,
    inv.invoiced_gbp,
    gl.posted_gbp,
    round(inv.invoiced_gbp - gl.posted_gbp, 2) AS difference
FROM (
    SELECT year(due_date) AS year,
           round(sum(gross_amount_gbp), 2) AS invoiced_gbp
    FROM invoices
    WHERE invoice_type = 'SALES'
    GROUP BY year(due_date)
) AS inv
JOIN (
    SELECT year(entry_date) AS year,
           round(sum(credit - debit), 2) AS posted_gbp
    FROM general_ledger
    WHERE account_code BETWEEN 4000 AND 4999
    GROUP BY year(entry_date)
) AS gl ON gl.year = inv.year
ORDER BY inv.year;
