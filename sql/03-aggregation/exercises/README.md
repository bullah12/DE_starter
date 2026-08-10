# Exercises — SQL 03 — Aggregation

Every question here is a pivot table you have built a hundred times. The work
is in saying it precisely: what are the row labels (GROUP BY), what are the
values (the aggregates), which rows go in (WHERE) and which groups come out
(HAVING).

Round money to two decimal places in your output. Where a question asks for a
signed balance, state which way round you have defined it.

Write each answer in `exercises/qNN.sql`. One query per file.

Check your work with:

```bash
pytest sql/03-aggregation
```

Anything you have not written yet is reported as *skipped*, not failed.

---

## Warm-up (8 questions)

*One idea at a time, and close to a worked example.*

### q01. Size up the invoice table

One row showing the number of invoices, the total gross in GBP, and the smallest and largest gross GBP values.

**Expected output:** Four columns — invoice_count, total_gbp, smallest_gbp, largest_gbp — one row.

> **Hint.** No GROUP BY: the whole table is one group.

### q02. Invoices by type

Count the invoices and total their gross GBP value, split by invoice type.

**Expected output:** Three columns — invoice_type, invoice_count, total_gbp — type order.

> **Hint.** One grouping column.

### q03. Ledger lines by account

For every account with ledger activity, the number of lines, total debits and total credits.

**Expected output:** Four columns — account_code, line_count, total_debit, total_credit — account code order.

> **Hint.** This is a trial balance without the balance column.

### q04. Headcount and salary by cost centre code

Number of employees and total salary for each cost centre code on the employee record.

**Expected output:** Three columns — cost_centre_code, headcount, total_salary — code order, the missing cost centre last.

> **Hint.** NULL forms its own group. Where does it sort?

### q05. Payments by method

Count and total the payments by method, in GBP.

**Expected output:** Three columns — method, payment_count, total_gbp — most payments first.

> **Hint.** The casing problem is still there. Group on the raw column for now, and notice what it does to the answer.

### q06. Payments by method, cleaned up

The same summary, but with the upper and lower case spellings of each method combined.

**Expected output:** Three columns — method, payment_count, total_gbp — most payments first.

> **Hint.** Group by upper(method) rather than method. Alias it back to something readable.

### q07. Budget by fiscal year

Total budgeted amount for each fiscal year, and how many budget lines make it up.

**Expected output:** Three columns — fiscal_year, budget_lines, total_budget_gbp — year order.

> **Hint.** One grouping column, two aggregates.

### q08. Big spending accounts

Accounts with more than £1,000,000 of debits across the whole ledger.

**Expected output:** Three columns — account_code, line_count, total_debit — largest debit first.

> **Hint.** A condition on a total is a condition on a group, so it goes in HAVING.

---

## Core (10 questions)

*Realistic tasks that combine this topic with earlier ones.*

### q09. Monthly revenue

Revenue by calendar month across the whole ledger — income accounts
only, using the account code range 4000 to 4999.

**Expected output:** Three columns — month, line_count, revenue_gbp — month order. Month as the first day of the month.

> **Hint.** date_trunc('month', entry_date) collapses a date to the first of its month. Dates are topic 08 — this one function is worth borrowing early. Income is credit-normal.

### q10. Cost centre spend, top ten

The ten cost centres with the highest total expense (accounts 5000
and above) in FY2024, that is April 2023 to March 2024.

**Expected output:** Three columns — cost_centre_code, line_count, spend_gbp — largest first.

> **Hint.** Only eight cost centres exist, so ten is a trick: you will get however many there are. Decide what to do with the lines that have no cost centre.

### q11. Customer invoice profile

For every customer that has been invoiced, the number of sales
invoices, the total, the average and the largest, all in GBP.

**Expected output:** Five columns — customer_id, invoice_count, total_gbp, average_gbp, largest_gbp — largest total first.

> **Hint.** Four aggregates over the same group. Round the average.

### q12. Journals per source per year

How many journals were raised from each source in each calendar year?

**Expected output:** Three columns — year, source, journal_count — year then source.

> **Hint.** year(journal_date) as a grouping column. You can group by an expression, not just a bare column.

### q13. Accounts that only ever get credited

Which accounts have credits but no debits at all across the whole
ledger? These are the accumulating credit balances.

