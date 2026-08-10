"""Build data/finance.duckdb from the CSVs in data/raw/.

Run it from the project root:

    python data/build_db.py

It drops and recreates every table from scratch, so it is safe to run as often
as you like. If you ever mangle the database with a bad UPDATE or DELETE — and
you will, that is what topic sql/11 is for — delete data/finance.duckdb, run
this again, and you are back to a clean slate.

Rebuilding from source and always landing in the same state has a name in data
engineering: **idempotency**. You will meet it properly in python/14.

Column types are declared explicitly below rather than left to DuckDB's
guesswork. Two reasons: the exercises need a schema that does not shift under
you, and some columns are deliberately dirty. `invoices.invoice_date` and the
two date columns on `employees` are loaded as text because they contain three
different date formats and genuinely are not dates yet. Cleaning them is the
job, not a bug in this script.
"""

from __future__ import annotations

import sys
from pathlib import Path

try:
    import duckdb
except ModuleNotFoundError:
    sys.exit(
        "duckdb is not installed.\n"
        "Activate your virtual environment, then run:\n"
        "    pip install -r requirements.txt"
    )

HERE = Path(__file__).parent
RAW = HERE / "raw"
DB_PATH = HERE / "finance.duckdb"

# table name -> {column: DuckDB type}, in file order
SCHEMA: dict[str, dict[str, str]] = {
    "chart_of_accounts": {
        "account_code": "INTEGER",
        "account_name": "VARCHAR",
        "account_type": "VARCHAR",
        "report_section": "VARCHAR",
        "normal_balance": "VARCHAR",
        "is_active": "VARCHAR",
    },
    "cost_centres": {
        "cost_centre_code": "VARCHAR",
        "cost_centre_name": "VARCHAR",
        "region": "VARCHAR",
        "cost_centre_type": "VARCHAR",
    },
    "employees": {
        "employee_id": "INTEGER",
        "first_name": "VARCHAR",
        "last_name": "VARCHAR",
        "email": "VARCHAR",
        "job_title": "VARCHAR",
        "cost_centre_code": "VARCHAR",
        "hire_date": "VARCHAR",          # mixed formats on purpose
        "termination_date": "VARCHAR",   # mixed formats on purpose
        "annual_salary_gbp": "DECIMAL(15,2)",
    },
    "customers": {
        "customer_id": "VARCHAR",
        "customer_name": "VARCHAR",
        "country": "VARCHAR",
        "currency": "VARCHAR",
        "payment_terms_days": "INTEGER",
        "credit_limit_gbp": "DECIMAL(15,2)",
        "created_date": "DATE",
        "cost_centre_code": "VARCHAR",
        "is_active": "VARCHAR",
    },
    "suppliers": {
        "supplier_id": "VARCHAR",
        "supplier_name": "VARCHAR",
        "country": "VARCHAR",
        "currency": "VARCHAR",
        "payment_terms_days": "INTEGER",
        "created_date": "DATE",
        "is_active": "VARCHAR",
    },
    "fx_rates": {
        "rate_date": "DATE",
        "from_currency": "VARCHAR",
        "to_currency": "VARCHAR",
        "rate": "DECIMAL(12,6)",
    },
    "journal_entries": {
        "journal_id": "VARCHAR",
        "journal_date": "DATE",
        "posted_date": "DATE",
        "period": "VARCHAR",
        "fiscal_year": "VARCHAR",
        "fiscal_period": "INTEGER",
        "source": "VARCHAR",
        "description": "VARCHAR",
        "prepared_by": "INTEGER",
        "approved_by": "INTEGER",
        "status": "VARCHAR",
    },
    "general_ledger": {
        "gl_id": "INTEGER",
        "journal_id": "VARCHAR",
        "line_number": "INTEGER",
        "account_code": "INTEGER",
        "cost_centre_code": "VARCHAR",
        "entry_date": "DATE",
        "line_description": "VARCHAR",
        "debit": "DECIMAL(15,2)",
        "credit": "DECIMAL(15,2)",
    },
    "invoices": {
        "invoice_id": "VARCHAR",
        "invoice_type": "VARCHAR",
        "customer_id": "VARCHAR",
        "supplier_id": "VARCHAR",
        "invoice_date": "VARCHAR",       # mixed formats on purpose
        "due_date": "DATE",
        "currency": "VARCHAR",
        "net_amount": "DECIMAL(15,2)",
        "tax_amount": "DECIMAL(15,2)",
        "gross_amount": "DECIMAL(15,2)",
        "gross_amount_gbp": "DECIMAL(15,2)",
        "cost_centre_code": "VARCHAR",
        "status": "VARCHAR",
    },
    "payments": {
        "payment_id": "VARCHAR",
        "invoice_id": "VARCHAR",
        "direction": "VARCHAR",
        "payment_date": "DATE",
        "currency": "VARCHAR",
        "amount": "DECIMAL(15,2)",
        "amount_gbp": "DECIMAL(15,2)",
        "method": "VARCHAR",
        "bank_reference": "VARCHAR",
    },
    "budgets": {
        "budget_id": "INTEGER",
        "fiscal_year": "VARCHAR",
        "fiscal_period": "INTEGER",
        "account_code": "INTEGER",
        "cost_centre_code": "VARCHAR",
        "budget_amount_gbp": "DECIMAL(15,2)",
        "status": "VARCHAR",
        "version": "VARCHAR",
    },
}


