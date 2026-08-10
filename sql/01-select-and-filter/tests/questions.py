"""Questions for sql/01-select-and-filter."""

TITLE = "SQL 01 — SELECT, aliases, expressions, ORDER BY, LIMIT"

INTRO = """
No `WHERE` yet — that is the next topic. Everything here is done by choosing
columns, computing them, sorting and limiting. It is more than it sounds: "top
ten by value" and "what values are in this column" are two of the most common
requests you will ever get.

Alias every computed column, and give every `ORDER BY` a unique tie-break.
"""

QUESTIONS = [
    dict(
        id="q01", tier="warmup", ordered=True,
        title="A readable chart of accounts",
        question="""
        The first twelve accounts by code, with the columns named code,
        account and type.
        """,
        shape="Three columns named code, account, type. Twelve rows.",
        hint="AS renames a column. The underlying data does not change.",
    ),
    dict(
        id="q02", tier="warmup", ordered=True,
        title="Signed ledger movements",
        question="""
        The first ten ledger lines by gl_id, showing the line id, account
        code, debit, credit and the signed movement (debit less credit).
        """,
        shape="Five columns, the last called movement. Ten rows.",
        hint="The movement column is an expression: debit - credit.",
    ),
    dict(
        id="q03", tier="warmup", ordered=True,
        title="Does net plus tax equal gross?",
        question="""
        The first eight invoices by invoice_id, showing net, tax, gross, and
        your own recalculation of net plus tax.
        """,
        shape="Five columns — invoice_id, net_amount, tax_amount, "
              "gross_amount, recalculated — eight rows.",
        hint="This is a control. If the two gross figures ever disagree you "
             "have found a data problem worth reporting.",
    ),
    dict(
        id="q04", tier="warmup", ordered=True,
        title="What currencies do we invoice in?",
        question="List the distinct currencies appearing on invoices.",
        shape="One column, one row per currency, alphabetical.",
        hint="DISTINCT removes repeats.",
    ),
    dict(
        id="q05", tier="warmup", ordered=True,
        title="What payment methods are in use?",
        question="List the distinct payment methods in the payments table.",
        shape="One column, one row per method, alphabetical.",
        hint="More values than you expect — the casing is inconsistent. That "
             "is the finding, not a mistake in your query.",
    ),
    dict(
        id="q06", tier="warmup", ordered=True,
        title="Best paid staff, formatted",
        question="""
        The ten highest paid employees, showing a single name column in the
        form 'Surname, Firstname', their job title and their salary.
        """,
        shape="Three columns — employee, job_title, annual_salary_gbp — ten "
              "rows, highest first.",
        hint="|| joins text together. Tie-break on employee_id.",
    ),
    dict(
        id="q07", tier="warmup", ordered=True,
        title="Budget lines in thousands",
        question="""
        The ten largest budget lines, showing fiscal year, period, account
        code and the amount expressed in thousands to one decimal place.
        """,
        shape="Five columns — fiscal_year, fiscal_period, account_code, "
              "budget_amount_gbp, amount_k — ten rows, largest first.",
        hint="Divide by 1000 and wrap the whole thing in round(..., 1).",
    ),
    dict(
        id="q08", tier="warmup", ordered=True,
        title="Exchange rates per thousand units",
        question="""
        The first ten exchange rate rows by date then currency, showing the
        date, currency, the rate, and what 1,000 units of that currency is
        worth in GBP.
        """,
        shape="Four columns — rate_date, from_currency, rate, gbp_per_1000 — "
              "ten rows.",
        hint="Multiply the rate by 1000 and round to two decimal places.",
    ),

    dict(
        id="q09", tier="core", ordered=True,
        title="The biggest VAT elements",
        question="""
        The fifteen invoices carrying the most VAT, worked out from gross less
        net rather than trusting the tax column.
        """,
        shape="Four columns — invoice_id, net_amount, gross_amount, "
              "tax_element — fifteen rows, largest first.",
        hint="You can ORDER BY an alias you defined in the same SELECT.",
    ),
    dict(
        id="q10", tier="core", ordered=True,
        title="The largest postings, either way round",
        question="""
        The ten ledger lines with the largest movement in absolute terms —
        that is, ignoring whether they are debits or credits.
        """,
        shape="Five columns — gl_id, journal_id, account_code, movement, "
              "abs_movement — ten rows, largest absolute movement first.",
        hint="abs() strips the sign. Sorting on the signed movement would give "
             "you the ten biggest debits and no credits at all.",
    ),
    dict(
        id="q11", tier="core", ordered=True,
        title="Credit limits in euros",
        question="""
        The ten largest credit limits, also expressed in euros at a fixed
        planning rate of 1.18 euros to the pound, rounded to the nearest euro.
        """,
        shape="Four columns — customer_id, customer_name, credit_limit_gbp, "
              "credit_limit_eur — ten rows, largest first.",
        hint="round(x, 0) gives whole units. Tie-break on customer_id: several "
             "customers share a limit.",
    ),
    dict(
        id="q12", tier="core", ordered=True,
        title="Monthly salary cost",
        question="""
        The twelve highest paid employees showing their monthly salary to the
        penny, alongside the annual figure.
        """,
        shape="Four columns — employee_id, employee, annual_salary_gbp, "
              "monthly_gbp — twelve rows, highest first.",
        hint="Dividing produces a long decimal. round(..., 2) fixes it.",
    ),
    dict(
        id="q13", tier="core", ordered=True,
        title="Which regions run which kinds of cost centre?",
        question="""
        The distinct combinations of region and cost centre type.
        """,
        shape="Two columns — region, cost_centre_type — one row per "
              "combination that exists, region order then type.",
        hint="DISTINCT applies to the whole row you selected, not to one "
             "column.",
    ),
    dict(
        id="q14", tier="core", ordered=True,
        title="Page three of the invoice list",
        question="""
        Invoices are being reviewed twenty at a time in invoice_id order. Show
        the third page — that is, invoices 41 to 60.
        """,
        shape="Three columns — invoice_id, due_date, gross_amount — twenty "
              "rows.",
        hint="OFFSET skips rows before LIMIT takes them. Work out the offset "
             "for page three carefully; off-by-twenty is easy here.",
    ),
    dict(
        id="q15", tier="core", ordered=True,
        title="Implied exchange rates on payments",
        question="""
        For the ten largest payments by GBP value, show the payment currency,
        the amount, the GBP amount, and the exchange rate that was implied by
        the pair.
        """,
        shape="Five columns — payment_id, currency, amount, amount_gbp, "
              "implied_rate — ten rows, largest GBP amount first.",
        hint="The implied rate is the GBP amount divided by the amount. Round "
             "it to six decimal places, like the fx_rates table does.",
    ),
    dict(
        id="q16", tier="core", ordered=True,
        title="The report sections in use",
        question="""
        List the distinct report sections on the chart of accounts. This is
        the skeleton of the statutory accounts.
        """,
        shape="One column, one row per section, alphabetical.",
        hint="One line of SQL, and a genuinely useful thing to know before you "
             "build a P&L.",
    ),
    dict(
        id="q17", tier="core", ordered=True,
        title="Annualised budget lines",
        question="""
        The ten largest budget lines, showing the monthly amount and what it
        would be if that run rate held for a full year.
        """,
        shape="Five columns — budget_id, fiscal_year, account_code, "
              "budget_amount_gbp, annualised_gbp — ten rows, largest first.",
        hint="Multiply by 12. Whether that is a fair annualisation is a "
             "different question — say so if you hand it over.",
    ),

    dict(
        id="q18", tier="stretch", ordered=False,
        title="A one-row control summary of the invoice table",
        question="""
        Produce a single row that shows: how many invoice rows there are, how
        many have a customer, and how many have a supplier. Use it to prove
        that every invoice is either a sale or a purchase and never both.
        """,
        shape="Three columns — invoice_rows, with_customer, with_supplier — "
              "one row.",
        hint="count(*) counts rows; count(column) counts non-NULL values. Do "
             "the two smaller numbers add up to the big one?",
    ),
    dict(
        id="q19", tier="stretch", ordered=True,
        title="Currency and country pairs",
        question="""
        The distinct combinations of country and currency on the customer
        master, so you can see which countries we invoice in which currency.
        """,
        shape="Two columns — country, currency — one row per combination, "
              "country order then currency. Customers with no country still "
              "form a group.",
        hint="Think about where the NULL country sorts, and whether that is "
             "what you want on a report.",
    ),
    dict(
        id="q20", tier="stretch", ordered=True,
        title="A staff directory line",
        question="""
        Build a single display column for the ten highest paid staff in the
        form 'Firstname Surname (Job Title)', alongside their monthly salary
        to the penny.
        """,
        shape="Two columns — directory_line, monthly_gbp — ten rows, highest "
              "paid first.",
        hint="Several || in a row. Getting the brackets and spaces right is "
             "fiddly and entirely the point.",
    ),
    dict(
        id="q21", tier="stretch", ordered=True,
        title="Inverse exchange rates",
        question="""
        For the first ten fx rate rows by date then currency, show the rate as
        published (foreign to GBP) and the inverse (GBP to foreign), to four
        decimal places.
        """,
        shape="Four columns — rate_date, from_currency, rate, inverse_rate — "
              "ten rows.",
        hint="1 divided by the rate. Watch what happens to the precision if "
             "you round before dividing rather than after.",
    ),
    dict(
        id="q22", tier="stretch", ordered=True,
        title="The other end of the distribution",
        question="""
        Find the ten smallest values of gross_amount_gbp on the invoice table.
        What does the smallest one turn out to be, and why is it there?
        """,
        shape="Four columns — invoice_id, invoice_type, status, "
              "gross_amount_gbp — ten rows, smallest first.",
        hint="Sorting ascending finds the other extreme. The first row is not "
             "an invoice at all in the normal sense — check its status.",
    ),
]
