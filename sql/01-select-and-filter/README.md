# SQL 01 — SELECT, aliases, expressions, ORDER BY, LIMIT

## Why this matters

Someone asks for "the top ten debtors, with their limit in euros, sorted
biggest first". In Excel that is: copy the columns you need into a new sheet,
add a calculated column, sort, delete rows 11 onwards. Four operations, none of
them recorded anywhere, and if the source refreshes you do it all again.

In SQL it is one statement, and the statement *is* the record of what you did.
Run it next month and it does the same thing to the new data.

This topic is about shaping the output: choosing columns, computing new ones,
naming them so a human can read them, and controlling order and volume. It is
the smallest useful unit of SQL, and you will write more of it than anything
else.

## The concept

### SELECT chooses and computes

A `SELECT` list can contain three kinds of thing:

```sql
SELECT
    invoice_id,                     -- a column, as stored
    net_amount + tax_amount,        -- an expression, computed per row
    round(tax_amount, 2) AS vat     -- an expression with a name
FROM invoices;
```

An **expression** is a formula evaluated once per row. Arithmetic (`+ - * /`),
functions (`round`, `abs`), text joining (`||`) — all of it works exactly as
your instinct says. There is no drag-down, no `$B$1`, and no risk that row 4,271
got missed.

### Aliases name things

`AS` renames a column in the output:

```sql
SELECT account_code AS code FROM chart_of_accounts;
```

Without it, a computed column comes back named something like
`(net_amount + tax_amount)`. Alias every expression. It costs one word and it
is the difference between output and a report.

Alias names with spaces need double quotes: `AS "Net of VAT"`. Prefer
`AS net_of_vat` — lower case with underscores, which is the convention
everywhere and never needs quoting.

> **Single quotes are for text values. Double quotes are for names.** Getting
> these the wrong way round is the most common beginner error in SQL, and the
> error message it produces looks like nonsense until you know this rule.

### DISTINCT removes repeats

```sql
SELECT DISTINCT status FROM invoices;
```

One row per unique value. Use it constantly when you first meet a column: it
tells you what is actually in there, which is often not what the documentation
says.

### ORDER BY sorts, LIMIT and OFFSET page

```sql
ORDER BY gross_amount DESC, invoice_id   -- second column breaks ties
LIMIT 10 OFFSET 20                       -- rows 21 to 30
```

`ASC` (the default) is smallest first, `DESC` is largest first. Multiple sort
columns are applied left to right, in priority order.

**Always add a tie-break.** If ten invoices share a value and you take the top
five, which five you get is undefined and can change between runs. A unique
column as the last sort key makes the answer stable — and a report that
reorders itself is a report nobody trusts.

`ORDER BY` runs *before* `LIMIT`, so `LIMIT 10` gives the first ten of the
sorted set, not ten arbitrary rows that then got sorted.

---

## Worked examples

```bash
python tools/run_sql.py sql/01-select-and-filter/examples/01_aliases.sql
```

### 1. Aliases

```sql
SELECT account_code AS code, account_name AS account, account_type AS type
FROM chart_of_accounts ORDER BY account_code LIMIT 5;
```

```
┌───────┬──────────────────────────┬─────────┐
│ code  │         account          │  type   │
├───────┼──────────────────────────┼─────────┤
│  1010 │ Freehold Property        │ ASSET   │
│  1020 │ Plant and Machinery      │ ASSET   │
│  1030 │ Motor Vehicles           │ ASSET   │
│  1040 │   Office Equipment       │ ASSET   │
│  1090 │ Accumulated Depreciation │ ASSET   │
└───────┴──────────────────────────┴─────────┘
```

The data is untouched; only the headings changed.

### 2. An expression: the signed movement

```sql
SELECT gl_id, account_code, debit, credit, debit - credit AS movement
FROM general_ledger ORDER BY gl_id LIMIT 6;
```

```
┌───────┬──────────────┬─────────┬─────────┬──────────┐
│ gl_id │ account_code │  debit  │ credit  │ movement │
├───────┼──────────────┼─────────┼─────────┼──────────┤
│     1 │         1200 │ 7634.83 │    0.00 │  7634.83 │
│     2 │         4020 │    0.00 │ 6362.36 │ -6362.36 │
│     3 │         2100 │    0.00 │ 1272.47 │ -1272.47 │
│     4 │         1200 │ 2194.98 │    0.00 │  2194.98 │
│     5 │         4020 │    0.00 │ 2194.98 │ -2194.98 │
│     6 │         1200 │ 9674.92 │    0.00 │  9674.92 │
└───────┴──────────────┴─────────┴─────────┴──────────┘
```

`movement` does not exist in the table. It exists in the answer, computed once
per row.

Look at rows 1 to 3: that is one sales invoice — debit trade debtors, credit
services revenue, credit VAT. The `movement` column is signed the way an asset
or expense wants it. For income and liabilities you want `credit - debit`
instead, or every revenue figure comes back negative. **Which way round you
subtract is a business decision you make per account type**, and forgetting it
is the most common error in this entire course.

### 3. Arithmetic and rounding — a control you can actually use

```sql
SELECT invoice_id, net_amount, tax_amount,
       net_amount + tax_amount AS recalculated_gross,
       gross_amount,
       round(tax_amount / net_amount * 100, 1) AS effective_vat_pct
FROM invoices ORDER BY invoice_id LIMIT 6;
```

