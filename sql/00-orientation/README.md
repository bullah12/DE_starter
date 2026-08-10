# SQL 00 — Orientation

## Why this matters

You have spent a decade in workbooks. Someone sends you a ledger extract, you
open it, you look at it, you fix the column widths, you start working.

A database is the same data with the looking-at part removed.

That sounds like a downgrade until the extract is 16,872 rows across eleven
tables that have to agree with each other. Then the spreadsheet model —
everything visible, everything editable, everything one stray keystroke from
being wrong — stops being a strength. A database gives you the opposite trade:
you cannot see the data, but you can ask it precise questions, get the same
answer every time, and never have to check whether a formula was dragged all
the way down.

This topic is about getting your bearings. By the end of it you will have run
queries against a real ledger and checked whether a column is safe to join on.

## The concept

### A table is a worksheet with rules

| Spreadsheet | Database |
|---|---|
| Worksheet | **Table** |
| Row | **Row** (or *record*) |
| Column | **Column** (or *field*) |
| Column header | Column **name** — fixed, and part of the table's definition |
| Any cell can hold anything | Every column has one **type**, enforced |
| Cell reference `B7` | No such thing. You address data by *value*, never by position |
| A formula in the sheet | A **query** you write and run separately |

That last row is the real shift. There is no `B7` in SQL. You cannot say "the
cell three to the right"; you say "the `debit` column of the rows where
`account_code = 1200`". At first this feels like losing a limb. Then you notice
that inserting a row has never once broken anything.

**Types** are worth dwelling on. In Excel a column of dates can quietly contain
three text values and a number, and you find out at the worst moment. In a
database, `entry_date` is a `DATE`, and nothing that is not a date can get in.
That constraint is why database answers are reproducible.

(The dataset here has columns typed as text precisely *because* the source data
was too dirty to promise they were dates. `invoices.invoice_date` is text. That
is honest labelling, not a broken database — see `data/README.md`.)

### Keys

A **key** is a column whose value identifies a row uniquely. `account_code` in
`chart_of_accounts`. `invoice_id` in `invoices`. `employee_id` in `employees`.

- A **primary key** is the column a table promises is unique. One row per value,
  no exceptions.
- A **foreign key** is a column that points at another table's primary key.
  `general_ledger.account_code` is a foreign key pointing at
  `chart_of_accounts.account_code`.

Foreign keys are how eleven tables become one coherent ledger. They are the
reason you can ask "what did we spend on materials in the North West in FY2024"
without any single table containing all three of those facts.

Uniqueness is not decoration. It is the difference between a lookup that works
and a total that is silently double counted. So you check it, every time, on
every table you are handed.

### Anatomy of a query

```sql
SELECT account_code, account_name    -- which columns you want
FROM chart_of_accounts               -- which table they come from
ORDER BY account_code                -- how to sort the result
LIMIT 10;                            -- how many rows to show
```

`SELECT` and `FROM` are the only compulsory parts. Keywords are conventionally
upper case and column names lower case; the database does not care, but every
SQL you will ever read is written that way, so write it that way too.

A query never changes the data. Everything in topics 00 to 10 is read-only, and
the connection in `tools/run_sql.py` is opened read-only so you literally
cannot break the database by mistake.

---

## Worked examples

Run each one:

```bash
python tools/run_sql.py sql/00-orientation/examples/01_first_query.sql
```

### 1. Your first query

```sql
SELECT account_code, account_name, account_type
FROM chart_of_accounts
ORDER BY account_code
LIMIT 10;
```

```
┌──────────────┬──────────────────────────┬──────────────┐
│ account_code │       account_name       │ account_type │
├──────────────┼──────────────────────────┼──────────────┤
│         1010 │ Freehold Property        │ ASSET        │
│         1020 │ Plant and Machinery      │ ASSET        │
│         1030 │ Motor Vehicles           │ ASSET        │
│         1040 │   Office Equipment       │ ASSET        │
│         1090 │ Accumulated Depreciation │ ASSET        │
│         1200 │ TRADE DEBTORS            │ ASSET        │
│         1210 │ Other Debtors            │ ASSET        │
│         1220 │ Prepayments              │ ASSET        │
│         1300 │ Stock - Raw Materials    │ ASSET        │
│         1310 │ Stock - Finished Goods   │ ASSET        │
└──────────────┴──────────────────────────┴──────────────┘
```

- `SELECT account_code, account_name, account_type` — three columns, in that
  order. The order you list them is the order you get them.
- `FROM chart_of_accounts` — the table. One row per nominal account.
- `ORDER BY account_code` — sort ascending. **Without `ORDER BY`, row order is
  not guaranteed.** It may look sorted; that is luck, not a promise.
- `LIMIT 10` — first ten rows only. Use it constantly while exploring.

