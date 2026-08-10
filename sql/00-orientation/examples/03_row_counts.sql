-- How big is this table? Always the second question, after "what is in it".
--
-- count(*) counts rows. It is the =COUNTA() of SQL, and the first thing to
-- run when someone hands you a database.

SELECT count(*) AS ledger_lines
FROM general_ledger;
