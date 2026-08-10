-- Example 2: expressions — a column that does not exist until you ask for it
--
-- debit and credit are stored separately. The signed movement is arithmetic
-- you do in the SELECT, exactly like a calculated column in Excel.

SELECT
    gl_id,
    account_code,
    debit,
    credit,
    debit - credit AS movement
FROM general_ledger
ORDER BY gl_id
LIMIT 6;
