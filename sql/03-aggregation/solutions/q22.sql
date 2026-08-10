-- q22 — The cost of the missing cost centre
--
-- Two totals in one row: one filtered, one not. sum(...) FILTER (WHERE ...)
-- applies the condition to that aggregate alone, leaving the others to see
-- every row in the group.
--
-- Without FILTER you would need two queries and a join, or the CASE-based
-- conditional aggregation of topic 07 — which is what FILTER compiles to
-- anyway, and what you must use in databases that lack it.
SELECT
    account_code,
    count(*) FILTER (WHERE cost_centre_code IS NULL)                AS unattributed_lines,
    round(sum(debit + credit) FILTER (WHERE cost_centre_code IS NULL), 2)
                                                                    AS unattributed_gbp,
    round(sum(debit + credit), 2)                                   AS account_total_gbp,
    round(100.0 * sum(debit + credit) FILTER (WHERE cost_centre_code IS NULL)
          / sum(debit + credit), 2)                                 AS pct_unattributed
FROM general_ledger
GROUP BY account_code
HAVING count(*) FILTER (WHERE cost_centre_code IS NULL) > 0
ORDER BY unattributed_gbp DESC, account_code;

-- debit + credit rather than debit - credit, because here you want the gross
-- value that has gone missing from the cost centre analysis, not its
-- direction. Choosing the right measure is half of every reporting question.
