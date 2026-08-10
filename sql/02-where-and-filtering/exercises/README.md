# Exercises — SQL 02 — WHERE, operators, IN, BETWEEN, LIKE and NULL

Filtering is where most of the thinking happens. For every question, ask
yourself two things before you write anything:

1. What is the population — which table, and which rows of it?
2. Can any column in my WHERE clause be NULL, and if so, which side of the
   filter do those rows belong on?

The second question is the one that separates a correct answer from a
plausible one.

Write each answer in `exercises/qNN.sql`. One query per file.

Check your work with:

```bash
pytest sql/02-where-and-filtering
```

Anything you have not written yet is reported as *skipped*, not failed.

---

## Warm-up (8 questions)

*One idea at a time, and close to a worked example.*

### q01. Sales invoices in euros

All sales invoices denominated in euros, showing id, due date and gross amount.

**Expected output:** Three columns — invoice_id, due_date, gross_amount — ordered by invoice_id.

> **Hint.** Two conditions joined with AND. Text values need single quotes.

### q02. The revenue accounts

Every account on the chart whose type is INCOME.

**Expected output:** Three columns — account_code, account_name, report_section — code order.

> **Hint.** One condition. Note that account_type is stored in upper case.

### q03. Ledger activity in March 2024

All ledger lines posted in March 2024 with a debit over £5,000.

**Expected output:** Five columns — gl_id, journal_id, account_code, entry_date, debit — entry date order then gl_id.

> **Hint.** Write the date range as >= the first of March AND < the first of April.

### q04. Three specific accounts

Ledger lines on accounts 6100, 6110 and 6120 during calendar 2023.

**Expected output:** Four columns — gl_id, account_code, entry_date, debit — entry date order then gl_id.

> **Hint.** IN is neater than three ORs and has no bracket problem.

### q05. Customers with no country

Which customer accounts have no country recorded?

**Expected output:** Three columns — customer_id, customer_name, currency — customer_id order.

> **Hint.** IS NULL, not = NULL. The second returns nothing at all.

### q06. Suppliers whose name mentions metals or tooling

Find every supplier whose name contains 'metals' or 'tooling', regardless of how it is capitalised.

**Expected output:** Three columns — supplier_id, supplier_name, country — supplier_id order.

> **Hint.** ILIKE with % either side. Plain LIKE would miss most of them.

### q07. Mid-sized credit limits

Customers whose credit limit is between £50,000 and £150,000 inclusive.

**Expected output:** Three columns — customer_id, customer_name, credit_limit_gbp — largest limit first, then customer_id.

> **Hint.** BETWEEN includes both ends, which is what 'inclusive' means.

### q08. Payments that were not made by BACS

Payments settled by any method other than BACS. Watch the casing.

**Expected output:** Four columns — payment_id, payment_date, method, amount_gbp — payment_date order then payment_id.

> **Hint.** There is a lower case 'bacs' in this column too. Deal with it, or explain in a comment why your answer includes rows it should not.

---

## Core (10 questions)

*Realistic tasks that combine this topic with earlier ones.*

### q09. Large overseas sales

Sales invoices over £20,000 in GBP terms, raised in a currency other
than sterling, that fell due in calendar 2024.

**Expected output:** Five columns — invoice_id, currency, due_date, gross_amount, gross_amount_gbp — largest GBP amount first.

> **Hint.** Three conditions. Does currency have NULLs? Check before you rely on <>.

### q10. Draft journals

Every journal still sitting in draft, with who prepared it.

**Expected output:** Six columns — journal_id, journal_date, source, description, prepared_by, approved_by — journal_id order.

> **Hint.** Eight rows. Every one of them has ledger lines that will appear in your P&L.

### q11. Journals nobody approved

Posted journals with no approver recorded.

**Expected output:** Five columns — journal_id, journal_date, source, description, prepared_by — journal_id order.

> **Hint.** A missing approver is a NULL, not an empty string.

### q12. Overdue at the year end

Sales invoices that fell due on or before 30 November 2024 and are
still marked as anything other than paid. Take the status column at
face value for this question, casing and all.

**Expected output:** Five columns — invoice_id, due_date, status, currency, gross_amount_gbp — due_date order then invoice_id.

> **Hint.** 'PAID', 'Paid', 'paid' and 'PAID ' are four different strings. You will need all four, and this is exactly why nobody should filter on this column.

