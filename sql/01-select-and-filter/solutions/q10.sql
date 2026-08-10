-- q10 — The largest postings, either way round
--
-- Without abs() you would rank by the signed movement and get the ten largest
-- debits, with every large credit sitting at the far end of the sort where
-- you cannot see it. Absolute value is the right lens whenever "big" means
-- "big in either direction".
SELECT
    gl_id,
    journal_id,
    account_code,
    debit - credit           AS movement,
    abs(debit - credit)      AS abs_movement
FROM general_ledger
ORDER BY abs_movement DESC, gl_id
LIMIT 10;
