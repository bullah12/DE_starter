# Progress checklist

Tick as you go. In VS Code, put your cursor between the brackets and type `x`:
`- [ ]` becomes `- [x]`.

Four ticks per topic:

- **Lesson** — read the `README.md` through
- **Examples** — actually ran every file in `examples/`
- **Warm-up / Core / Stretch** — the three exercise tiers
- **Tests green** — `pytest <topic-directory>` passes

Honest ticking is the whole point. A ticked box you did not earn only fools you.

---

## Setup

- [ ] Python 3.11+ installed, `python --version` works
- [ ] VS Code installed, Python extension added
- [ ] git installed and configured
- [ ] Virtual environment created and activated
- [ ] `pip install -r requirements.txt` succeeded
- [ ] `python data/build_db.py` built `data/finance.duckdb`
- [ ] Ran `first_script.py` and saw a table print
- [ ] `pytest --version` works
- [ ] Skimmed `data/README.md`

---

## SQL track

### sql/00-orientation — databases, tables, keys, your first query
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### sql/01-select-and-filter — SELECT, aliases, expressions, ORDER BY, LIMIT
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### sql/02-where-and-filtering — WHERE, IN, BETWEEN, LIKE, NULL
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### sql/03-aggregation — COUNT/SUM/AVG/MIN/MAX, GROUP BY, HAVING
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### sql/04-joins — INNER/LEFT/RIGHT/FULL/CROSS, self-joins, debugging duplicates
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### sql/05-subqueries-and-ctes — subqueries, WITH, chained and nested CTEs
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### sql/06-window-functions — ROW_NUMBER, RANK, LAG/LEAD, running totals, moving averages
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### sql/07-case-and-conditional-logic — CASE, COALESCE, NULLIF, conditional aggregation, pivoting
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### sql/08-dates-and-times — truncation, intervals, period-over-period, fiscal calendars
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### sql/09-strings-and-casting — string functions, casting, coercion, cleaning
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### sql/10-set-operations — UNION, UNION ALL, INTERSECT, EXCEPT
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### sql/11-ddl-and-dml — CREATE, INSERT, UPDATE, DELETE, constraints, transactions
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### sql/12-query-structure-and-performance — execution order, EXPLAIN, indexes
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### sql/13-data-modelling — normalisation, star schema, fact vs dimension
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

---

## Python track

### python/00-orientation — interpreter, scripts vs notebooks, reading errors
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### python/01-variables-and-types — numbers, strings, f-strings, conversion
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### python/02-collections — lists, tuples, dicts, sets
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### python/03-conditionals — if/elif/else, boolean logic
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### python/04-loops-and-comprehensions — for, while, enumerate, zip, comprehensions
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### python/05-functions — arguments, defaults, returns, scope, docstrings
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### python/06-errors-and-exceptions — tracebacks, try/except, raise, assert
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### python/07-files-and-formats — CSV, JSON, text, pathlib
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### python/08-modules-and-projects — imports, venvs, project layout
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### python/09-dates-and-times — datetime, timedelta, parsing, timezones
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### python/10-testing-with-pytest — pytest, and testable code
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### python/11-pandas-i-dataframes — Series, DataFrame, read CSV, select, filter, sort
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### python/12-pandas-ii-groupby-merge-pivot — the SQL verbs, in pandas
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### python/13-pandas-iii-cleaning — messy data, missing values, dtypes, validation
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

### python/14-data-engineering-context — ETL/ELT, idempotency, logging, config, what next
- [ ] Lesson  - [ ] Examples  - [ ] Warm-up  - [ ] Core  - [ ] Stretch  - [ ] Tests green

---

## Projects

### projects/01-monthly-pl-sql — after SQL 04
- [ ] Read the brief  - [ ] Attempted  - [ ] Acceptance criteria met  - [ ] Compared to reference solution

### projects/02-ar-ageing-report — after SQL 07
- [ ] Read the brief  - [ ] Attempted  - [ ] Acceptance criteria met  - [ ] Compared to reference solution

### projects/03-journal-validator — after Python 08
- [ ] Read the brief  - [ ] Attempted  - [ ] Acceptance criteria met  - [ ] Compared to reference solution

### projects/04-budget-vs-actual-pipeline — after Python 14
- [ ] Read the brief  - [ ] Attempted  - [ ] Acceptance criteria met  - [ ] Compared to reference solution

---

## Finishing line

- [ ] `pytest` passes across the whole repository
- [ ] All four projects complete
- [ ] Re-did three early SQL exercise sets from memory (week 17)
- [ ] Read `python/14-data-engineering-context` and picked what to learn next
