# Exercises — SQL 01 — SELECT, aliases, expressions, ORDER BY, LIMIT

No `WHERE` yet — that is the next topic. Everything here is done by choosing
columns, computing them, sorting and limiting. It is more than it sounds: "top
ten by value" and "what values are in this column" are two of the most common
requests you will ever get.

Alias every computed column, and give every `ORDER BY` a unique tie-break.

Write each answer in `exercises/qNN.sql`. One query per file.

Check your work with:

```bash
pytest sql/01-select-and-filter
```

Anything you have not written yet is reported as *skipped*, not failed.

---

## Warm-up (8 questions)

*One idea at a time, and close to a worked example.*

### q01. A readable chart of accounts

The first twelve accounts by code, with the columns named code,
account and type.

**Expected output:** Three columns named code, account, type. Twelve rows.

> **Hint.** AS renames a column. The underlying data does not change.

### q02. Signed ledger movements

The first ten ledger lines by gl_id, showing the line id, account
code, debit, credit and the signed movement (debit less credit).

**Expected output:** Five columns, the last called movement. Ten rows.

> **Hint.** The movement column is an expression: debit - credit.

### q03. Does net plus tax equal gross?

The first eight invoices by invoice_id, showing net, tax, gross, and
your own recalculation of net plus tax.

**Expected output:** Five columns — invoice_id, net_amount, tax_amount, gross_amount, recalculated — eight rows.

> **Hint.** This is a control. If the two gross figures ever disagree you have found a data problem worth reporting.

### q04. What currencies do we invoice in?

List the distinct currencies appearing on invoices.

**Expected output:** One column, one row per currency, alphabetical.

> **Hint.** DISTINCT removes repeats.

### q05. What payment methods are in use?

List the distinct payment methods in the payments table.

**Expected output:** One column, one row per method, alphabetical.

> **Hint.** More values than you expect — the casing is inconsistent. That is the finding, not a mistake in your query.

### q06. Best paid staff, formatted

The ten highest paid employees, showing a single name column in the
form 'Surname, Firstname', their job title and their salary.

**Expected output:** Three columns — employee, job_title, annual_salary_gbp — ten rows, highest first.

> **Hint.** || joins text together. Tie-break on employee_id.

### q07. Budget lines in thousands

The ten largest budget lines, showing fiscal year, period, account
code and the amount expressed in thousands to one decimal place.

**Expected output:** Five columns — fiscal_year, fiscal_period, account_code, budget_amount_gbp, amount_k — ten rows, largest first.

> **Hint.** Divide by 1000 and wrap the whole thing in round(..., 1).

### q08. Exchange rates per thousand units

The first ten exchange rate rows by date then currency, showing the
date, currency, the rate, and what 1,000 units of that currency is
worth in GBP.

**Expected output:** Four columns — rate_date, from_currency, rate, gbp_per_1000 — ten rows.

> **Hint.** Multiply the rate by 1000 and round to two decimal places.

---

## Core (9 questions)

*Realistic tasks that combine this topic with earlier ones.*

### q09. The biggest VAT elements

The fifteen invoices carrying the most VAT, worked out from gross less
net rather than trusting the tax column.

**Expected output:** Four columns — invoice_id, net_amount, gross_amount, tax_element — fifteen rows, largest first.

> **Hint.** You can ORDER BY an alias you defined in the same SELECT.

### q10. The largest postings, either way round

The ten ledger lines with the largest movement in absolute terms —
that is, ignoring whether they are debits or credits.

**Expected output:** Five columns — gl_id, journal_id, account_code, movement, abs_movement — ten rows, largest absolute movement first.

> **Hint.** abs() strips the sign. Sorting on the signed movement would give you the ten biggest debits and no credits at all.

### q11. Credit limits in euros

The ten largest credit limits, also expressed in euros at a fixed
planning rate of 1.18 euros to the pound, rounded to the nearest euro.

**Expected output:** Four columns — customer_id, customer_name, credit_limit_gbp, credit_limit_eur — ten rows, largest first.

