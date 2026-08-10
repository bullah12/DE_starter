-- q16 — Journals that do not balance
--
-- WHY THIS SHAPE
-- The test is at journal level: sum of debits against sum of credits per
-- journal_id. That is a HAVING clause, because it filters groups.
--
-- The header columns are needed in the output, so journal_entries has to be
-- joined in and every header column repeated in the GROUP BY. That feels
-- verbose. It is: SQL will not let you select a column it cannot prove is
-- constant within the group.

SELECT
    je.journal_id,
    je.journal_date,
    je.source,
    je.description,
    round(sum(gl.debit), 2)  AS total_debit,
    round(sum(gl.credit), 2) AS total_credit
FROM general_ledger AS gl
INNER JOIN journal_entries AS je
        ON je.journal_id = gl.journal_id
GROUP BY je.journal_id, je.journal_date, je.source, je.description
HAVING sum(gl.debit) <> sum(gl.credit)
ORDER BY je.journal_id;

-- Two of the six are out by a factor of ten — the classic decimal-point slip.
-- The other four are out by roughly 10%, which is the far more dangerous kind
-- because the journal still looks plausible at a glance.
--
-- This query is worth keeping. Run it against any ledger you are handed, on
-- day one, before you agree to anything.