Look at rows 4 and 6: `  Office Equipment` is indented and `TRADE DEBTORS`
shouts. That is the deliberate mess in the source data. The database stores
exactly what it was given.

### 2. Every column

```sql
SELECT * FROM cost_centres;
```

```
┌──────────────────┬─────────────────────────┬────────────┬──────────────────┐
│ cost_centre_code │    cost_centre_name     │   region   │ cost_centre_type │
├──────────────────┼─────────────────────────┼────────────┼──────────────────┤
│ CC100            │ Head Office             │ South East │ SUPPORT          │
│ CC200            │ Sales - North           │ North West │ REVENUE          │
│ CC210            │ Sales - South           │ South East │ REVENUE          │
│ CC220            │ Sales - Export          │ South East │ REVENUE          │
│ CC300            │ Warehouse and Logistics │ Midlands   │ OPERATIONS       │
│ CC400            │ Manufacturing           │ Midlands   │ OPERATIONS       │
│ CC500            │ Finance                 │ South East │ SUPPORT          │
│ CC600            │ IT                      │ South East │ SUPPORT          │
└──────────────────┴─────────────────────────┴────────────┴──────────────────┘
```

`*` means every column. Perfect for a first look at an unfamiliar table; wrong
for anything you will run twice, because if someone adds a column upstream your
output silently changes shape.

Note there is no `LIMIT` here. Eight rows is the whole table. Know a table's
size before you `SELECT *` from it.

### 3. How big is it?

```sql
SELECT count(*) AS ledger_lines FROM general_ledger;
```

```
┌──────────────┐
│ ledger_lines │
├──────────────┤
│        16872 │
└──────────────┘
```

`count(*)` counts rows. `AS ledger_lines` renames the output column — an
**alias**, so the result reads like a report instead of like `count_star()`.

This is the second question you ask about any table, and the number you write
down so you can prove later that you did not lose rows.

### 4. Is this column a key?

```sql
SELECT account_code, count(*) AS times_it_appears
FROM chart_of_accounts
GROUP BY account_code
HAVING count(*) > 1;
```

```
┌──────────────┬──────────────────┐
│ account_code │ times_it_appears │
├──────────────┴──────────────────┤
│             0 rows              │
└─────────────────────────────────┘
```

**Zero rows is the good result.** It means no `account_code` appears twice, so
the column is unique, so it is safe to join to.

(`GROUP BY` and `HAVING` are topic 03. Treat this as a recipe for now — swap in
any table and column and it tells you whether that column is a key. It is the
single most useful five lines of SQL in this course.)

### 5. The same test, different answer

```sql
SELECT supplier_id, count(*) AS times_it_appears
FROM suppliers
GROUP BY supplier_id
HAVING count(*) > 1;
```

```
┌─────────────┬──────────────────┐
│ supplier_id │ times_it_appears │
├─────────────┼──────────────────┤
│ S3003       │                2 │
└─────────────┴──────────────────┘
```

`suppliers` has a duplicate row. `supplier_id` is *supposed* to be the primary
key and is not. Every future query that joins to `suppliers` will count S3003's
purchases twice.

Nothing warns you. The query runs, the total looks plausible, and it is wrong.
This is the whole reason topic 04 spends so long on joins.

---

## Common mistakes

**Misspelling a column.**
```sql
SELECT account_nane FROM chart_of_accounts;
```
```
Binder Error: Referenced column "account_nane" not found in FROM clause!
Candidate bindings: "account_name"
```
DuckDB guesses what you meant. Read the last line of any error first.

**Forgetting the semicolon.** Usually fine in these tools, mandatory in most
others. Just always write it.

**Single versus double quotes.**
```sql
SELECT * FROM customers WHERE country = "United Kingdom";
```
```
Binder Error: Referenced column "United Kingdom" not found in FROM clause!
```
**Single quotes are for text values. Double quotes mean "this is a column
name".** The error looks bizarre until you know that; then it is obvious.

**Assuming an order you did not ask for.** No `ORDER BY`, no guarantee. If a
report has to come out in a stable order, say so in the query.

**`SELECT *` on `general_ledger`.** 16,872 rows scrolling past. Add `LIMIT 20`.

---

## You should now be able to...

- Explain how a table differs from a worksheet, and why fixed column types make
  answers reproducible
- Name the parts of a query: `SELECT`, `FROM`, `ORDER BY`, `LIMIT`
- Read a table's contents, count its rows, and alias a column with `AS`
- Say what a primary key and a foreign key are, and why they matter
- Test whether a column is unique — and know that finding a duplicate is a
  finding, not a nuisance
- Read a DuckDB error message and act on the last line

Then: **[exercises/README.md](exercises/README.md)** — 20 questions. Check them
with `pytest sql/00-orientation`.
