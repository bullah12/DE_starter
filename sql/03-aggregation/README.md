# SQL 03 — Aggregation: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING

## Why this matters

A trial balance is a `GROUP BY`. So is a sales analysis by region, an ageing
summary, a headcount by department, and roughly every management report you
have ever produced.

**`GROUP BY` is the pivot table.** The columns you group by are the row labels;
the aggregate functions are the values. That single sentence carries you most of
the way through this topic, because you already know how to think in pivot
tables — you have been building them for a decade.

What is genuinely new is the discipline. A pivot table lets you drag fields
around until it looks right. SQL makes you say precisely what you mean before it
will run at all, and then tells you off if the statement is incoherent. That
feels hostile for a week and then becomes the thing you trust.

## The concept

### Aggregate functions collapse many rows into one

| Function | Does | Ignores NULLs? |
|---|---|---|
| `count(*)` | counts rows | n/a — counts every row |
| `count(col)` | counts non-NULL values in `col` | yes |
| `count(DISTINCT col)` | counts different non-NULL values | yes |
| `sum(col)` | adds up | yes |
| `avg(col)` | mean | **yes — and this matters** |
| `min(col)` / `max(col)` | smallest / largest; works on dates and text too | yes |

With no `GROUP BY`, the whole table is one group and you get one row back.

### GROUP BY splits the table first

```sql
SELECT account_code, sum(debit) AS total_debit
FROM general_ledger
GROUP BY account_code;
```

"Sort the rows into piles by `account_code`, then add up `debit` within each
pile." One row out per pile.

**The rule that catches everyone:** every column in your `SELECT` must either be
in the `GROUP BY` or be inside an aggregate function. If it is neither, the
database cannot know which of the many values in the group you meant, and it
says so:

```
Binder Error: column "entry_date" must appear in the GROUP BY clause
or must be part of an aggregate function.
```

This is not pedantry. It is the database refusing to guess.

### WHERE filters rows, HAVING filters groups

```sql
SELECT account_code, sum(debit) AS total_debit
FROM general_ledger
WHERE entry_date >= DATE '2024-01-01'   -- which rows go into the piles
GROUP BY account_code
HAVING sum(debit) > 500000              -- which piles survive
ORDER BY total_debit DESC;
```

`WHERE` runs before the grouping and cannot see aggregates. `HAVING` runs after
and is the only place an aggregate can be tested. "Accounts with more than
£500,000 of debits" is a statement about a pile, so it is `HAVING`.

Put a row condition in `HAVING` and it usually still works but reads badly. Put
an aggregate in `WHERE` and you get:

```
Binder Error: aggregate functions are not allowed in WHERE
```

### NULLs and averages

`avg()` divides by the number of *values*, not the number of rows. In this
dataset the average payment terms across 64 customers is 43.35 days — but only
60 customers have terms recorded. Divide the same total by 64 and you get 40.64.