> **Hint.** round(x, 0) gives whole units. Tie-break on customer_id: several customers share a limit.

### q12. Monthly salary cost

The twelve highest paid employees showing their monthly salary to the
penny, alongside the annual figure.

**Expected output:** Four columns — employee_id, employee, annual_salary_gbp, monthly_gbp — twelve rows, highest first.

> **Hint.** Dividing produces a long decimal. round(..., 2) fixes it.

### q13. Which regions run which kinds of cost centre?

The distinct combinations of region and cost centre type.

**Expected output:** Two columns — region, cost_centre_type — one row per combination that exists, region order then type.

> **Hint.** DISTINCT applies to the whole row you selected, not to one column.

### q14. Page three of the invoice list

Invoices are being reviewed twenty at a time in invoice_id order. Show
the third page — that is, invoices 41 to 60.

**Expected output:** Three columns — invoice_id, due_date, gross_amount — twenty rows.

> **Hint.** OFFSET skips rows before LIMIT takes them. Work out the offset for page three carefully; off-by-twenty is easy here.

### q15. Implied exchange rates on payments

For the ten largest payments by GBP value, show the payment currency,
the amount, the GBP amount, and the exchange rate that was implied by
the pair.

**Expected output:** Five columns — payment_id, currency, amount, amount_gbp, implied_rate — ten rows, largest GBP amount first.

> **Hint.** The implied rate is the GBP amount divided by the amount. Round it to six decimal places, like the fx_rates table does.

### q16. The report sections in use

List the distinct report sections on the chart of accounts. This is
the skeleton of the statutory accounts.

**Expected output:** One column, one row per section, alphabetical.

> **Hint.** One line of SQL, and a genuinely useful thing to know before you build a P&L.

### q17. Annualised budget lines

The ten largest budget lines, showing the monthly amount and what it
would be if that run rate held for a full year.

**Expected output:** Five columns — budget_id, fiscal_year, account_code, budget_amount_gbp, annualised_gbp — ten rows, largest first.

> **Hint.** Multiply by 12. Whether that is a fair annualisation is a different question — say so if you hand it over.

---

## Stretch (5 questions)

*Vague on purpose. Expect to think, and to look things up.*

### q18. A one-row control summary of the invoice table

Produce a single row that shows: how many invoice rows there are, how
many have a customer, and how many have a supplier. Use it to prove
that every invoice is either a sale or a purchase and never both.

**Expected output:** Three columns — invoice_rows, with_customer, with_supplier — one row.

> **Hint.** count(*) counts rows; count(column) counts non-NULL values. Do the two smaller numbers add up to the big one?

### q19. Currency and country pairs

The distinct combinations of country and currency on the customer
master, so you can see which countries we invoice in which currency.

**Expected output:** Two columns — country, currency — one row per combination, country order then currency. Customers with no country still form a group.

> **Hint.** Think about where the NULL country sorts, and whether that is what you want on a report.

### q20. A staff directory line

Build a single display column for the ten highest paid staff in the
form 'Firstname Surname (Job Title)', alongside their monthly salary
to the penny.

**Expected output:** Two columns — directory_line, monthly_gbp — ten rows, highest paid first.

> **Hint.** Several || in a row. Getting the brackets and spaces right is fiddly and entirely the point.

### q21. Inverse exchange rates

For the first ten fx rate rows by date then currency, show the rate as
published (foreign to GBP) and the inverse (GBP to foreign), to four
decimal places.

**Expected output:** Four columns — rate_date, from_currency, rate, inverse_rate — ten rows.

> **Hint.** 1 divided by the rate. Watch what happens to the precision if you round before dividing rather than after.

### q22. The other end of the distribution

Find the ten smallest values of gross_amount_gbp on the invoice table.
What does the smallest one turn out to be, and why is it there?

**Expected output:** Four columns — invoice_id, invoice_type, status, gross_amount_gbp — ten rows, smallest first.

> **Hint.** Sorting ascending finds the other extreme. The first row is not an invoice at all in the normal sense — check its status.
