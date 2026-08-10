# The data: Ashcombe Components Ltd

Everything you query in this course comes from one fictional company.

**Ashcombe Components Ltd** is a mid-sized UK distributor of industrial
components, headquartered in the South East with a warehouse and a small
manufacturing operation in the Midlands. It sells into the UK and exports to
Ireland, Germany, France, the Netherlands, Spain and the United States. Turnover
runs at roughly £6.5–7.5m a year.

Its functional currency is **GBP**. Its **fiscal year runs 1 April to 31 March**
and is labelled by the year it ends in — so FY2024 means April 2023 to March
2024. Fiscal period 1 is April, period 12 is March. Note that this is not the
calendar year; several exercises exist purely to make you feel that difference.

The data covers **1 January 2022 to 31 December 2024**.

Keep this page open. You will refer to it constantly, in the same way you would
keep a chart of accounts open when working somewhere new.

---

## Building the database

```bash
python data/build_db.py
```

Reads every CSV in `data/raw/` and writes `data/finance.duckdb`. It drops and
rebuilds everything each time, so it is always safe to re-run. `finance.duckdb`
is deliberately **not** committed to git — it is a build output, and you can
always recreate it.

`data/generate_raw.py` is the script that produced the CSVs. You never need to
run it; it is committed so you can see where the numbers came from.

---

## The tables at a glance

| Table | Rows | Grain (what one row means) |
|---|---:|---|
| `chart_of_accounts` | 56 | One nominal account |
| `cost_centres` | 8 | One cost centre |
| `employees` | 82 | One employee |
| `customers` | 64 | One customer account |
| `suppliers` | 47 | One supplier account |
| `fx_rates` | 1,538 | One currency, one date |
| `journal_entries` | 6,395 | One journal header |
| `general_ledger` | 16,872 | One journal **line** |
| `invoices` | 3,225 | One sales or purchase invoice |
| `payments` | 3,050 | One receipt or payment |
| `budgets` | 1,772 | One account × cost centre × fiscal period |

Row counts are exact for the committed CSVs. If your counts differ, rebuild.

### How the tables relate

```
chart_of_accounts ──< general_ledger >── journal_entries
                          │
cost_centres ─────────────┤
                          │
customers ──< invoices >── payments
suppliers ──┘
cost_centres ──< budgets >── chart_of_accounts
employees ──> cost_centres
fx_rates      (joined on currency + date)
```

`──<` means "one to many". Read `chart_of_accounts ──< general_ledger` as: one
account has many ledger lines; each ledger line has exactly one account.

The two most important relationships:

- **`journal_entries` (header) to `general_ledger` (lines)** on `journal_id`.
  One journal, several lines, debits equal credits — except where they do not
  (see the defect list). This is exactly the header/detail structure you know
  from any accounting system.
- **`invoices` to `payments`** on `invoice_id`. An invoice may have no payment
  (still outstanding) or exactly one (settled in full). There is no part
  payment in this dataset.

---

## Table reference

### `chart_of_accounts`

| Column | Type | Notes |
|---|---|---|
| `account_code` | INTEGER | Primary key. 1xxx assets, 2xxx liabilities, 3xxx equity, 4xxx income, 5xxx cost of sales, 6xxx–8xxx expenses |
| `account_name` | VARCHAR | ⚠ inconsistent casing and trailing whitespace |
| `account_type` | VARCHAR | `ASSET`, `LIABILITY`, `EQUITY`, `INCOME`, `EXPENSE` |
| `report_section` | VARCHAR | `Fixed Assets`, `Current Assets`, `Current Liabilities`, `Long Term Liabilities`, `Equity`, `Revenue`, `Cost of Sales`, `Operating Expenses`, `Finance Costs`, `Tax` |
| `normal_balance` | VARCHAR | `DEBIT` or `CREDIT` — which side increases the account |
| `is_active` | VARCHAR | `Y` or `N`. Three accounts (1410, 4900, 6030) are closed but still on the chart |

Note that `5000` Materials Purchases through `5030` are typed `EXPENSE` but
sectioned `Cost of Sales`. That is deliberate: `account_type` drives the
accounting treatment, `report_section` drives the report layout. You will need
both.

### `cost_centres`

