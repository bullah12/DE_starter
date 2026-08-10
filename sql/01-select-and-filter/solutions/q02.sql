-- q02 — Signed ledger movements
-- movement is positive for debits and negative for credits, which suits
-- assets and expenses. For income and liabilities you would write
-- credit - debit instead. There is no universally right answer — only a right
-- answer for the account you are looking at.
SELECT
    gl_id,
    account_code,
    debit,
    credit,
    debit - credit AS movement
FROM general_ledger
ORDER BY gl_id
LIMIT 10;
