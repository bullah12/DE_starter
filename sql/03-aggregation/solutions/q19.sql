-- q19 — Prove the ledger does not balance, and size the hole
--
-- The first three columns are straightforward. The fourth is the interesting
-- one: "how many journals are unbalanced" is a count of *groups*, not of
-- rows, and no aggregate can count groups from inside the same query.
--
-- So the inner query does the grouping, and the outer query counts its rows.
-- That is a subquery, which is topic 05 — this is a deliberate look ahead,
-- and the shape is worth recognising now: aggregate, then aggregate again.
SELECT
    (SELECT sum(debit)  FROM general_ledger)                AS total_debit,
    (SELECT sum(credit) FROM general_ledger)                AS total_credit,
    (SELECT sum(debit) - sum(credit) FROM general_ledger)   AS difference,
    (SELECT count(*) FROM (
        SELECT journal_id
        FROM general_ledger
        GROUP BY journal_id
        HAVING sum(debit) <> sum(credit)
     ))                                                     AS broken_journals;

-- Six journals, £531,351.70. That is the whole of the imbalance, and it is
-- now a finite list of things to investigate rather than a vague worry.
