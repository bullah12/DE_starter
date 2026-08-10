# SQL 02 — WHERE, operators, IN, BETWEEN, LIKE and NULL

## Why this matters

Almost every question you are asked is a filtered question. Not "sales" but
"UK sales over £50,000 that fell due in Q3 and have not been paid". The
filtering *is* the analysis; the arithmetic afterwards is usually trivial.

In Excel you filter by clicking, and the result is a view — temporary,
invisible to anyone reading the file later, and impossible to audit. In SQL the
filter is written down. Somebody can read your `WHERE` clause and tell you it is
wrong, which sounds worse and is enormously better.

This topic also contains the single most expensive misunderstanding in
commercial SQL: what happens to `NULL`. Rows go missing, totals come up short,
and nothing anywhere reports an error.

## The concept

### WHERE tests every row

```sql
SELECT invoice_id, gross_amount_gbp
FROM invoices
WHERE invoice_type = 'SALES'
  AND gross_amount_gbp > 100000;
```

The database looks at each row, evaluates the condition, and keeps the row if
the answer is TRUE. That is the whole model.

| Operator | Means | Example |
|---|---|---|
| `=` | equals | `currency = 'GBP'` |
| `<>` or `!=` | not equal | `status <> 'PAID'` |
| `<` `>` `<=` `>=` | comparisons | `due_date < DATE '2024-01-01'` |
| `AND` | both must hold | |
| `OR` | either may hold | |
| `NOT` | negates | `NOT (currency = 'GBP')` |

**Text values go in single quotes.** `'SALES'`. Double quotes mean a column
name and will produce a baffling error.

Text comparison is **case sensitive and whitespace sensitive**. `'PAID'`,
`'Paid'` and `'PAID '` are three different values, and this dataset contains all
three. That is not a quirk of the exercise; it is what a real status column
looks like.

### AND binds tighter than OR

```sql
WHERE type = 'SALES' OR type = 'PURCHASE' AND currency = 'USD'
```

means *"sales invoices in any currency, or purchase invoices in USD"* — almost
certainly not what was intended. `AND` is evaluated first, exactly as `*` beats
`+`. **Bracket anything with both**, even when you are sure. Especially when
you are sure.

### IN, BETWEEN, LIKE

```sql
WHERE account_code IN (4000, 4010, 4020)      -- shorthand for three ORs
WHERE account_code BETWEEN 6000 AND 6099      -- inclusive at BOTH ends
WHERE customer_name LIKE 'Vulcan%'            -- % = any characters
WHERE customer_name ILIKE '%motors%'          -- case-insensitive
```

`BETWEEN` includes both endpoints. For account codes that is what you want. For
dates it is a trap: `BETWEEN DATE '2024-01-01' AND DATE '2024-12-31'` silently
excludes anything timestamped on 31 December after midnight. Prefer
`>= start AND < the day after the end` for dates. It reads worse and never goes
wrong.

`%` matches any run of characters, `_` matches exactly one. `ILIKE` ignores
case, which this customer table needs badly.

### NULL: the important bit

`NULL` does not mean zero and does not mean empty text. It means **unknown**.

Every comparison against an unknown produces *unknown*, which is not TRUE, so
the row is not kept:

```sql
WHERE country = NULL      -- never matches anything, ever
WHERE country <> NULL     -- also never matches anything
```

The only tests that work are `IS NULL` and `IS NOT NULL`.

The consequence is bigger than the syntax. `WHERE country <> 'United Kingdom'`
looks like "everyone outside the UK". It is not: it silently drops the five
customers whose country is unknown. Nothing warns you, the query succeeds, and
your overseas debtor analysis is short by five accounts.

> Whenever you write a `<>` or a `NOT IN`, stop and ask: **can this column be
> NULL, and if so which side do those rows belong on?**

---

## Worked examples

### 1. A straightforward filter

```sql
SELECT invoice_id, invoice_type, due_date, gross_amount_gbp
FROM invoices
WHERE invoice_type = 'SALES' AND gross_amount_gbp > 100000
ORDER BY gross_amount_gbp DESC, invoice_id;
```

```
┌───────────────┬──────────────┬────────────┬──────────────────┐
│  invoice_id   │ invoice_type │  due_date  │ gross_amount_gbp │
├───────────────┼──────────────┼────────────┼──────────────────┤
│ SI-2022-00483 │ SALES        │ 2023-01-17 │        165396.24 │
│ SI-2023-00843 │ SALES        │ 2023-06-16 │        130338.23 │
└───────────────┴──────────────┴────────────┴──────────────────┘
```

Two invoices over £100k in three years. Worth knowing before you promise
anyone a "large invoice" report — sometimes the answer is that there is no
population.

### 2. Brackets

```sql
WHERE (invoice_type = 'SALES' OR invoice_type = 'PURCHASE')
  AND currency = 'USD'
  AND gross_amount_gbp > 40000
```

```
┌───────────────┬──────────────┬──────────┬──────────────────┐
│  invoice_id   │ invoice_type │ currency │ gross_amount_gbp │
├───────────────┼──────────────┼──────────┼──────────────────┤
│ SI-2024-01708 │ SALES        │ USD      │         80792.10 │
│ PI-2024-01245 │ PURCHASE     │ USD      │         58741.78 │
│ PI-2023-00489 │ PURCHASE     │ USD      │         49835.22 │
│ SI-2024-01391 │ SALES        │ USD      │         42215.70 │
└───────────────┴──────────────┴──────────┴──────────────────┘
```

