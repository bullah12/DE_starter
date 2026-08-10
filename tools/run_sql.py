"""Run a .sql file against data/finance.duckdb and print the result.

    python tools/run_sql.py sql/04-joins/examples/01_inner_join.sql

Handy for running the worked examples, and for trying your own answers before
you run the tests. The connection is read-only, so nothing you run this way can
damage the database.

Pass --write if you are working through sql/11 (DDL and DML) and genuinely need
to change the data. If you break something, rebuild: python data/build_db.py
"""

from __future__ import annotations

import sys
from pathlib import Path

import duckdb

ROOT = Path(__file__).parent.parent
DB = ROOT / "data" / "finance.duckdb"


def main(argv: list[str]) -> int:
    args = [a for a in argv if not a.startswith("--")]
    write = "--write" in argv
    if not args:
        print(__doc__)
        return 1

    path = Path(args[0])
    if not path.exists():
        print(f"No such file: {path}")
        return 1
    if not DB.exists():
        print(f"{DB} does not exist. Build it first:\n    python data/build_db.py")
        return 1

    sql = path.read_text(encoding="utf-8")
    con = duckdb.connect(str(DB), read_only=not write)
    try:
        result = con.sql(sql)
        if result is None:
            print("Statement ran. It returned no rows.")
        else:
            print(result)
    except Exception as exc:  # noqa: BLE001
        print(f"DuckDB could not run {path}:\n\n{exc}")
        return 1
    finally:
        con.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