```
┌───────────────┬────────────┬────────────┬────────────────────┬──────────────┬───────────────────┐
│  invoice_id   │ net_amount │ tax_amount │ recalculated_gross │ gross_amount │ effective_vat_pct │
├───────────────┼────────────┼────────────┼────────────────────┼──────────────┼───────────────────┤
│ PI-2022-00001 │    1480.33 │     296.07 │            1776.40 │      1776.40 │              20.0 │
│ PI-2022-00002 │     706.80 │       0.00 │             706.80 │       706.80 │               0.0 │
│ PI-2022-00003 │    3168.62 │       0.00 │            3168.62 │      3168.62 │               0.0 │
│ PI-2022-00004 │    2573.20 │       0.00 │            2573.20 │      2573.20 │               0.0 │
│ PI-2022-00005 │    1682.25 │     336.45 │            2018.70 │      2018.70 │              20.0 │
│ PI-2022-00006 │     752.75 │       0.00 │             752.75 │       752.75 │               0.0 │
└───────────────┴────────────┴────────────┴────────────────────┴──────────────┴───────────────────┘
```

`round(x, 1)` rounds to one decimal place. Putting the recalculated figure next
to the stored one is a control: they should agree on every row, and if they ever
do not, you have found something.

The 0.0% rows are overseas suppliers, correctly outside the scope of UK VAT.

### 4. DISTINCT — what is really in this column?

```sql
SELECT DISTINCT status FROM invoices ORDER BY status;
```

```
┌──────────┐
│  status  │
├──────────┤
│ CREDITED │
│ OPEN     │
│ OPEN     │
│ Open     │
│ PAID     │
│ PAID     │
│ Paid     │
│ open     │
│ paid     │
└──────────┘
```

Nine values for what should be two or three. `OPEN` appears twice because one
of them has a trailing space — invisible on screen, entirely different to the
database. `Open`, `open` and `OPEN` are three more. Note too where the lower
case ones sort: after all the upper case ones, because sorting is by character
code, not by how the words look.

This is thirty seconds of work that changes how you treat the column for the
rest of the project. Run `SELECT DISTINCT` on every coded column you are given.

### 5. Sorting by a computed column, and paging

```sql
SELECT invoice_id, net_amount, gross_amount,
       gross_amount - net_amount AS tax_element
FROM invoices ORDER BY tax_element DESC, invoice_id LIMIT 5 OFFSET 5;
```

```
┌───────────────┬────────────┬──────────────┬─────────────┐
│  invoice_id   │ net_amount │ gross_amount │ tax_element │
├───────────────┼────────────┼──────────────┼─────────────┤
│ PI-2024-01313 │   72895.62 │     87474.74 │    14579.12 │
│ PI-2024-01022 │   72002.73 │     86403.28 │    14400.55 │
│ PI-2023-00682 │   68977.69 │     82773.23 │    13795.54 │
│ PI-2023-00624 │   59589.53 │     71507.44 │    11917.91 │
│ SI-2022-00366 │   57072.91 │     68487.49 │    11414.58 │
└───────────────┴────────────┴──────────────┴─────────────┘
```

You can sort by an alias defined in the same `SELECT`. `OFFSET 5` skips the
first five, so these are rows 6 to 10 — the second page.

### 6. Building a label

```sql
SELECT employee_id,
       last_name || ', ' || first_name AS employee,
       job_title,
       annual_salary_gbp / 12 AS monthly_gbp
FROM employees ORDER BY annual_salary_gbp DESC, employee_id LIMIT 5;
```

```
┌─────────────┬─────────────────────┬────────────────────┬───────────────────┐
│ employee_id │      employee       │     job_title      │    monthly_gbp    │
├─────────────┼─────────────────────┼────────────────────┼───────────────────┤
│        1001 │ Lindqvist, Isobel   │ Managing Director  │ 7418.583333333333 │
│        1037 │ Hollingworth, Petra │ Warehouse Manager  │ 7383.583333333333 │
│        1005 │ Thackeray, Bhavin   │ Area Sales Manager │ 7353.916666666667 │
└─────────────┴─────────────────────┴────────────────────┴───────────────────┘
```

`||` joins text. Note `monthly_gbp` has thirteen decimal places, because
dividing produced a floating point number. Wrap it in `round(..., 2)` for
anything a human will read.

---

## Common mistakes

**Double quotes around a text value.**
```sql
SELECT * FROM customers ORDER BY "United Kingdom";
```
```
Binder Error: Referenced column "United Kingdom" not found in FROM clause!
```
Double quotes say "this is a name". Use single quotes for text.

**Using an alias in the wrong place.**
```sql
SELECT gross_amount - net_amount AS tax_element FROM invoices WHERE tax_element > 100;
```
```
Binder Error: Referenced column "tax_element" not found in FROM clause!
```
`ORDER BY` can see your aliases; `WHERE` cannot, because it runs earlier.
Execution order is topic 12 — for now, repeat the expression in `WHERE`.

**Integer division.** In some databases `5 / 2` is `2`. DuckDB gives `2.5`, but
the habit of writing `5.0 / 2` is worth having, because the day you meet a
database that truncates, it will be inside a report nobody rechecks.

**Dividing by zero.** DuckDB returns NULL rather than erroring. Quiet NULLs in
a percentage column usually mean a zero denominator.

**Forgetting the tie-break.** `LIMIT 10` on a column with ties gives you *ten of
them*, not a defined ten.

---

## You should now be able to...

- Select specific columns and alias them with `AS`
- Compute new columns with arithmetic, `round`, `abs` and `||`
- Use `DISTINCT` to see what values a column actually contains
- Sort ascending and descending, on several columns and on expressions
- Page results with `LIMIT` and `OFFSET`, and know why a tie-break matters
- Explain why `credit - debit` and `debit - credit` are both correct, for
  different accounts

Then: **[exercises/README.md](exercises/README.md)** — 22 questions.
`pytest sql/01-select-and-filter`
