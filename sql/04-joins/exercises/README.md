# Exercises — SQL 04 — JOINs

Every question runs against `data/finance.duckdb`. Read the business question
first and decide which table is your *population* — that table goes in the FROM
clause, and everything else hangs off it.

Before you trust any joined total, check the grain: `SELECT key, count(*) ...
GROUP BY key HAVING count(*) > 1`.

Write each answer in `exercises/qNN.sql`. One query per file.

Check your work with:

```bash
pytest sql/04-joins
```

Anything you have not written yet is reported as *skipped*, not failed.

---

## Warm-up (8 questions)

*One idea at a time, and close to a worked example.*

### q01. Expenses by account, 2024

The FD wants total expenditure for calendar 2024 broken down by
account, with the account name rather than the code. Use account_type
to identify expenses.

**Expected output:** Three columns — account_code, account_name, total_gbp — one row per expense account with activity, biggest first.

> **Hint.** Expenses are debit-normal, so sum(debit - credit). Filter the date on general_ledger and the type on chart_of_accounts.

### q02. Ten largest sales invoices

List the ten largest sales invoices by GBP value, showing the customer
name alongside.

**Expected output:** Four columns — invoice_id, customer_name, due_date, gross_amount_gbp — ten rows, largest first.

> **Hint.** invoices is your population. One customer per invoice, so an INNER JOIN adds no rows.

### q03. Ledger lines per cost centre

How many general ledger lines does each cost centre carry? Every cost
centre must appear, including any with no activity at all.

**Expected output:** Three columns — cost_centre_code, cost_centre_name, line_count — one row per cost centre, code order.

> **Hint.** cost_centres is the population, so it goes first and the join is a LEFT JOIN. Count a column from the ledger, not count(*).

### q04. Customers we have never invoiced

Sales ledger wants a list of customer accounts with no sales invoice
against them at all — candidates for deactivation.

**Expected output:** Three columns — customer_id, customer_name, is_active — one row per unused customer, customer_id order.

> **Hint.** LEFT JOIN then keep the rows where the right-hand side came back NULL. Which column do you test for NULL?

### q05. Ledger lines by journal source

Count the general ledger lines behind each journal source (AR, AP,
CASH, PAYROLL, GENERAL).

**Expected output:** Two columns — source, line_count — one row per source, most lines first.

> **Hint.** The source lives on the journal header, the lines live in the general ledger. Join them on journal_id.

### q06. Customers by owning cost centre

How many customer accounts does each sales cost centre own, and what
is their total credit limit?

**Expected output:** Three columns — cost_centre_name, customer_count, total_credit_limit — one row per cost centre that owns customers, largest limit first.

> **Hint.** Start from customers and join to cost_centres.

### q07. Headcount by cost centre, including the unassigned

HR wants headcount and total salary by cost centre. Four employees
have no cost centre on file and must still be visible.

**Expected output:** Three columns — cost_centre_name, headcount, total_salary — one row per cost centre plus one row where the name is NULL, biggest salary bill first.

> **Hint.** employees is the population. Group by the cost centre name from the joined table, which will be NULL for the unassigned four.

### q08. Receipts with their customer

List the first ten customer receipts of 2024 by payment date, showing
which customer they came from.

**Expected output:** Five columns — payment_id, payment_date, customer_id, customer_name, amount_gbp — ten rows, earliest first, then by payment_id.

> **Hint.** payments joins to invoices on invoice_id, and invoices joins to customers. Filter on direction.

---

## Core (10 questions)

*Realistic tasks that combine this topic with earlier ones.*

### q09. Revenue by region and year

Sales invoices, by the region of the owning cost centre and the
calendar year of the due date. The board wants to see the trend.

**Expected output:** Four columns — region, year, invoice_count, gross_gbp — one row per region and year, ordered by region then year.

> **Hint.** Three tables. year(due_date) gives you the year. The invoice whose customer does not exist will be dropped by an INNER JOIN — for this question that is acceptable.

### q10. Top ten customers by value

The ten customers with the highest total sales value, with their
country. Exclude the credit note (it has a negative gross amount).

**Expected output:** Four columns — customer_id, customer_name, country, total_gbp — ten rows, largest first.

> **Hint.** Filter out negative gross amounts before aggregating. NULL countries should still appear if the customer qualifies.

### q11. Purchase spend by supplier country

Total purchase invoice value by supplier country, showing only
countries where we have spent more than £250,000 in total.

**Expected output:** Three columns — country, supplier_count, total_gbp — one row per qualifying country, largest first.

> **Hint.** HAVING filters groups, WHERE filters rows. Count distinct suppliers, not invoices.

### q12. Cost of sales by cost centre, FY2024

Cost of sales (report_section = 'Cost of Sales') for fiscal year 2024,
by cost centre name. Ignore journals that are still in draft.

**Expected output:** Three columns — cost_centre_name, line_count, total_gbp — one row per cost centre with cost of sales, largest first.

