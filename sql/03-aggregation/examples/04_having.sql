-- Example 4: HAVING filters groups, WHERE filters rows
--
-- WHERE runs first and decides which rows go into the groups. HAVING runs
-- last and decides which groups survive. You almost always need both.

SELECT
    account_code,
    count(*)   AS lines,
    round(sum(debit), 2) AS total_debit
FROM general_ledger
WHERE entry_date >= DATE '2024-01-01'
GROUP BY account_code
HAVING sum(debit) > 500000
ORDER BY total_debit DESC;
