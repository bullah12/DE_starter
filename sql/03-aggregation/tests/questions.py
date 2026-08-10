"""Questions for sql/03-aggregation."""

TITLE = "SQL 03 — Aggregation"

INTRO = """
Every question here is a pivot table you have built a hundred times. The work
is in saying it precisely: what are the row labels (GROUP BY), what are the
values (the aggregates), which rows go in (WHERE) and which groups come out
(HAVING).

Round money to two decimal places in your output. Where a question asks for a
signed balance, state which way round you have defined it.
"""

QUESTIONS = [
    dict(id="q01", tier="warmup", ordered=False,
         title="Size up the invoice table",
         question="One row showing the number of invoices, the total gross in GBP, and the smallest and largest gross GBP values.",
         shape="Four columns — invoice_count, total_gbp, smallest_gbp, largest_gbp — one row.",
         hint="No GROUP BY: the whole table is one group."),
    dict(id="q02", tier="warmup", ordered=True,
         title="Invoices by type",
         question="Count the invoices and total their gross GBP value, split by invoice type.",
         shape="Three columns — invoice_type, invoice_count, total_gbp — type order.",
         hint="One grouping column."),
    dict(id="q03", tier="warmup", ordered=True,
         title="Ledger lines by account",
         question="For every account with ledger activity, the number of lines, total debits and total credits.",
         shape="Four columns — account_code, line_count, total_debit, total_credit — account code order.",
         hint="This is a trial balance without the balance column."),
    dict(id="q04", tier="warmup", ordered=True,
         title="Headcount and salary by cost centre code",
         question="Number of employees and total salary for each cost centre code on the employee record.",
         shape="Three columns — cost_centre_code, headcount, total_salary — code order, the missing cost centre last.",
         hint="NULL forms its own group. Where does it sort?"),
    dict(id="q05", tier="warmup", ordered=True,
         title="Payments by method",
         question="Count and total the payments by method, in GBP.",
         shape="Three columns — method, payment_count, total_gbp — most payments first.",
         hint="The casing problem is still there. Group on the raw column for "
              "now, and notice what it does to the answer."),
    dict(id="q06", tier="warmup", ordered=True,
         title="Payments by method, cleaned up",
         question="The same summary, but with the upper and lower case spellings of each method combined.",
         shape="Three columns — method, payment_count, total_gbp — most payments first.",
         hint="Group by upper(method) rather than method. Alias it back to "
              "something readable."),
    dict(id="q07", tier="warmup", ordered=True,
         title="Budget by fiscal year",
         question="Total budgeted amount for each fiscal year, and how many budget lines make it up.",
         shape="Three columns — fiscal_year, budget_lines, total_budget_gbp — year order.",
         hint="One grouping column, two aggregates."),
    dict(id="q08", tier="warmup", ordered=True,
         title="Big spending accounts",
         question="Accounts with more than £1,000,000 of debits across the whole ledger.",
         shape="Three columns — account_code, line_count, total_debit — largest debit first.",
         hint="A condition on a total is a condition on a group, so it goes in HAVING."),

    dict(id="q09", tier="core", ordered=True,
         title="Monthly revenue",
         question="""
         Revenue by calendar month across the whole ledger — income accounts
         only, using the account code range 4000 to 4999.
         """,
         shape="Three columns — month, line_count, revenue_gbp — month order. Month as the first day of the month.",
         hint="date_trunc('month', entry_date) collapses a date to the first "
              "of its month. Dates are topic 08 — this one function is worth "
              "borrowing early. Income is credit-normal."),
    dict(id="q10", tier="core", ordered=True,
         title="Cost centre spend, top ten",
         question="""
         The ten cost centres with the highest total expense (accounts 5000
         and above) in FY2024, that is April 2023 to March 2024.
         """,
         shape="Three columns — cost_centre_code, line_count, spend_gbp — largest first.",
         hint="Only eight cost centres exist, so ten is a trick: you will get "
              "however many there are. Decide what to do with the lines that "
              "have no cost centre."),
    dict(id="q11", tier="core", ordered=True,
         title="Customer invoice profile",
         question="""
         For every customer that has been invoiced, the number of sales
         invoices, the total, the average and the largest, all in GBP.
         """,
         shape="Five columns — customer_id, invoice_count, total_gbp, average_gbp, largest_gbp — largest total first.",
         hint="Four aggregates over the same group. Round the average."),
    dict(id="q12", tier="core", ordered=True,
         title="Journals per source per year",
         question="How many journals were raised from each source in each calendar year?",
         shape="Three columns — year, source, journal_count — year then source.",
         hint="year(journal_date) as a grouping column. You can group by an "
              "expression, not just a bare column."),
    dict(id="q13", tier="core", ordered=True,
         title="Accounts that only ever get credited",
         question="""
         Which accounts have credits but no debits at all across the whole
         ledger? These are the accumulating credit balances.
         """,
         shape="Three columns — account_code, line_count, total_credit — largest credit first.",
         hint="A group where sum(debit) = 0. That is a HAVING condition."),
    dict(id="q14", tier="core", ordered=True,
         title="Supplier concentration",
         question="""
         Suppliers accounting for more than £200,000 of purchase invoices,
         with the number of invoices and the average invoice value.
         """,
         shape="Four columns — supplier_id, invoice_count, total_gbp, average_gbp — largest total first.",
         hint="Group the invoices table by supplier_id; you do not need the "
              "supplier table for this. HAVING for the threshold."),
    dict(id="q15", tier="core", ordered=True,
         title="Does the ledger balance, year by year?",
         question="""
         Total debits and credits by calendar year, with the difference. In a
         double-entry ledger the difference must be zero. Find the years where
         it is not.
         """,
         shape="Five columns — year, line_count, total_debit, total_credit, difference — year order.",
         hint="year(entry_date) as the grouping column. The difference is an "
              "expression built from two aggregates, which is allowed."),
    dict(id="q16", tier="core", ordered=True,
         title="Invoice value bands by count",
         question="""
         How many sales invoices fall in each thousand-pound band of gross
         GBP value, up to the tenth band? Band 0 is under £1,000, band 1 is
         £1,000 to £1,999, and so on.
         """,
         shape="Three columns — band, invoice_count, total_gbp — band order, bands 0 to 10 only.",
         hint="Integer division by 1000 gives the band. floor(x / 1000) or "
              "x // 1000 both work."),
    dict(id="q17", tier="core", ordered=True,
         title="How long has each customer been trading with us?",
         question="""
         For every customer with sales invoices, the number of invoices, the
         earliest and latest due date, and the number of days between them.
         """,
         shape="Five columns — customer_id, invoice_count, first_due, last_due, days_span — longest span first then customer_id.",
         hint="min() and max() work on dates. Subtracting one date from "
              "another gives whole days, and you can subtract two aggregates."),
    dict(id="q18", tier="core", ordered=True,
         title="Quiet accounts",
         question="""
         Accounts with fewer than ten ledger lines in the whole three years.
         These are the ones worth asking about before you build a report
         around them.
         """,
         shape="Four columns — account_code, line_count, total_debit, total_credit — fewest lines first then account code.",
         hint="HAVING count(*) < 10."),

    dict(id="q19", tier="stretch", ordered=False,
         title="Prove the ledger does not balance, and size the hole",
         question="""
         One row: total debits, total credits, the difference, and how many
         distinct journals are involved in creating it.
         """,
         shape="Four columns — total_debit, total_credit, difference, broken_journals — one row.",
         hint="The first three are easy. The fourth needs a count of journals "
              "where the debits and credits disagree, which is a group-level "
              "test — think about how to count groups rather than rows. A "
              "subquery (topic 05) is the clean way; count(DISTINCT ...) with "
              "a FILTER will not get you there on its own."),
    dict(id="q20", tier="stretch", ordered=True,
         title="Revenue concentration",
         question="""
         How much of our sales value comes from the top customers? For each
         customer show their total sales and what percentage of all sales that
         represents, for the ten largest.
         """,
         shape="Three columns — customer_id, total_gbp, pct_of_total — largest first.",
         hint="The denominator is a total over the whole table while you are "
              "grouping by customer. A scalar subquery does it; a window "
              "function (topic 06) does it more elegantly. Either is a fair "
              "answer here."),
    dict(id="q21", tier="stretch", ordered=True,
         title="Average invoice by month and type",
         question="""
         The average invoice value in GBP by calendar month and invoice type,
         but only for month and type combinations with at least twenty
         invoices.
         """,
         shape="Five columns — month, invoice_type, invoice_count, average_gbp, total_gbp — month then type.",
         hint="Two grouping columns and a HAVING on the count. Use due_date "
              "for the month, since invoice_date is text in three formats."),
    dict(id="q22", tier="stretch", ordered=True,
         title="The cost of the missing cost centre",
         question="""
         For each account that has ledger lines with no cost centre, show how
         many lines and how much value are unattributable, and what percentage
         of that account's total value they represent.
         """,
         shape="Five columns — account_code, unattributed_lines, unattributed_gbp, account_total_gbp, pct_unattributed — largest unattributed value first.",
         hint="You need both a filtered total and an unfiltered total in the "
              "same row. count(*) FILTER (WHERE ...) and sum(...) FILTER "
              "(WHERE ...) do exactly that."),
    dict(id="q23", tier="stretch", ordered=True,
         title="Does the sales ledger agree with the nominal ledger?",
         question="""
         Compare, by calendar year, the total of sales invoices raised
         (invoices table) with the revenue posted to the ledger (accounts 4000
         to 4999). They should be close but not identical — explain the
         difference in a comment.
         """,
         shape="Four columns — year, invoiced_gbp, posted_gbp, difference — year order.",
         hint="Two independent aggregations that have to end up side by side. "
              "Two subqueries and a join, or a UNION and a regroup. Both are "
              "later topics — pick one, make it work, and note which parts you "
              "had to look up."),
]
