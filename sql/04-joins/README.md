# SQL 04 — JOINs

## Why this matters

You have been asked for sales by region for 2024.

`invoices` has the amounts but not the region. `customers` has the cost centre
but not the region. `cost_centres` has the region. In Excel you would drop two
VLOOKUPs down the side of the invoice extract, drag them to the bottom, check
the `#N/A`s, and pivot. You know the shape of this problem already.

A join is that VLOOKUP, with three differences that matter enormously:

1. It applies to every row without being dragged, and it never quietly stops
   halfway down the range.
2. It can return **many rows**, not just the first match. This is its power and
   its single biggest trap.
3. You choose explicitly what happens to rows that do not match, instead of
   getting `#N/A` and dealing with it afterwards.

Everything in a real reporting stack is joins. Get comfortable here and the rest
of SQL is detail.

## The concept

A **join** combines rows from two tables by matching values in a column they
share — the **join key**. Here the key is usually an id: `customer_id`,
`account_code`, `journal_id`.

You write it as:

```sql
FROM invoices AS i
INNER JOIN customers AS c ON c.customer_id = i.customer_id
```

Read it as: for every row of `invoices`, find rows of `customers` where the ids
match, and stick them side by side.

`AS i` and `AS c` are **aliases** — short names for the tables, so you can write
`i.customer_id` instead of `invoices.customer_id`. Once a query has two tables
in it, prefix every column with its alias. It costs you three keystrokes and
saves you from the ambiguity errors below.

### The five join types

| Type | Keeps | Use it when |
|---|---|---|
| `INNER JOIN` | Only rows that match on both sides | You want facts with their attributes and unmatched rows are errors |
| `LEFT JOIN` | All rows from the left table, matched or not | The left table is the population you were asked about |
| `RIGHT JOIN` | All rows from the right table | Almost never — swap the tables and use LEFT instead |
| `FULL JOIN` | Everything from both sides | Reconciling two lists where either side can be missing |
| `CROSS JOIN` | Every combination of both | Building a skeleton: every cost centre × every month |

Where a `LEFT JOIN` finds no match, the right-hand columns come back **NULL** —
SQL's `#N/A`. That is not an error, it is the answer.

The choice between `INNER` and `LEFT` is a business decision, not a technical
one. "Sales by customer" for customers who bought nothing: `INNER` drops them,
`LEFT` shows them at zero. Which one is right depends entirely on who is asking
and why. Decide deliberately.

---

## Worked examples

Run each one:

```bash
python tools/run_sql.py sql/04-joins/examples/01_inner_join.sql
```

### 1. INNER JOIN — account names onto ledger lines

```sql
SELECT
    coa.account_code,
    coa.account_name,
    round(sum(gl.credit - gl.debit), 2) AS revenue_gbp
FROM general_ledger AS gl
INNER JOIN chart_of_accounts AS coa
       ON gl.account_code = coa.account_code
WHERE coa.account_type = 'INCOME'
  AND gl.entry_date >= DATE '2024-01-01'
  AND gl.entry_date <  DATE '2025-01-01'
GROUP BY coa.account_code, coa.account_name
ORDER BY revenue_gbp DESC;
```

```
┌──────────────┬───────────────────────────┬───────────────┐
│ account_code │       account_name        │  revenue_gbp  │
├──────────────┼───────────────────────────┼───────────────┤
│         4000 │ Sales - Components UK     │    3378953.62 │
│         4010 │ Sales - Components Export │    2092415.98 │
│         4020 │   Sales - Services        │    1103555.69 │
│         4030 │ Sales - Spare Parts       │    1004694.19 │
└──────────────┴───────────────────────────┴───────────────┘
```

Line by line:

- `FROM general_ledger AS gl` — the **fact** table, the one with the numbers.
  Start here. 16,872 rows.
- `INNER JOIN chart_of_accounts AS coa ON gl.account_code = coa.account_code` —
  attach the account record. `chart_of_accounts` has one row per account, so
  this adds columns without adding rows.
- `WHERE coa.account_type = 'INCOME'` — note this filters on a column from the
  *joined* table. Perfectly legal; by the time `WHERE` runs, the tables are one.
- `sum(gl.credit - gl.debit)` — income accounts are credit-normal, so this way
  round gives a positive figure.
- `GROUP BY coa.account_code, coa.account_name` — both non-aggregated columns
  must appear, as you learned in topic 03.