| Column | Type | Notes |
|---|---|---|
| `cost_centre_code` | VARCHAR | Primary key, `CC100`–`CC600` |
| `cost_centre_name` | VARCHAR | e.g. `Sales - North` |
| `region` | VARCHAR | `South East`, `North West`, `Midlands` |
| `cost_centre_type` | VARCHAR | `REVENUE`, `OPERATIONS`, `SUPPORT` |

The smallest table in the database, and the one you will join to most often.

### `employees`

| Column | Type | Notes |
|---|---|---|
| `employee_id` | INTEGER | Primary key, from 1001 |
| `first_name`, `last_name` | VARCHAR | |
| `email` | VARCHAR | ⚠ some are upper case |
| `job_title` | VARCHAR | |
| `cost_centre_code` | VARCHAR | → `cost_centres`. ⚠ 4 employees have no cost centre |
| `hire_date` | **VARCHAR** | ⚠ three date formats mixed — see below |
| `termination_date` | **VARCHAR** | ⚠ same, and NULL for current staff |
| `annual_salary_gbp` | DECIMAL(15,2) | Full-time equivalent, GBP |

`prepared_by` and `approved_by` on `journal_entries` point here.

### `customers`

| Column | Type | Notes |
|---|---|---|
| `customer_id` | VARCHAR | Primary key, `C2000`+ |
| `customer_name` | VARCHAR | ⚠ mixed casing, leading/trailing whitespace |
| `country` | VARCHAR | ⚠ 5 rows are NULL |
| `currency` | VARCHAR | `GBP`, `EUR` or `USD` — the currency they are invoiced in |
| `payment_terms_days` | INTEGER | 14 to 90. ⚠ 4 rows are NULL |
| `credit_limit_gbp` | DECIMAL(15,2) | |
| `created_date` | DATE | Clean ISO dates |
| `cost_centre_code` | VARCHAR | The sales cost centre that owns the account |
| `is_active` | VARCHAR | `Y`/`N` |

### `suppliers`

Same shape, minus the cost centre and credit limit.

| Column | Type | Notes |
|---|---|---|
| `supplier_id` | VARCHAR | `S3000`+. ⚠ **not unique** — one exact duplicate row |
| `supplier_name` | VARCHAR | ⚠ mixed casing and whitespace |
| `country` | VARCHAR | ⚠ 3 rows are NULL |
| `currency` | VARCHAR | |
| `payment_terms_days` | INTEGER | |
| `created_date` | DATE | |
| `is_active` | VARCHAR | |

### `fx_rates`

| Column | Type | Notes |
|---|---|---|
| `rate_date` | DATE | |
| `from_currency` | VARCHAR | `EUR` or `USD` |
| `to_currency` | VARCHAR | Always `GBP` |
| `rate` | DECIMAL(12,6) | Multiply a foreign amount by this to get GBP |

⚠ **There is no rate on weekends**, and roughly 1% of weekdays are missing too.
An invoice dated on a Saturday therefore has no same-day rate. Handling that
gap — carrying the last published rate forward — is a real exercise, not a bug.

### `journal_entries` — the journal header

| Column | Type | Notes |
|---|---|---|
| `journal_id` | VARCHAR | Primary key, `JE-2023-01234` |
| `journal_date` | DATE | The accounting date the entry belongs to |
| `posted_date` | DATE | When it actually hit the ledger — 0–3 working days later |
| `period` | VARCHAR | Calendar period, `YYYY-MM` |
| `fiscal_year` | VARCHAR | `FY2022`–`FY2025` |
| `fiscal_period` | INTEGER | 1 = April … 12 = March |
| `source` | VARCHAR | `AR`, `AP`, `CASH`, `PAYROLL`, `GENERAL` |
| `description` | VARCHAR | |
| `prepared_by` | INTEGER | → `employees.employee_id` |
| `approved_by` | INTEGER | → `employees.employee_id`, may be NULL |
| `status` | VARCHAR | `POSTED` or `DRAFT`. ⚠ 8 journals are still in draft |

**Draft journals still have general ledger lines.** If you do not filter them
out, your P&L includes entries that were never approved. Nobody will tell you
this at the time; the number will just be slightly wrong.

### `general_ledger` — the journal lines

