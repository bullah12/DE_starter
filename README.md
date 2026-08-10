# From Accountant to Data Engineer

A self-paced course that teaches you to **write code**, using the only domain you
already think fluently in: finance.

Every table you query is a general ledger, a trial balance, an AR ageing, a
budget. Every exercise is a question a finance director might actually ask you.
Nothing here will try to persuade you that data is valuable — you have spent a
decade proving that in Excel. This teaches you the tools.

---

## Who this is for

You are a qualified accountant. You are fast in Excel, you think in structured
data, you reconcile for a living, and you have never written a line of code.

That is a much better starting position than it feels like. Most of what makes
SQL hard for beginners — thinking in sets, understanding cardinality, knowing
that a total must tie back — you already do daily. What you are missing is
syntax, tooling, and the habit of expressing your logic as text rather than as
cell references.

So this course assumes:

- **You know the domain.** A "debit balance", a "control account" and an
  "accrual" need no explanation.
- **You know nothing about programming.** Every term — variable, function,
  argument, exception, module — gets defined the first time it appears.
- **You learn by doing.** Roughly 20% of your time here is reading, 80% is
  writing code that either works or does not.

## What you will be able to do at the end

- Write SQL confidently against a real (messy) finance database: filtering,
  aggregating, joining across many tables, window functions, date logic,
  pivoting, cleaning.
- Write Python from first principles: data structures, control flow, functions,
  error handling, files, testing — then pandas on top of that foundation.
- Build a small end-to-end data pipeline that reads raw CSVs, validates them,
  loads a database, and produces a budget-vs-actual report — with tests and
  logging.
- Know what to learn next, and why.

---

## How this repository works

```
README.md              you are here — roadmap and schedule
SETUP.md               install everything, run your first script (start here)
requirements.txt       the four libraries this course uses
data/
  raw/                 the company's CSV extracts (deliberately imperfect)
  build_db.py          builds finance.duckdb from data/raw
  README.md            data dictionary + known data quality issues
sql/                   14 topics, 00 → 13
python/                15 topics, 00 → 14
projects/              4 capstones
reference/             cheatsheets and glossary
progress/CHECKLIST.md  tick things off as you go
```

Every topic directory has the same four parts:

| Part | What it is | How to use it |
|---|---|---|
| `README.md` | The lesson. Why it matters, the concept, 3–5 worked examples with output, common mistakes. | Read it once through, then again with the examples open. |
| `examples/` | Every worked example as a file you can actually run. | Run them. Change a line. Break them on purpose. |
| `exercises/` | 20–25 questions: ~8 warm-up, ~10 core, ~5 stretch. | This is the actual course. The lesson is just the briefing. |
| `solutions/` | A worked answer to every question, explaining *why*. | Only after you have written something, even something wrong. |

And each topic can check your work automatically:

```bash
pytest sql/03-joins        # runs your query files against DuckDB
pytest python/05-functions # runs tests against the functions you wrote
```

Green means you are done. Red tells you what does not match, and why.

### The rule about spoilers

Solutions live in a separate directory precisely so you do not read them by
accident. Attempt every question first. A wrong answer you had to think about is
worth more than a right answer you read. When you are truly stuck, the exercise
hint comes before the solution — it nudges, it does not tell.

### The rule about order

Nothing in this course uses a concept that has not yet been taught. If you find
yourself thinking "surely there's a neater way to do this" — there usually is,
and it is usually in a later topic. Where that happens, the text says so and
points forward. Trust the order.

---

## The roadmap

### SQL track — the main event

| # | Topic | What you learn |
|---|---|---|
| 00 | Orientation | Database vs spreadsheet, tables, rows, columns, keys, your first query |
| 01 | SELECT | Columns, aliases, expressions, `ORDER BY`, `LIMIT` |
| 02 | WHERE | Comparison and logical operators, `IN`, `BETWEEN`, `LIKE`, and NULL |
| 03 | Aggregation | `COUNT/SUM/AVG/MIN/MAX`, `GROUP BY`, `HAVING` — the pivot table, in text |
| 04 | JOINs | `INNER/LEFT/RIGHT/FULL/CROSS`, self-joins, multi-table, and debugging silent row duplication |
| 05 | Subqueries and CTEs | Nested and chained `WITH` clauses — building a query in readable stages |
| 06 | Window functions | `ROW_NUMBER`, `RANK`, `LAG/LEAD`, running totals, moving averages, partitioned aggregates |
| 07 | Conditional logic | `CASE`, `COALESCE`, `NULLIF`, conditional aggregation, pivoting rows to columns |
| 08 | Dates and times | Truncation, intervals, period-over-period, fiscal calendars |
| 09 | Strings and casting | Type coercion, cleaning dirty data in SQL |
| 10 | Set operations | `UNION`, `UNION ALL`, `INTERSECT`, `EXCEPT` — reconciliation in one statement |
| 11 | DDL and DML | `CREATE`, `INSERT`, `UPDATE`, `DELETE`, constraints, keys, transactions |
| 12 | Structure and performance | Execution order, `EXPLAIN`, indexes, why a query is slow |
| 13 | Data modelling | Normalisation, star schema, fact vs dimension tables |