`Sales - Services` prints indented because its name in the source has leading
whitespace. Defect 5 in `data/README.md`. Ignore it for now; topic 09 cleans it.

### 2. LEFT JOIN — including the customers who bought nothing

```sql
SELECT
    c.customer_id,
    c.customer_name,
    count(i.invoice_id)                            AS invoice_count,
    round(coalesce(sum(i.gross_amount_gbp), 0), 2) AS invoiced_gbp
FROM customers AS c
LEFT JOIN invoices AS i
       ON i.customer_id = c.customer_id
      AND i.invoice_type = 'SALES'
      AND i.due_date >= DATE '2024-01-01'
GROUP BY c.customer_id, c.customer_name
ORDER BY invoice_count, c.customer_id
LIMIT 10;
```

```
┌─────────────┬────────────────────────────┬───────────────┬───────────────┐
│ customer_id │       customer_name        │ invoice_count │ invoiced_gbp  │
├─────────────┼────────────────────────────┼───────────────┼───────────────┤
│ C2033       │   THORNCLIFF MOTORS LTD    │             0 │          0.00 │
│ C2900       │ FALKIRK MOTORS BV          │             0 │          0.00 │
│ C2901       │ Halcyon Utilities Ltd      │             0 │          0.00 │
│ C2059       │ Trentham Contracts SARL    │             5 │      89347.38 │
│ ...         │                            │               │               │
└─────────────┴────────────────────────────┴───────────────┴───────────────┘
```

Three things worth pausing on.

**The filters are in the `ON` clause, not `WHERE`.** This is the detail that
catches everyone. Conditions on the *right-hand* table of a `LEFT JOIN` belong
in `ON`. Move `i.due_date >= DATE '2024-01-01'` into a `WHERE` and the three
zero-invoice customers vanish, because their `i.due_date` is NULL and NULL fails
every comparison. Your `LEFT JOIN` silently becomes an `INNER JOIN`.

**`count(i.invoice_id)` gives 0, `count(*)` would give 1.** `count(*)` counts
rows, and an unmatched left row is still a row. `count(some_column)` skips
NULLs. Count the column when you are counting matches.

**`coalesce(sum(...), 0)`** turns the NULL total into 0.00. You will meet
`coalesce` properly in topic 07; for now, read it as "use the first of these
that is not NULL".

Note the top three rows: `C2900` and `C2901` are the duplicate customer records
from the data quality list, which have no invoices because the trade sits under
the original ids.

### 3. Three tables — sales by region

```sql
FROM invoices AS i
INNER JOIN customers    AS c  ON c.customer_id = i.customer_id
INNER JOIN cost_centres AS cc ON cc.cost_centre_code = c.cost_centre_code
WHERE i.invoice_type = 'SALES'
```

```
┌────────────┬──────────┬───────────────┐
│   region   │ invoices │   gross_gbp   │
├────────────┼──────────┼───────────────┤
│ South East │     1140 │   13151082.86 │
│ North West │      747 │    9991788.44 │
└────────────┴──────────┴───────────────┘
```

Joins chain. The second join can use any table already in the query — here it
matches on a column that came from `customers`, not from `invoices`. Build these
one join at a time: write it, run it, check the row count has not moved, then
add the next.

The sales total is 1,887 invoices, but there are 1,888 sales invoices in the
table. The missing one is `SI-2023-90002`, whose customer `C2999` does not
exist, so the `INNER JOIN` dropped it. That is the trap: no error, no warning,
just a number that is slightly wrong. Rerun it as a `LEFT JOIN` and it comes
back with a NULL region.

### 4. Self-join — finding the contra account

```sql
FROM general_ledger AS dr
INNER JOIN general_ledger AS cr
        ON cr.journal_id = dr.journal_id
       AND cr.credit > 0
WHERE dr.account_code = 6520
  AND dr.debit > 0
```

```
┌───────────────┬───────────────┬────────────────┬───────────────┐
│  journal_id   │ debit_account │ credit_account │  amount_gbp   │
├───────────────┼───────────────┼────────────────┼───────────────┤
│ JE-2022-00089 │          6520 │           1400 │        385.15 │
│ JE-2022-00210 │          6520 │           1400 │        504.69 │
└───────────────┴───────────────┴────────────────┴───────────────┘
```

A **self-join** joins a table to itself. Nothing special happens — SQL treats
`dr` and `cr` as two independent tables that happen to hold the same rows. The
aliases stop being a nicety and become mandatory.