| Column | Type | Notes |
|---|---|---|
| `gl_id` | INTEGER | Primary key |
| `journal_id` | VARCHAR | → `journal_entries` |
| `line_number` | INTEGER | Line within the journal, from 1 |
| `account_code` | INTEGER | → `chart_of_accounts` |
| `cost_centre_code` | VARCHAR | → `cost_centres`. ⚠ 231 lines are NULL (mostly payroll control accounts) |
| `entry_date` | DATE | Same as the header's `journal_date` |
| `line_description` | VARCHAR | ⚠ some upper-cased and padded |
| `debit` | DECIMAL(15,2) | 0.00 where the line is a credit |
| `credit` | DECIMAL(15,2) | 0.00 where the line is a debit |

Debits and credits are **separate columns**, both positive — the layout you are
used to. To get a signed movement you subtract one from the other, and which way
round depends on the account:

```sql
-- income and liabilities: credits increase the balance
sum(credit - debit)
-- assets and expenses: debits increase the balance
sum(debit - credit)
```

This is the single most common source of sign errors in the whole course. When a
number comes out negative and you did not expect it, check this first.

### `invoices`

One row per sales or purchase invoice.

| Column | Type | Notes |
|---|---|---|
| `invoice_id` | VARCHAR | `SI-2023-01234` (sales) or `PI-2023-01234` (purchase) |
| `invoice_type` | VARCHAR | `SALES` or `PURCHASE` |
| `customer_id` | VARCHAR | Populated for sales, NULL for purchases |
| `supplier_id` | VARCHAR | Populated for purchases, NULL for sales |
| `invoice_date` | **VARCHAR** | ⚠ three date formats mixed — see below |
| `due_date` | DATE | Clean. Invoice date plus the account's payment terms |
| `currency` | VARCHAR | The invoice currency |
| `net_amount` | DECIMAL(15,2) | Excluding VAT, in invoice currency |
| `tax_amount` | DECIMAL(15,2) | VAT at 20% for UK counterparties, 0.00 otherwise |
| `gross_amount` | DECIMAL(15,2) | `net_amount + tax_amount`, in invoice currency |
| `gross_amount_gbp` | DECIMAL(15,2) | Gross converted at the invoice-date rate |
| `cost_centre_code` | VARCHAR | |
| `status` | VARCHAR | ⚠ `PAID`/`Paid`/`paid`/`PAID ` and `OPEN`/`Open`/`open`/`OPEN ` |

⚠ `status` is **not reliable**. It was set by the source system and one invoice
is marked `CREDITED`. Where an exercise asks whether an invoice is settled, work
it out from `payments`, not from this column. Learning to distrust a status flag
is part of the job.

### `payments`

| Column | Type | Notes |
|---|---|---|
| `payment_id` | VARCHAR | `RCP-…` for receipts, `PAY-…` for payments. ⚠ **not unique** |
| `invoice_id` | VARCHAR | → `invoices`. Every payment matches a real invoice |
| `direction` | VARCHAR | `RECEIPT` (money in) or `PAYMENT` (money out) |
| `payment_date` | DATE | Clean ISO dates |
| `currency` | VARCHAR | |
| `amount` | DECIMAL(15,2) | In the payment currency, always equals the invoice gross |
| `amount_gbp` | DECIMAL(15,2) | Converted at the **payment-date** rate, so it differs from `gross_amount_gbp` — that difference is the FX gain or loss |
| `method` | VARCHAR | `BACS`, `CHEQUE`, `CARD`, `DD`. ⚠ some lower case |
| `bank_reference` | VARCHAR | |

### `budgets`

| Column | Type | Notes |
|---|---|---|
| `budget_id` | INTEGER | Primary key |
| `fiscal_year` | VARCHAR | `FY2023`, `FY2024`, `FY2025` only |
| `fiscal_period` | INTEGER | 1–12, where 1 is April |
| `account_code` | INTEGER | → `chart_of_accounts`. Income and expense accounts only |
| `cost_centre_code` | VARCHAR | → `cost_centres` |
| `budget_amount_gbp` | DECIMAL(15,2) | Positive for income and for cost — a magnitude, not a signed movement |
| `status` | VARCHAR | All `APPROVED` |
| `version` | VARCHAR | All `v2` |

