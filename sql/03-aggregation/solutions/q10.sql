-- q10 — Cost centre spend, top ten
--
-- There are only eight cost centres, so "top ten" returns nine rows: eight
-- plus the NULL group for lines with no cost centre. Leaving that group in is
-- deliberate — those costs are real, and dropping them would make the total
-- stop tying to the ledger.
--
-- If the FD wants eight rows, the right move is to ask where those costs
-- should sit, not to filter them out quietly.
SELECT
    cost_centre_code,
    count(*)                      AS line_count,
    round(sum(debit - credit), 2) AS spend_gbp
FROM general_ledger
WHERE account_code >= 5000
  AND entry_date >= DATE '2023-04-01'
  AND entry_date <  DATE '2024-04-01'
GROUP BY cost_centre_code
ORDER BY spend_gbp DESC, cost_centre_code NULLS LAST
LIMIT 10;
