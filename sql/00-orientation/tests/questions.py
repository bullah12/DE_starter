"""Questions for sql/00-orientation."""

TITLE = "SQL 00 — Orientation"

INTRO = """
You have four tools so far: `SELECT`, `FROM`, `ORDER BY`, `LIMIT`, plus `AS`
for renaming a column and `count(*)` for counting rows. That is enough to find
your way around a database you have never seen before, which is exactly what
these questions are about.

Keep `data/README.md` open — it lists every table and column.
"""

QUESTIONS = [
    dict(
        id="q01", tier="warmup", ordered=True,
        title="The cost centre list",
        question="Show every column of every cost centre, in code order.",
        shape="Four columns, eight rows, ordered by cost_centre_code.",
        hint="This is the shortest query in the course. Two lines and a sort.",
    ),
    dict(
        id="q02", tier="warmup", ordered=True,
        title="The first fifteen accounts",
        question="""
        Show the code and name of the first fifteen accounts on the chart, in
        code order.
        """,
        shape="Two columns, fifteen rows.",
        hint="LIMIT controls how many rows come back. It runs after ORDER BY, "
             "so you get the first fifteen *sorted* rows, not fifteen random "
             "ones.",
    ),
    dict(
        id="q03", tier="warmup", ordered=False,
        title="How many invoices?",
        question="Count the rows in the invoices table. Call the column "
                 "invoice_rows.",
        shape="One column, one row.",
        hint="count(*) counts rows. AS renames the output column.",
    ),
    dict(
        id="q04", tier="warmup", ordered=False,
        title="How many payments?",
        question="Count the rows in the payments table. Call the column "
                 "payment_rows.",
        shape="One column, one row.",
        hint="Same shape as the last one. Repetition is the point.",
    ),
    dict(
        id="q05", tier="warmup", ordered=True,
        title="The staff list",
        question="""
        List the first twelve employees alphabetically by surname, then first
        name, showing surname, first name and job title.
        """,
        shape="Three columns, twelve rows.",
        hint="ORDER BY takes more than one column, separated by commas. The "
             "second only breaks ties in the first.",
    ),
    dict(
        id="q06", tier="warmup", ordered=True,
        title="Our biggest credit limits",
        question="""
        The ten customers with the largest credit limits: id, name and limit.
        """,
        shape="Three columns, ten rows, largest limit first.",
        hint="DESC after a column in ORDER BY sorts it the other way. Add "
             "customer_id as a tie-break so the answer is stable.",
    ),
    dict(
        id="q07", tier="warmup", ordered=True,
        title="Is invoice_id a key?",
        question="""
        Check whether invoice_id uniquely identifies a row in invoices. Show
        any value that appears more than once, and how often.
        """,
        shape="Two columns — invoice_id and times_it_appears. If the column is "
              "a genuine key, you will get no rows at all.",
        hint="Copy the recipe from examples/04_keys.sql and change the table "
             "and column. No rows back is the good outcome.",
    ),
    dict(
        id="q08", tier="warmup", ordered=True,
        title="Is payment_id a key?",
        question="""
        Run the same check on payment_id in the payments table.
        """,
        shape="Two columns — payment_id and times_it_appears — one row per "
              "duplicated id, id order.",
        hint="Same recipe. This one does return rows, and they matter: a "
             "duplicated payment is cash counted twice.",
    ),

    dict(
        id="q09", tier="core", ordered=True,
        title="The twenty largest debits",
        question="""
        The twenty largest single debit postings in the ledger, showing the
        ledger line id, account code, entry date and debit amount.
        """,
        shape="Four columns, twenty rows, largest debit first.",
        hint="Tie-break on gl_id so two identical amounts always come back in "
             "the same order.",
    ),
    dict(
        id="q10", tier="core", ordered=False,
        title="How many customers have a country?",
        question="""
        Count the customer rows, and separately count how many of them have a
        country recorded. Call the columns customer_rows and with_country.
        """,
        shape="Two columns, one row.",
        hint="count(*) counts rows; count(column) counts rows where that "
             "column is not NULL. The difference between the two numbers is "
             "the number of missing values.",
    ),
    dict(
        id="q11", tier="core", ordered=False,
        title="How many ledger lines have a cost centre?",
        question="""
        Same idea on the general ledger: total lines, and lines that have a
        cost centre. Call the columns ledger_lines and with_cost_centre.
        """,
        shape="Two columns, one row.",
        hint="If you can do q10 you can do this one. The gap is worth "
             "remembering — those lines will vanish from any report grouped by "
             "cost centre.",
    ),
    dict(
        id="q12", tier="core", ordered=True,
        title="Is a ledger line identified by journal and line number?",
        question="""
        Check whether the combination of journal_id and line_number uniquely
        identifies a general ledger row.
        """,
        shape="Three columns — journal_id, line_number, times_it_appears. No "
              "rows means the combination is unique.",
        hint="A key can be made of more than one column. Group by both.",
    ),
    dict(
        id="q13", tier="core", ordered=True,
        title="The oldest journals",
        question="""
        The fifteen earliest journals by journal date, showing id, date,
        source and description.
        """,
        shape="Four columns, fifteen rows, earliest first.",
        hint="Tie-break on journal_id — several journals share a date.",
    ),
    dict(
        id="q14", tier="core", ordered=True,
        title="The ten highest salaries",
        question="""
        The ten highest paid employees: surname, first name, job title and
        salary.
        """,
        shape="Four columns, ten rows, highest salary first.",
        hint="Tie-break on employee_id even though you are not showing it — "
             "you can sort by a column you do not select.",
    ),
    dict(
        id="q15", tier="core", ordered=True,
        title="The largest budget lines",
        question="""
        The ten largest individual budget lines, showing fiscal year, period,
        account code, cost centre and amount.
        """,
        shape="Five columns, ten rows, largest amount first.",
        hint="Tie-break on budget_id.",
    ),
    dict(
        id="q16", tier="core", ordered=True,
        title="The first FX rates on file",
        question="""
        The first ten exchange rate rows by date, then currency, showing all
        four columns.
        """,
        shape="Four columns, ten rows.",
        hint="Two sort columns. Note which dates are missing entirely — "
             "weekends have no published rate.",
    ),

    dict(
        id="q17", tier="stretch", ordered=True,
        title="How many accounts of each type?",
        question="""
        Count the accounts on the chart by account_type.
        """,
        shape="Two columns — account_type and account_count — one row per "
              "type, most accounts first.",
        hint="Take the key-check recipe and remove the part that filters out "
             "the groups of one.",
    ),
    dict(
        id="q18", tier="stretch", ordered=True,
        title="Find the exactly duplicated supplier",
        question="""
        Somewhere in suppliers there is a row that has been loaded twice, in
        full. Prove it: return the duplicated row's values and the number of
        times it appears.
        """,
        shape="Eight columns — every supplier column, plus times_it_appears — "
              "one row.",
        hint="Group by every column, not just the id. Two rows are exact "
             "duplicates only if all their values match.",
    ),
    dict(
        id="q19", tier="stretch", ordered=True,
        title="The biggest journals",
        question="""
        Which journals have more than twenty ledger lines, and how many lines
        do they have?
        """,
        shape="Two columns — journal_id and line_count — most lines first.",
        hint="Same recipe again, with a different threshold. Have a guess at "
             "what kind of journal these will turn out to be before you run "
             "it.",
    ),
    dict(
        id="q20", tier="stretch", ordered=True,
        title="What sources post to this ledger?",
        question="""
        Work out what distinct values appear in journal_entries.source, and
        how many journals each accounts for.
        """,
        shape="Two columns — source and journal_count — one row per source, "
              "most journals first.",
        hint="Grouping by a column is also how you discover what is in it. "
             "This is the query to run on any unfamiliar coded column.",
    ),
]