### q13. Operating expenses excluding payroll

Ledger lines in FY2024 on operating expense accounts, but excluding
the payroll accounts 6000, 6010 and 6020.

**Expected output:** Four columns — gl_id, account_code, entry_date, debit — largest debit first then gl_id, top 20 only.

> **Hint.** Account codes 6000-6999 are operating expenses. NOT IN excludes a list. The date range for FY2024 is April 2023 to March 2024.

### q14. Customers on unusual terms

Active customers whose payment terms are not the standard 30 days —
including any where the terms are missing entirely, because those
need chasing too.

**Expected output:** Four columns — customer_id, customer_name, payment_terms_days, is_active — terms then customer_id, NULLs last.

> **Hint.** This is the <> and NULL problem from example 6. Two conditions, one of them about absence.

### q15. Receipts in a single week

Customer receipts banked between 1 and 7 July 2024 inclusive.

**Expected output:** Five columns — payment_id, payment_date, invoice_id, method, amount_gbp — date order then payment_id.

> **Hint.** Both a direction filter and a date range. Prefer >= and < over BETWEEN for dates.

### q16. Every export sale to a named customer group

Sales invoices raised to customers whose id is one of C2004, C2017,
C2030 or C2043 — the four accounts with no country on file — where
the gross exceeds £10,000.

**Expected output:** Five columns — invoice_id, customer_id, due_date, currency, gross_amount — customer then due date.

> **Hint.** IN with a list of text values. Each value needs its own quotes.

### q17. The VAT control account

Every posting to the VAT control account in FY2025 (April 2024
onwards) of more than £1,000 on either side.

**Expected output:** Six columns — gl_id, journal_id, entry_date, line_description, debit, credit — entry_date then gl_id.

> **Hint.** 'More than 1,000 on either side' means a condition on debit OR a condition on credit. Mind the brackets.

### q18. Ledger lines with no cost centre

Which accounts carry ledger lines with no cost centre, and how many lines each?

**Expected output:** Two columns — account_code, line_count — most lines first then account code.

> **Hint.** Filter for the NULL, then use the counting recipe from topic 00.

---

## Stretch (5 questions)

*Vague on purpose. Expect to think, and to look things up.*

### q19. Prove the NULL trap for yourself

Produce one row with three counts: customers outside the United
Kingdom using a simple <> test, the same test plus the missing
countries, and the total number of customers. Show that the naive
answer is understated.

**Expected output:** Three columns — naive_non_uk, correct_non_uk, all_customers — one row.

> **Hint.** count(*) FILTER (WHERE ...) counts rows matching a condition inside a single query. It is a DuckDB and PostgreSQL feature worth learning now — you will meet the portable version, conditional aggregation, in topic 07.

### q20. Suspect journal descriptions

Find ledger lines whose description has been mangled — the ones
stored entirely in upper case with padding. Return the twenty with
the largest debit.

**Expected output:** Four columns — gl_id, journal_id, line_description, debit — largest debit first then gl_id.

> **Hint.** upper(x) = x is true when a string is already upper case. Does that catch descriptions with no letters in them at all?

### q21. Weekend-dated postings

Ledger lines dated on a Saturday or Sunday. There should be none, and
if there are, that is a finding.

**Expected output:** Four columns — gl_id, journal_id, entry_date, day_name — entry_date then gl_id.

> **Hint.** dayofweek() returns 0 for Sunday through 6 for Saturday in DuckDB. dayname() gives the label. Dates are topic 08 — this is a look ahead.

### q22. Which customer names are duplicated once you ignore the mess?

Two customer records are near-duplicates of existing accounts, hidden
behind different capitalisation and stray spaces. Find every customer
name that appears more than once after trimming the whitespace and
folding the case.

**Expected output:** Two columns — clean_name, times_it_appears — name order.

> **Hint.** lower(trim(customer_name)) normalises the name. Group by the normalised version, not the raw one. Strings are topic 09 — these two functions are all you need here.

### q23. Invoices due on the last day of a month

Sales invoices over £30,000 falling due on the last day of any month.
Payment terms of 30 or 60 days from a month end cluster there, and it
matters for cash forecasting.

**Expected output:** Four columns — invoice_id, due_date, currency, gross_amount_gbp — due_date then invoice_id.

> **Hint.** last_day(d) returns the last date of that date's month. Compare the due date with it.