This is how you answer "what was the other side of that entry?", which is the
question you actually ask when investigating a strange balance.

### 5. The join that duplicates rows

This is the most important example in the topic.

```sql
SELECT count(*) AS joined_rows, count(DISTINCT i.invoice_id) AS distinct_invoices
FROM invoices AS i
INNER JOIN payments AS p ON p.invoice_id = i.invoice_id;
```

```
┌─────────────┬───────────────────┐
│ joined_rows │ distinct_invoices │
├─────────────┼───────────────────┤
│        3050 │              3047 │
└─────────────┴───────────────────┘
```

Three extra rows. Step 2 finds them:

```
┌───────────────┬──────────────┐
│  invoice_id   │ payment_rows │
├───────────────┼──────────────┤
│ PI-2022-00048 │            2 │
│ PI-2022-00102 │            2 │
│ SI-2022-00313 │            2 │
└───────────────┴──────────────┘
```

Steps 3 and 4 price the damage on those three invoices:

```
settled via the join:   55,651.84
settled from invoices:  27,825.92
```

Exactly double. **A join multiplies rows whenever the key is not unique on the
side you are joining to.** The database does not consider this an error and will
not warn you. Your total is simply wrong, and it looks entirely plausible.

The habit that saves you, every time:

> Before you trust a joined total, know the **grain** of both tables — what one
> row means — and confirm the key is unique on the "one" side.

```sql
-- run this before joining to anything
SELECT invoice_id, count(*) FROM payments GROUP BY invoice_id HAVING count(*) > 1;
```

If that returns nothing, your join is safe. If it returns rows, decide what to
do about them before you go any further.

### 6 and 7. FULL JOIN and CROSS JOIN

`06_full_join.sql` compares FY2025 period 1 budget against April 2024 actuals
and keeps only the rows that failed to match — accounts with a budget and no
spend, and accounts with spend and no budget. Both directions matter, and only
`FULL JOIN` gives you both at once. (That example uses a subquery, which is
topic 05. Read each bracketed block as a small temporary table of totals.)

`07_cross_join.sql` multiplies 8 cost centres by 4 quarters to get 32 rows with
no join key at all. Deliberate `CROSS JOIN`s build report skeletons, so an empty
month appears as a zero rather than disappearing. Accidental ones — usually a
missing `ON` clause — produce millions of rows and a hanging query.

---

## Common mistakes

**Ambiguous column.**

```sql
SELECT account_code FROM general_ledger gl JOIN chart_of_accounts coa
  ON gl.account_code = coa.account_code;
```
```
Binder Error: Ambiguous reference to column name "account_code"
(use: "gl.account_code" or "coa.account_code")
```
Both tables have that column. Say which one. DuckDB even tells you the options.

**Missing table alias.**
```
Binder Error: Referenced table "c" not found!
Candidate tables: "customers"
```
You wrote `c.customer_id` but never wrote `AS c`.

**Filtering the right-hand table of a LEFT JOIN in WHERE.** No error at all —
just fewer rows than you expected. If a `LEFT JOIN` returns exactly the same row
count as the `INNER JOIN` version, this is why.

**Forgetting `ON`.**
```sql
FROM invoices i, customers c
```
Old-style comma join with no condition: every invoice against every customer,
3,225 × 64 = 206,400 rows. Always write `JOIN ... ON`.

**Joining on the wrong key.** `invoices.cost_centre_code` to
`customers.cost_centre_code` will run happily and give nonsense, because that is
not a key — many customers share a cost centre. Runs fine, answer is rubbish.

**Aggregating after a fan-out.** Covered above. It is the mistake that reaches
the board pack.

---

## You should now be able to...

- Explain the difference between `INNER`, `LEFT`, `RIGHT`, `FULL` and `CROSS`,
  and choose between them for a business reason
- Alias tables and qualify every column
- Chain three or more tables in one query, adding one join at a time
- Put conditions in `ON` rather than `WHERE` when the right side may be missing
- Join a table to itself to find the other side of a journal entry
- Detect a fan-out with `count(*)` against `count(DISTINCT key)`, find the
  duplicate key, and quantify what it did to your total
- Use `count(column)` rather than `count(*)` when counting matches

Then: **[exercises/README.md](exercises/README.md)** — 23 questions. Check your
answers with `pytest sql/04-joins`.

When you have finished them, you have enough SQL for **Project 1: a monthly P&L
from the general ledger**. See `projects/01-monthly-pl-sql/`.