Topic 06 is the one that matters most for your career. Running totals, ranking
within a group, comparing a row to the previous period — that is the work
between "can query" and "is a data professional". Do not rush it.

### Python track

| # | Topic | What you learn |
|---|---|---|
| 00 | Orientation | The interpreter, scripts vs notebooks, running code, reading errors |
| 01 | Variables and types | Numbers, strings, f-strings, conversion |
| 02 | Collections | Lists, tuples, dicts, sets — and when to reach for each |
| 03 | Conditionals | `if/elif/else` and boolean logic |
| 04 | Loops | Iteration patterns, `enumerate`, `zip`, comprehensions |
| 05 | Functions | Arguments, defaults, return values, scope, docstrings |
| 06 | Errors | Reading tracebacks, `try/except`, raising, assertions |
| 07 | Files and formats | CSV, JSON, text, paths with `pathlib` |
| 08 | Modules and projects | Imports, virtual environments, project layout |
| 09 | Dates | `datetime`, `timedelta`, parsing, timezones |
| 10 | Testing | pytest, and writing code that is testable |
| 11 | pandas I | Series, DataFrame, read CSV, select, filter, sort |
| 12 | pandas II | `groupby`, `merge`, `pivot`, reshape — mapped onto their SQL equivalents |
| 13 | pandas III | Cleaning messy real data, missing values, dtypes, validation |
| 14 | Data engineering context | ETL/ELT, idempotency, scheduling, logging, config, Python + DuckDB, what to learn next |

Note where pandas sits: **eleventh**. pandas is a library, not a language. People
who learn it before they understand a list, a dict and a function end up copying
snippets they cannot debug. You will get there with foundations under you.

### Projects

| # | Project | Attempt after |
|---|---|---|
| 1 | Monthly P&L from the general ledger, in pure SQL | SQL 04 |
| 2 | AR ageing report with bucketing and conditional aggregation | SQL 07 |
| 3 | Python script that validates journal entries and writes an exceptions CSV | Python 08 |
| 4 | End-to-end pipeline: raw CSVs → clean → DuckDB → budget vs actual, with logging and tests | Python 14 |

---

## Suggested 20-week schedule

Assumes **5–7 hours a week**. The two tracks interleave deliberately: SQL is
easier to start with and gives quick wins, Python is slower to pay off, and
alternating stops either from going stale. If you fall behind, drop the stretch
exercises before you drop a topic.

| Week | SQL | Python | Also |
|---|---|---|---|
| 1 | 00 Orientation, 01 SELECT | 00 Orientation | Work through `SETUP.md`, build the database |
| 2 | 02 WHERE | 01 Variables and types | |
| 3 | 03 Aggregation | 02 Collections | |
| 4 | 04 JOINs (take two weeks) | 03 Conditionals | |
| 5 | 04 JOINs continued | 04 Loops | **Project 1: Monthly P&L** |
| 6 | 05 Subqueries and CTEs | 05 Functions | |
| 7 | 06 Window functions (three weeks) | 06 Errors | |
| 8 | 06 Window functions | 07 Files and formats | |
| 9 | 06 Window functions | 08 Modules and projects | |
| 10 | 07 Conditional logic | — consolidate — | **Project 2: AR ageing**, **Project 3: Journal validator** |
| 11 | 08 Dates and times | 09 Dates | The two date topics side by side is deliberate |
| 12 | 09 Strings and casting | 10 Testing with pytest | |
| 13 | 10 Set operations | 11 pandas I | |
| 14 | 11 DDL and DML | 11 pandas I continued | |
| 15 | 12 Structure and performance | 12 pandas II | |
| 16 | 13 Data modelling | 12 pandas II continued | Compare every pandas verb to its SQL twin |
| 17 | — consolidate — | 13 pandas III | Re-do three early SQL exercise sets from memory |
| 18 | — | 13 pandas III continued | |
| 19 | — | 14 Data engineering context | |
| 20 | — | — | **Project 4: End-to-end pipeline** |

Two things about this schedule. First, weeks 7–9 look slow because window
functions genuinely take that long to click. Second, week 17 has you redoing old
work on purpose — recall is the point of practice, and you will be unpleasantly
surprised at what has faded.

---

## Getting started

1. Read **[SETUP.md](SETUP.md)** and follow it end to end. It installs Python,
   VS Code and git, and finishes with you running a script that prints a trial
   balance. Budget an hour.
2. Build the database:
   ```bash
   pip install -r requirements.txt
   python data/build_db.py
   ```
3. Open **[data/README.md](data/README.md)** and skim the data dictionary. You
   will be back here constantly — it is the chart of accounts for the whole
   course.
4. Start at **[sql/00-orientation](sql/00-orientation/)**.
5. Keep **[progress/CHECKLIST.md](progress/CHECKLIST.md)** open and tick as you
   go.

## A note on the data

The dataset is fictional, covers roughly three years for a mid-sized company,
and is **deliberately imperfect**. There are duplicate rows, nulls where there
should not be, inconsistent casing, trailing whitespace, three different date
formats, and a handful of journals that do not balance.

This is not sloppiness. It is the first thing that will surprise you about real
data work: the data is always like this, and the job is largely to notice.
`data/README.md` documents every known defect — but do not read the defect list
as a to-do. Some exercises want you to find them yourself.
