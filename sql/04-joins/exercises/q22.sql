-- q22 (stretch) — Which revenue accounts sit behind trade debtors?
--
-- Using the ledger alone, pair up each debit to trade debtors (1200)
-- with the revenue account credited in the same journal, and report how
-- many journals and how much value each pairing represents.
--
-- Expected output: Four columns — revenue_account, account_name,
-- journal_count, credited_gbp — one row per revenue account, largest first.
--
-- Hint: Self-join on journal_id, restrict one side to the debit on 1200 and
-- the other to a credit on a 4xxx account, then bring in the account name.

-- Write your query below. One statement, ending in a semicolon.

