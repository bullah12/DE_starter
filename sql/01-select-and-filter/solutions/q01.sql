-- q01 — A readable chart of accounts
-- AS is cosmetic and it matters. The person reading this has no idea what
-- account_type means; "type" they can guess.
SELECT
    account_code AS code,
    account_name AS account,
    account_type AS type
FROM chart_of_accounts
ORDER BY account_code
LIMIT 12;