Remove the brackets and you get every purchase invoice in every currency,
because `AND` binds first. The query still runs. It just answers a different
question. (`invoice_type IN ('SALES','PURCHASE')` says the same thing with no
brackets to get wrong — which is the real reason to prefer `IN`.)

### 3. IN and BETWEEN

```sql
WHERE account_code BETWEEN 6000 AND 6099
   OR account_code IN (4000, 4010, 5000)
```

```
┌──────────────┬─────────────────────────────┬────────────────────┐
│ account_code │        account_name         │   report_section   │
├──────────────┼─────────────────────────────┼────────────────────┤
│         4000 │ Sales - Components UK       │ Revenue            │
│         4010 │ Sales - Components Export   │ Revenue            │
│         5000 │ MATERIALS PURCHASES         │ Cost of Sales      │
│         6000 │   Salaries and Wages        │ Operating Expenses │
│         6010 │ Employer National Insurance │ Operating Expenses │
│         6020 │ Pension Contributions       │ Operating Expenses │
│         6030 │ Recruitment                 │ Operating Expenses │
│         6040 │ Training                    │ Operating Expenses │
└──────────────┴─────────────────────────────┴────────────────────┘
```

`BETWEEN 6000 AND 6099` includes both 6000 and 6099. Account code ranges are
the one place where inclusive-both-ends is exactly right, because the chart was
designed in blocks.

### 4. LIKE

```sql
WHERE customer_name ILIKE '%motors%'
```

```
┌─────────────┬─────────────────────────┬────────────────┐
│ customer_id │      customer_name      │    country     │
├─────────────┼─────────────────────────┼────────────────┤
│ C2004       │ Pinewood Motors SARL    │ NULL           │
│ C2007       │ Falkirk Motors BV       │ United Kingdom │
│ C2009       │   KESTREL MOTORS LTD    │ United Kingdom │
│ C2034       │ cranmere motors ltd     │ Ireland        │
│ C2050       │ redland motors plc      │ United States  │
└─────────────┴─────────────────────────┴────────────────┘
   (8 rows; five of them shown)
```

`ILIKE` matches `Motors`, `MOTORS` and `motors`. Plain `LIKE '%Motors%'` would
find only the first spelling — three of these rows would vanish. On a name
column that has not been cleaned, **always reach for `ILIKE`**.

### 5. Finding the NULLs

```sql
WHERE country IS NULL OR payment_terms_days IS NULL
```

```
┌─────────────┬────────────────────────────┬────────────────┬────────────────────┐
│ customer_id │       customer_name        │    country     │ payment_terms_days │
├─────────────┼────────────────────────────┼────────────────┼────────────────────┤
│ C2004       │ Pinewood Motors SARL       │ NULL           │                 45 │
│ C2009       │   KESTREL MOTORS LTD       │ United Kingdom │               NULL │
│ C2017       │   IRONBRIDGE MACHINERY LTD │ NULL           │                 45 │
│ C2043       │ Whitmore Utilities SARL    │ NULL           │               NULL │
│ C2060       │ Vulcan Motors Ltd          │ Germany        │               NULL │
└─────────────┴────────────────────────────┴────────────────┴────────────────────┘
   (8 rows; five shown)
```

A missing payment term is not cosmetic: the due date on those customers'
invoices was calculated from *something*, and you now need to find out what.
Run this query on any master file you are handed.

### 6. The trap

```sql
SELECT count(*) AS rows_returned FROM customers
WHERE country <> 'United Kingdom';
```

```
┌───────────────┐
│ rows_returned │
├───────────────┤
│            22 │
└───────────────┘
```

There are 64 customers, of whom 37 are in the United Kingdom. 64 − 37 = 27, not
22. **Five rows have gone missing** — the five with no country. Add
`OR country IS NULL` and you get 27.

Nothing about this query looks wrong. It has no error, it returns plausible
rows, and it under-reports your overseas exposure by five accounts. This is why
`NULL` gets a whole section rather than a footnote.

---

## Common mistakes

**Double quotes on a text value.**
```sql
WHERE currency = "GBP"
```
```
Binder Error: Referenced column "GBP" not found in FROM clause!
```

**Using `= NULL`.** No error, no rows, no clue. Use `IS NULL`.

**`NOT IN` with NULLs in the list.** If any value in the list is NULL, `NOT IN`
returns no rows at all. This is logically consistent — "is it not one of these,
one of which I don't know?" is genuinely unanswerable — and utterly infuriating
the first time. `NOT EXISTS` (topic 05) avoids it.

**Assuming case-insensitive text.** `WHERE status = 'PAID'` misses `Paid`,
`paid` and `PAID `. In this dataset that is three quarters of the population.

**`BETWEEN` on dates.** Excludes part of the last day the moment a time
component appears. Use `>= start AND < day-after-end`.

**Filtering on an alias.**
```sql
SELECT gross_amount - net_amount AS vat FROM invoices WHERE vat > 100;
```
```
Binder Error: Referenced column "vat" not found in FROM clause!
```
`WHERE` runs before `SELECT`. Repeat the expression, or wait for topic 05.

---

## You should now be able to...

- Filter rows with `WHERE` using comparison and logical operators
- Bracket mixed `AND`/`OR` conditions so they mean what you intended
- Use `IN`, `BETWEEN`, `LIKE` and `ILIKE`, and say when each is the clearest
- Explain why `= NULL` never matches, and use `IS NULL` / `IS NOT NULL`
- Spot the `<>` and `NOT IN` cases where NULLs will quietly eat rows
- Prove a filter is right by checking the counts add up to the whole

Then: **[exercises/README.md](exercises/README.md)** — 23 questions.
`pytest sql/02-where-and-filtering`
