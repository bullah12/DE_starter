"""Run every model solution and report its shape.

    python tools/check_solutions.py            # all SQL topics
    python tools/check_solutions.py sql/06-window-functions

Used while building and maintaining the course: a solution that returns zero
rows is usually a badly worded question rather than a broken query, and this
is the fastest way to spot one.
"""

from __future__ import annotations

import sys
from pathlib import Path

import duckdb

ROOT = Path(__file__).parent.parent
DB = ROOT / "data" / "finance.duckdb"


def main(argv: list[str]) -> int:
    targets = [ROOT / a for a in argv] or sorted(
        p for p in (ROOT / "sql").iterdir() if p.is_dir())
    con = duckdb.connect(str(DB), read_only=True)
    problems = 0
    for topic in targets:
        files = sorted((topic / "solutions").glob("q*.sql"))
        if not files:
            continue
        print(f"\n{topic.relative_to(ROOT)}")
        for f in files:
            try:
                df = con.sql(f.read_text(encoding="utf-8")).df()
            except Exception as exc:  # noqa: BLE001
                print(f"  {f.stem}  ERROR  {str(exc).splitlines()[0]}")
                problems += 1
                continue
            flag = "  <-- empty" if len(df) == 0 else ""
            if flag:
                problems += 1
            print(f"  {f.stem}  {len(df):>6} rows x {df.shape[1]} cols{flag}")
    con.close()
    print(f"\n{problems} problem(s)")
    return 1 if problems else 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