⚠ **There is no FY2022 budget.** January to March 2022 has actuals and no
budget. There are also account/cost-centre combinations with actuals and no
budget line, and a few with a budget and no actuals. That is what makes budget
versus actual a `FULL JOIN` problem rather than a lookup — and it is exactly how
it goes in practice.

---

## Known data quality issues

The complete list. Everything here was injected on purpose.

| # | Table | Issue | Scale |
|---|---|---|---|
| 1 | `invoices` | `invoice_date` holds three formats: `2023-04-17`, `17/04/2023`, `17-Apr-2023` | all 3,225 rows |
| 2 | `employees` | `hire_date` and `termination_date` — same three formats | all rows |
| 3 | `customers` | Leading/trailing whitespace and random casing on `customer_name` | most rows |
| 4 | `suppliers` | Same, on `supplier_name` | most rows |
| 5 | `chart_of_accounts` | Whitespace and upper-casing on some `account_name` values | ~12 rows |
| 6 | `general_ledger` | Upper-cased, padded `line_description` on a scattering of lines | ~80 rows |
| 7 | `customers` | Two near-duplicate records: `C2900` and `C2901` repeat an existing company under a new id | 2 rows |
| 8 | `suppliers` | One exact duplicate row (`S3003` appears twice) | 1 row |
| 9 | `payments` | Duplicate rows: two exact duplicates plus one same-payment-different-reference | 3 rows |
| 10 | `customers` | `country` NULL | 5 rows |
| 11 | `customers` | `payment_terms_days` NULL | 4 rows |
| 12 | `suppliers` | `country` NULL | 3 rows |
| 13 | `employees` | `cost_centre_code` NULL | 4 rows |
| 14 | `general_ledger` | `cost_centre_code` NULL | 231 rows |
| 15 | `journal_entries` | `approved_by` NULL — posted without approval | 19 rows |
| 16 | `general_ledger` | **Six journals do not balance** — debits ≠ credits, header still says `POSTED` | 6 journals |
| 17 | `journal_entries` | Eight journals are `DRAFT` but have live GL lines | 8 journals |
| 18 | `invoices` | `status` casing inconsistent, and unreliable as a settlement flag | all rows |
| 19 | `invoices` | One credit note (`SI-2022-90001`) with negative amounts | 1 row |
| 20 | `invoices` | One sales invoice references customer `C2999`, who does not exist | 1 row |
| 21 | `invoices` | One purchase invoice references supplier `S3999`, who does not exist | 1 row |
| 22 | `fx_rates` | No weekend rates, plus ~1% of weekdays missing | ~200 gaps |
| 23 | `payments` | `method` casing inconsistent | ~130 rows |
| 24 | `budgets` | No FY2022 budget; some actual/budget combinations do not pair up | structural |

**Do not "fix" the CSVs.** Later topics depend on this mess existing. When an
exercise wants clean data, it will ask you to clean it in the query or in
Python — which is how it works on a real system, where you rarely get to edit
the source.

Also: this list is a reference, not a to-do list. Some exercises ask you to
*find* a defect. Try before you look it up.

---

## Numbers you can check yourself against

Useful for confirming your query is right before you look at a solution. All
figures include draft journals unless stated.

| Question | Answer |
|---|---|
| Total debits in the general ledger | £76,529,377.70 |
| Total credits in the general ledger | £75,998,026.00 |
| Difference (the six broken journals) | £531,351.70 |
| Revenue, calendar 2022 | £6,370,770.56 |
| Revenue, calendar 2023 | £6,591,351.83 |
| Revenue, calendar 2024 | £7,579,619.48 |
| Sales invoices with no payment at 31/12/2024 | 121 |
| Earliest / latest GL entry date | 2022-01-03 / 2024-12-31 |

If your total revenue is out by a few hundred thousand, you probably included
the draft journals — or excluded them when you should not have. If it is out by
a factor of two, check your debit/credit signs.

---

## A word about the mess

If you have ever received a system extract from a client, you already know that
this is optimistic rather than pessimistic. Real extracts have all of the above
plus columns that changed meaning halfway through the year.

The instinct this dataset is trying to build is: **before you answer the
question, count the rows and check the total ties.** You do this already in
Excel — you just do it by eye. Here you will do it in code, on purpose, every
time.