def columns_clause(columns: dict[str, str]) -> str:
    inner = ", ".join(f"'{name}': '{dtype}'" for name, dtype in columns.items())
    return "{" + inner + "}"


def build(db_path: Path = DB_PATH) -> None:
    missing = [t for t in SCHEMA if not (RAW / f"{t}.csv").exists()]
    if missing:
        sys.exit(
            "These CSV files are missing from data/raw:\n  "
            + "\n  ".join(f"{t}.csv" for t in missing)
            + "\nThey should be committed to the repository. Try `git status`."
        )

    if db_path.exists():
        db_path.unlink()
    wal = db_path.with_suffix(db_path.suffix + ".wal")
    if wal.exists():
        wal.unlink()

    con = duckdb.connect(str(db_path))
    print(f"Building {db_path}\n")

    for table, columns in SCHEMA.items():
        csv_path = (RAW / f"{table}.csv").as_posix()
        con.execute(f"""
            CREATE TABLE {table} AS
            SELECT * FROM read_csv(
                '{csv_path}',
                header = true,
                columns = {columns_clause(columns)}
            )
        """)

    print(f"{'table':<22}{'rows':>9}{'columns':>10}")
    print("-" * 41)
    total = 0
    for table in SCHEMA:
        rows = con.execute(f"SELECT count(*) FROM {table}").fetchone()[0]
        total += rows
        print(f"{table:<22}{rows:>9,}{len(SCHEMA[table]):>10}")
    print("-" * 41)
    print(f"{'total':<22}{total:>9,}\n")

    health(con)
    con.close()
    print(f"\nDone. Connect to it with:\n"
          f"    duckdb.connect('data/finance.duckdb', read_only=True)")


def health(con) -> None:
    """Print a few facts about the data you are about to work with.

    None of these are errors in the build. They are the known defects in the
    source extract, and they are documented in data/README.md. Do not fix them
    here — several exercises depend on them being present.
    """
    checks = [
        ("Total debits (GBP)",
         "SELECT sum(debit) FROM general_ledger"),
        ("Total credits (GBP)",
         "SELECT sum(credit) FROM general_ledger"),
        ("Journals that do not balance",
         """SELECT count(*) FROM (
                SELECT journal_id FROM general_ledger
                GROUP BY journal_id HAVING sum(debit) <> sum(credit))"""),
        ("Journals still in DRAFT",
         "SELECT count(*) FROM journal_entries WHERE status = 'DRAFT'"),
        ("GL lines with no cost centre",
         "SELECT count(*) FROM general_ledger WHERE cost_centre_code IS NULL"),
        ("Customers with no country",
         "SELECT count(*) FROM customers WHERE country IS NULL"),
        ("Duplicate payment_id values",
         """SELECT count(*) FROM (
                SELECT payment_id FROM payments
                GROUP BY payment_id HAVING count(*) > 1)"""),
        ("Invoices whose customer_id is unknown",
         """SELECT count(*) FROM invoices i
            WHERE i.invoice_type = 'SALES'
              AND i.customer_id NOT IN (SELECT customer_id FROM customers)"""),
        ("Earliest / latest GL date",
         "SELECT min(entry_date) || '  to  ' || max(entry_date) FROM general_ledger"),
    ]
    print("Known state of the data (all of this is expected — see data/README.md)")
    print("-" * 62)
    for label, sql in checks:
        value = con.execute(sql).fetchone()[0]
        if isinstance(value, (int, float)):
            print(f"{label:<44}{value:>18,.2f}")
        else:
            print(f"{label:<44}{str(value):>18}")


if __name__ == "__main__":
    build()