**Expected output:** Three columns — account_code, line_count, total_credit — largest credit first.

> **Hint.** A group where sum(debit) = 0. That is a HAVING condition.

### q14. Supplier concentration

Suppliers accounting for more than £200,000 of purchase invoices,
with the number of invoices and the average invoice value.

**Expected output:** Four columns — supplier_id, invoice_count, total_gbp, average_gbp — largest total first.

> **Hint.** Group the invoices table by supplier_id; you do not need the supplier table for this. HAVING for the threshold.

### q15. Does the ledger balance, year by year?

Total debits and credits by calendar year, with the difference. In a
double-entry ledger the difference must be zero. Find the years where
it is not.

**Expected output:** Five columns — year, line_count, total_debit, total_credit, difference — year order.

> **Hint.** year(entry_date) as the grouping column. The difference is an expression built from two aggregates, which is allowed.

### q16. Invoice value bands by count

How many sales invoices fall in each thousand-pound band of gross
GBP value, up to the tenth band? Band 0 is under £1,000, band 1 is
£1,000 to £1,999, and so on.

**Expected output:** Three columns — band, invoice_count, total_gbp — band order, bands 0 to 10 only.

> **Hint.** Integer division by 1000 gives the band. floor(x / 1000) or x // 1000 both work.

### q17. How long has each customer been trading with us?

For every customer with sales invoices, the number of invoices, the
earliest and latest due date, and the number of days between them.

**Expected output:** Five columns — customer_id, invoice_count, first_due, last_due, days_span — longest span first then customer_id.

> **Hint.** min() and max() work on dates. Subtracting one date from another gives whole days, and you can subtract two aggregates.

### q18. Quiet accounts

Accounts with fewer than ten ledger lines in the whole three years.
These are the ones worth asking about before you build a report
around them.

**Expected output:** Four columns — account_code, line_count, total_debit, total_credit — fewest lines first then account code.

> **Hint.** HAVING count(*) < 10.

---

## Stretch (5 questions)

*Vague on purpose. Expect to think, and to look things up.*

### q19. Prove the ledger does not balance, and size the hole

One row: total debits, total credits, the difference, and how many
distinct journals are involved in creating it.

**Expected output:** Four columns — total_debit, total_credit, difference, broken_journals — one row.

> **Hint.** The first three are easy. The fourth needs a count of journals where the debits and credits disagree, which is a group-level test — think about how to count groups rather than rows. A subquery (topic 05) is the clean way; count(DISTINCT ...) with a FILTER will not get you there on its own.

### q20. Revenue concentration

How much of our sales value comes from the top customers? For each
customer show their total sales and what percentage of all sales that
represents, for the ten largest.

**Expected output:** Three columns — customer_id, total_gbp, pct_of_total — largest first.

> **Hint.** The denominator is a total over the whole table while you are grouping by customer. A scalar subquery does it; a window function (topic 06) does it more elegantly. Either is a fair answer here.

### q21. Average invoice by month and type

The average invoice value in GBP by calendar month and invoice type,
but only for month and type combinations with at least twenty
invoices.

**Expected output:** Five columns — month, invoice_type, invoice_count, average_gbp, total_gbp — month then type.

> **Hint.** Two grouping columns and a HAVING on the count. Use due_date for the month, since invoice_date is text in three formats.

### q22. The cost of the missing cost centre

For each account that has ledger lines with no cost centre, show how
many lines and how much value are unattributable, and what percentage
of that account's total value they represent.

**Expected output:** Five columns — account_code, unattributed_lines, unattributed_gbp, account_total_gbp, pct_unattributed — largest unattributed value first.

> **Hint.** You need both a filtered total and an unfiltered total in the same row. count(*) FILTER (WHERE ...) and sum(...) FILTER (WHERE ...) do exactly that.

### q23. Does the sales ledger agree with the nominal ledger?

Compare, by calendar year, the total of sales invoices raised
(invoices table) with the revenue posted to the ledger (accounts 4000
to 4999). They should be close but not identical — explain the
difference in a comment.

**Expected output:** Four columns — year, invoiced_gbp, posted_gbp, difference — year order.

> **Hint.** Two independent aggregations that have to end up side by side. Two subqueries and a join, or a UNION and a regroup. Both are later topics — pick one, make it work, and note which parts you had to look up.