> **Hint.** Four tables: general_ledger, journal_entries (for fiscal_year and status), chart_of_accounts (for the section) and cost_centres (for the name).

### q13. Unpaid sales invoices by due year

Sales invoices with no payment recorded against them at all, summarised
by the calendar year they fell due.

**Expected output:** Three columns — due_year, invoice_count, outstanding_gbp — one row per year, earliest first.

> **Hint.** An anti-join: LEFT JOIN to payments and keep the rows where no payment matched. Do not trust invoices.status.

### q14. Invoices where the cash does not agree

Find every invoice where the total of the payments recorded against it
does not equal the invoice gross amount in GBP. Show the difference.

**Expected output:** Five columns — invoice_id, invoice_type, invoice_gbp, paid_gbp, difference — one row per mismatched invoice, biggest difference first.

> **Hint.** Group the join by invoice, then use HAVING to keep only the rows that disagree. Beware: this is the fan-out from the lesson.

### q15. Payroll cost by cost centre and fiscal year

Gross pay, employer NI and pension (accounts 6000, 6010 and 6020) by
cost centre name and fiscal year.

**Expected output:** Four columns — fiscal_year, cost_centre_name, line_count, payroll_gbp — ordered by fiscal year then cost centre name.

> **Hint.** fiscal_year is on the journal header. Payroll control lines have no cost centre, but the 6000-series lines do.

### q16. Journals that do not balance

Six journals in the ledger have debits that do not equal credits. Find
them, and show the header details so someone can investigate.

**Expected output:** Six columns — journal_id, journal_date, source, description, total_debit, total_credit — six rows, journal_id order.

> **Hint.** Aggregate the lines by journal_id and use HAVING. You still need the header columns, so the header must be in the join and in the GROUP BY.

### q17. What did we pay out of the bank account?

For every journal that credits the bank current account (1400), which
accounts were debited, and how much in total? Show the account name.

**Expected output:** Four columns — account_code, account_name, journal_count, total_debited — one row per contra account, largest first.

> **Hint.** Self-join the general ledger on journal_id, then join once more to chart_of_accounts for the name of the debit side.

### q18. The credit control list

For every customer with at least one unpaid sales invoice, how many
are outstanding and what do they total? Credit control works this list
top down.

**Expected output:** Four columns — customer_id, customer_name, unpaid_invoices, outstanding_gbp — one row per customer with unpaid invoices, largest outstanding first.

> **Hint.** Anti-join invoices to payments first to isolate the unpaid ones, then join customers on and group. The customer whose account does not exist cannot appear — decide whether that bothers you.

---

## Stretch (5 questions)

*Vague on purpose. Expect to think, and to look things up.*

### q19. A complete cost centre by source grid

Produce a grid of every cost centre against every journal source, with
the number of ledger lines for that combination — including the
combinations that have never occurred, which must show zero.

**Expected output:** Three columns — cost_centre_code, source, line_count — 8 cost centres x 5 sources = 40 rows, ordered by cost centre then source.

> **Hint.** Build the skeleton first with a CROSS JOIN, then LEFT JOIN the activity onto it. Where do the sources come from if you only have five of them?

### q20. Oldest unpaid invoices at the year end

The fifteen most overdue unpaid sales invoices as at 31 December 2024,
with the customer name, country and how many days past due they were.

**Expected output:** Five columns — invoice_id, customer_name, country, due_date, days_overdue — fifteen rows, most overdue first.

> **Hint.** Subtracting one DATE from another gives a whole number of days. One invoice has a customer who does not exist — decide whether it belongs in the answer and be able to justify it.

### q21. Cost of the duplicate payments

Quantify the damage done by the duplicated payment rows: for each
affected invoice, the number of payment rows, the value that should
have been recorded, and the overstatement.

**Expected output:** Four columns — invoice_id, payment_rows, correct_gbp, overstatement_gbp — one row per affected invoice, invoice_id order.

> **Hint.** You need the invoice value once, not once per payment row. min() or max() of a repeated value gives you the value itself.

### q22. Which revenue accounts sit behind trade debtors?

Using the ledger alone, pair up each debit to trade debtors (1200)
with the revenue account credited in the same journal, and report how
many journals and how much value each pairing represents.

**Expected output:** Four columns — revenue_account, account_name, journal_count, credited_gbp — one row per revenue account, largest first.

> **Hint.** Self-join on journal_id, restrict one side to the debit on 1200 and the other to a credit on a 4xxx account, then bring in the account name.

### q23. Budget against actual, both ways round

For fiscal year 2025 period 1 (April 2024), compare budgeted cost
against actual cost by cost centre, keeping cost centres that appear on
only one side. Cost accounts are 5000 and above.

**Expected output:** Four columns — cost_centre_code, budget_gbp, actual_gbp, variance_gbp — one row per cost centre appearing on either side, cost centre code order. Missing sides show as 0.00.

> **Hint.** A FULL JOIN between two aggregated sets. Each side has to be aggregated before the join or you will fan out. This needs a subquery, which is topic 05 — look at examples/06_full_join.sql and copy the shape.
