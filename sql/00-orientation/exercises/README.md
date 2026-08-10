# Exercises — SQL 00 — Orientation

You have four tools so far: `SELECT`, `FROM`, `ORDER BY`, `LIMIT`, plus `AS`
for renaming a column and `count(*)` for counting rows. That is enough to find
your way around a database you have never seen before, which is exactly what
these questions are about.

Keep `data/README.md` open — it lists every table and column.

Write each answer in `exercises/qNN.sql`. One query per file.

Check your work with:

```bash
pytest sql/00-orientation
```

Anything you have not written yet is reported as *skipped*, not failed.

---

## Warm-up (8 questions)

*One idea at a time, and close to a worked example.*

### q01. The cost centre list

Show every column of every cost centre, in code order.

**Expected output:** Four columns, eight rows, ordered by cost_centre_code.

> **Hint.** This is the shortest query in the course. Two lines and a sort.

### q02. The first fifteen accounts

Show the code and name of the first fifteen accounts on the chart, in
code order.

**Expected output:** Two columns, fifteen rows.

> **Hint.** LIMIT controls how many rows come back. It runs after ORDER BY, so you get the first fifteen *sorted* rows, not fifteen random ones.

### q03. How many invoices?

Count the rows in the invoices table. Call the column invoice_rows.

**Expected output:** One column, one row.

> **Hint.** count(*) counts rows. AS renames the output column.

### q04. How many payments?

Count the rows in the payments table. Call the column payment_rows.

**Expected output:** One column, one row.

> **Hint.** Same shape as the last one. Repetition is the point.

### q05. The staff list

List the first twelve employees alphabetically by surname, then first
name, showing surname, first name and job title.

**Expected output:** Three columns, twelve rows.

> **Hint.** ORDER BY takes more than one column, separated by commas. The second only breaks ties in the first.

### q06. Our biggest credit limits

The ten customers with the largest credit limits: id, name and limit.

**Expected output:** Three columns, ten rows, largest limit first.

> **Hint.** DESC after a column in ORDER BY sorts it the other way. Add customer_id as a tie-break so the answer is stable.

### q07. Is invoice_id a key?

Check whether invoice_id uniquely identifies a row in invoices. Show
any value that appears more than once, and how often.

**Expected output:** Two columns — invoice_id and times_it_appears. If the column is a genuine key, you will get no rows at all.

> **Hint.** Copy the recipe from examples/04_keys.sql and change the table and column. No rows back is the good outcome.

### q08. Is payment_id a key?

Run the same check on payment_id in the payments table.

**Expected output:** Two columns — payment_id and times_it_appears — one row per duplicated id, id order.

> **Hint.** Same recipe. This one does return rows, and they matter: a duplicated payment is cash counted twice.

---

## Core (8 questions)

*Realistic tasks that combine this topic with earlier ones.*

### q09. The twenty largest debits

The twenty largest single debit postings in the ledger, showing the
ledger line id, account code, entry date and debit amount.

**Expected output:** Four columns, twenty rows, largest debit first.

> **Hint.** Tie-break on gl_id so two identical amounts always come back in the same order.

### q10. How many customers have a country?

Count the customer rows, and separately count how many of them have a
country recorded. Call the columns customer_rows and with_country.

**Expected output:** Two columns, one row.

> **Hint.** count(*) counts rows; count(column) counts rows where that column is not NULL. The difference between the two numbers is the number of missing values.

### q11. How many ledger lines have a cost centre?

Same idea on the general ledger: total lines, and lines that have a
cost centre. Call the columns ledger_lines and with_cost_centre.

**Expected output:** Two columns, one row.

> **Hint.** If you can do q10 you can do this one. The gap is worth remembering — those lines will vanish from any report grouped by cost centre.

### q12. Is a ledger line identified by journal and line number?

Check whether the combination of journal_id and line_number uniquely
identifies a general ledger row.

**Expected output:** Three columns — journal_id, line_number, times_it_appears. No rows means the combination is unique.

> **Hint.** A key can be made of more than one column. Group by both.

### q13. The oldest journals

The fifteen earliest journals by journal date, showing id, date,
source and description.

**Expected output:** Four columns, fifteen rows, earliest first.

> **Hint.** Tie-break on journal_id — several journals share a date.

### q14. The ten highest salaries

The ten highest paid employees: surname, first name, job title and
salary.

**Expected output:** Four columns, ten rows, highest salary first.

> **Hint.** Tie-break on employee_id even though you are not showing it — you can sort by a column you do not select.

### q15. The largest budget lines

The ten largest individual budget lines, showing fiscal year, period,
account code, cost centre and amount.

**Expected output:** Five columns, ten rows, largest amount first.

> **Hint.** Tie-break on budget_id.

### q16. The first FX rates on file

The first ten exchange rate rows by date, then currency, showing all
four columns.

**Expected output:** Four columns, ten rows.

> **Hint.** Two sort columns. Note which dates are missing entirely — weekends have no published rate.

---

## Stretch (4 questions)

*Vague on purpose. Expect to think, and to look things up.*

### q17. How many accounts of each type?

Count the accounts on the chart by account_type.

**Expected output:** Two columns — account_type and account_count — one row per type, most accounts first.

> **Hint.** Take the key-check recipe and remove the part that filters out the groups of one.

### q18. Find the exactly duplicated supplier

Somewhere in suppliers there is a row that has been loaded twice, in
full. Prove it: return the duplicated row's values and the number of
times it appears.

**Expected output:** Eight columns — every supplier column, plus times_it_appears — one row.

> **Hint.** Group by every column, not just the id. Two rows are exact duplicates only if all their values match.

### q19. The biggest journals

Which journals have more than twenty ledger lines, and how many lines
do they have?

**Expected output:** Two columns — journal_id and line_count — most lines first.

> **Hint.** Same recipe again, with a different threshold. Have a guess at what kind of journal these will turn out to be before you run it.

### q20. What sources post to this ledger?

Work out what distinct values appear in journal_entries.source, and
how many journals each accounts for.

**Expected output:** Two columns — source and journal_count — one row per source, most journals first.

> **Hint.** Grouping by a column is also how you discover what is in it. This is the query to run on any unfamiliar coded column.