Neither number is wrong. They answer different questions ("average of the terms
we know" versus "average if unknown means zero"), and the difference is 6%. Know
which one you have handed over.

---

## Worked examples

### 1. The whole table as one group

```sql
SELECT count(*) AS ledger_lines, sum(debit) AS total_debits,
       sum(credit) AS total_credits, min(entry_date) AS first_entry,
       max(entry_date) AS last_entry
FROM general_ledger;
```

```
┌──────────────┬──────────────┬───────────────┬─────────────┬────────────┐
│ ledger_lines │ total_debits │ total_credits │ first_entry │ last_entry │
├──────────────┼──────────────┼───────────────┼─────────────┼────────────┤
│        16872 │  76529377.70 │   75998026.00 │ 2022-01-03  │ 2024-12-31 │
└──────────────┴──────────────┴───────────────┴─────────────┴────────────┘
```

Five facts about a database you have never seen, in one query. Debits exceed
credits by £531,351.70, which for a double-entry ledger is impossible — so
before anything else, you know this ledger is broken and by how much. (Topic 04
finds the six journals responsible.)

`min` and `max` work on dates, which is how you establish what period you have
actually been given rather than what you were told.

### 2. A trial balance

```sql
SELECT account_code, sum(debit) AS total_debit, sum(credit) AS total_credit,
       sum(debit) - sum(credit) AS balance
FROM general_ledger
WHERE entry_date >= DATE '2024-01-01'
GROUP BY account_code
ORDER BY account_code LIMIT 10;
```

```
┌──────────────┬─────────────┬──────────────┬─────────────┐
│ account_code │ total_debit │ total_credit │   balance   │
├──────────────┼─────────────┼──────────────┼─────────────┤
│         1090 │        0.00 │    254520.00 │  -254520.00 │
│         1200 │  8535747.09 │   8084286.72 │   451460.37 │
│         1400 │  8112050.36 │   6142963.93 │  1969086.43 │
│         2000 │  3271944.80 │   3088229.14 │   183715.66 │
│         2100 │  1096995.19 │    956127.61 │   140867.58 │
│         4000 │        0.00 │   3378953.62 │ -3378953.62 │
└──────────────┴─────────────┴──────────────┴─────────────┘
    (38 rows; six shown)
```

That is a trial balance, in four lines of SQL, and it will be a trial balance
again next month with no work at all.

Negative balances are credits, because `balance` is defined as debit less
credit. Revenue is therefore negative here. That is arithmetically right and
presentationally awful — flipping the sign per account type needs `CASE`, which
is topic 07.

### 3. Two grouping columns and DISTINCT

```sql
SELECT invoice_type, currency, count(*) AS invoices,
       count(DISTINCT customer_id) AS customers,
       round(sum(gross_amount_gbp), 2) AS gross_gbp
FROM invoices
GROUP BY invoice_type, currency
ORDER BY invoice_type, currency;
```

```
┌──────────────┬──────────┬──────────┬───────────┬────────────┐
│ invoice_type │ currency │ invoices │ customers │ gross_gbp  │
├──────────────┼──────────┼──────────┼───────────┼────────────┤
│ PURCHASE     │ EUR      │      521 │         0 │  2555339.60│
│ PURCHASE     │ GBP      │      690 │         0 │  5440611.53│
│ PURCHASE     │ USD      │      126 │         0 │   597089.70│
│ SALES        │ EUR      │      567 │        18 │  5748263.59│
│ SALES        │ GBP      │     1141 │        38 │ 15669444.41│
│ SALES        │ USD      │      180 │         6 │  1728916.64│
└──────────────┴──────────┴──────────┴───────────┴────────────┘
```

One row per combination that **exists**. Combinations with no rows do not appear
at all — unlike a pivot table, which shows an empty cell. If your report needs a
zero row for a quiet month, you have to build the skeleton yourself (the
`CROSS JOIN` from topic 04).

`customers` is 0 on the purchase rows because purchase invoices have no
`customer_id` — `count(DISTINCT ...)` ignored 1,337 NULLs and correctly found
nothing. The zero is information, not a bug.

### 4. HAVING

```sql
WHERE entry_date >= DATE '2024-01-01'
GROUP BY account_code
HAVING sum(debit) > 500000
```

```
┌──────────────┬───────┬─────────────┐
│ account_code │ lines │ total_debit │
├──────────────┼───────┼─────────────┤
│         1200 │  1302 │  8535747.09 │
│         1400 │  1122 │  8112050.36 │
│         2000 │   930 │  3271944.80 │
│         6000 │    96 │  3119049.96 │
│         5000 │   162 │  2373777.50 │
│         2100 │   662 │  1096995.19 │
└──────────────┴───────┴─────────────┘
```

Six accounts carry the business: debtors, bank, creditors, payroll, materials
and VAT. Note the line counts — payroll moves £3.1m in 96 lines, materials £2.4m
in 162. Average size per line is a useful smell test and it is one more
aggregate away.

### 5. Counting, carefully

```sql
SELECT count(*) AS customers, count(country) AS with_country,
       count(DISTINCT country) AS distinct_countries,
       count(payment_terms_days) AS with_terms,
       round(avg(payment_terms_days), 2) AS avg_terms_days,
       round(sum(payment_terms_days) * 1.0 / count(*), 2) AS avg_if_nulls_were_zero
FROM customers;
```

```
┌───────────┬──────────────┬────────────────────┬────────────┬────────────────┬────────────────────────┐
│ customers │ with_country │ distinct_countries │ with_terms │ avg_terms_days │ avg_if_nulls_were_zero │
├───────────┼──────────────┼────────────────────┼────────────┼────────────────┼────────────────────────┤
│        64 │           59 │                  7 │         60 │          43.35 │                  40.64 │
└───────────┴──────────────┴────────────────────┴────────────┴────────────────┴────────────────────────┘
```

64 rows, 59 with a country, 7 distinct countries, 60 with terms. Two averages
6% apart. Every one of those numbers is a decision you are making on someone's
behalf, and the query is where you record it.

---

## Common mistakes

**A column that is neither grouped nor aggregated.**
```
Binder Error: column "entry_date" must appear in the GROUP BY clause or must be
part of an aggregate function.
```
Either add it to `GROUP BY` (more rows) or wrap it in `min`/`max` (same rows).

**An aggregate in WHERE.**
```
Binder Error: aggregate functions are not allowed in WHERE
```
You wanted `HAVING`.

**`count(*)` when you meant `count(column)`.** After a `LEFT JOIN` (topic 04)
these differ, and `count(*)` reports 1 where the true answer is 0.

**`sum()` over a fanned-out join.** No error, wrong answer, plausible number.
The most expensive mistake in this course, and topic 04 is largely about it.

**Averaging an average.** `avg()` of monthly averages is not the annual average
unless every month has the same number of rows. Aggregate the raw rows instead.

---

## You should now be able to...

- Use `count`, `sum`, `avg`, `min`, `max` over a whole table and within groups
- Explain `GROUP BY` as a pivot table, and say what the row labels are
- Obey the rule that every selected column is grouped or aggregated
- Choose between `WHERE` and `HAVING` for a given condition, and say why
- Distinguish `count(*)`, `count(col)` and `count(DISTINCT col)`
- Explain what `avg()` does with NULLs and why the answer might be 6% out
- Produce a trial balance from a general ledger, unaided

Then: **[exercises/README.md](exercises/README.md)** — 23 questions.
`pytest sql/03-aggregation`
