"""Shared test machinery for the whole course.

You do not need to read this file to use the course, but nothing here is
magic, and by python/10 you will understand all of it.

What it gives you
-----------------
Run the checks for a topic:

    pytest sql/04-joins
    pytest python/05-functions

Every question you have not attempted yet is reported as **skipped**, so a
fresh topic looks like::

    24 skipped

As you answer questions they turn into passes or failures. Failures print your
result next to the expected one so you can see what is different.

Checking the model answers
--------------------------
Setting the environment variable ``SOLUTIONS=1`` runs the checks against the
files in ``solutions/`` instead of your own work:

    SOLUTIONS=1 pytest              # macOS / Linux
    $env:SOLUTIONS=1; pytest        # Windows PowerShell

That is how the repository verifies itself. It is not cheating, it is just not
useful — the point of the exercise is the half hour before the answer.
"""

from __future__ import annotations

import importlib.util
import os
import sys
from functools import lru_cache
from pathlib import Path
from types import ModuleType

import pytest

ROOT = Path(__file__).parent
DB_PATH = ROOT / "data" / "finance.duckdb"


def use_solutions() -> bool:
    return os.environ.get("SOLUTIONS", "").strip() not in ("", "0", "false", "False")


# ---------------------------------------------------------------------------
# the database
# ---------------------------------------------------------------------------

@pytest.fixture(scope="session")
def con():
    """A read-only connection to data/finance.duckdb, shared by every test."""
    try:
        import duckdb
    except ModuleNotFoundError:  # pragma: no cover
        pytest.skip("duckdb is not installed — run: pip install -r requirements.txt")

    if not DB_PATH.exists():
        pytest.fail(
            f"{DB_PATH} does not exist.\n"
            f"Build it first:\n    python data/build_db.py",
            pytrace=False,
        )
    connection = duckdb.connect(str(DB_PATH), read_only=True)
    yield connection
    connection.close()


# ---------------------------------------------------------------------------
# SQL answers
# ---------------------------------------------------------------------------

def _strip_sql_comments(text: str) -> str:
    """Remove -- comments and blank lines, to tell 'empty' from 'attempted'."""
    lines = []
    for line in text.splitlines():
        code = line.split("--", 1)[0].strip()
        if code:
            lines.append(code)
    return " ".join(lines)


class SqlAnswer:
    """Runs a .sql file and compares its result with the model answer."""

    def __init__(self, topic_dir: Path, con):
        self.topic_dir = topic_dir
        self.con = con

    def _path(self, qid: str, folder: str) -> Path:
        return self.topic_dir / folder / f"{qid}.sql"

    def _run(self, path: Path):
        sql = path.read_text(encoding="utf-8")
        try:
            return self.con.sql(sql).df()
        except Exception as exc:  # noqa: BLE001 - we want the message, whatever it is
            pytest.fail(
                f"{path.relative_to(ROOT)} did not run.\n\n"
                f"DuckDB said:\n{exc}\n\n"
                f"Read the message from the bottom up — it usually names the "
                f"column or table it could not resolve.",
                pytrace=False,
            )

    def check(self, qid: str, ordered: bool = False) -> None:
        answer_folder = "solutions" if use_solutions() else "exercises"
        answer_path = self._path(qid, answer_folder)
        model_path = self._path(qid, "solutions")

        if not answer_path.exists():
            pytest.fail(f"{answer_path.relative_to(ROOT)} is missing.", pytrace=False)
        if not _strip_sql_comments(answer_path.read_text(encoding="utf-8")):
            pytest.skip(f"{qid}: not attempted yet")

        got = self._run(answer_path)
        expected = self._run(model_path)
        _compare_frames(got, expected, ordered=ordered,
                        label=str(answer_path.relative_to(ROOT)))


def _compare_frames(got, expected, *, ordered: bool, label: str) -> None:
    import pandas as pd

    def preview(df):
        with pd.option_context("display.max_columns", 20, "display.width", 200):
            return df.head(8).to_string(index=False)

    if got.shape[1] != expected.shape[1]:
        pytest.fail(
            f"{label}\n\n"
            f"Wrong number of columns: you returned {got.shape[1]}, "
            f"expected {expected.shape[1]}.\n"
            f"Expected columns: {list(expected.columns)}\n"
            f"Yours:            {list(got.columns)}",
            pytrace=False,
        )

    if got.shape[0] != expected.shape[0]:
        pytest.fail(
            f"{label}\n\n"
            f"Wrong number of rows: you returned {got.shape[0]:,}, "
            f"expected {expected.shape[0]:,}.\n\n"
            f"Too many rows after a join usually means duplication — check the "
            f"grain of both tables.\nToo few usually means an INNER JOIN or a "
            f"WHERE clause dropped rows with NULLs.\n\n"
            f"Your first rows:\n{preview(got)}\n\n"
            f"Expected first rows:\n{preview(expected)}",
            pytrace=False,
        )

    # column names are yours to choose; compare positionally
    got = got.copy()
    got.columns = expected.columns

    for df in (got, expected):
        for col in df.columns:
            if pd.api.types.is_float_dtype(df[col]):
                df[col] = df[col].round(2)

    if not ordered:
        keys = list(expected.columns)
        got = got.sort_values(keys, kind="stable", na_position="last").reset_index(drop=True)
        expected = expected.sort_values(keys, kind="stable", na_position="last").reset_index(drop=True)
    else:
        got = got.reset_index(drop=True)
        expected = expected.reset_index(drop=True)

    try:
        pd.testing.assert_frame_equal(
            got, expected, check_dtype=False, check_like=False,
            rtol=1e-6, atol=0.011,
        )
    except AssertionError as exc:
        order_note = ("\nThis question checks row order, so ORDER BY matters.\n"
                      if ordered else "")
        pytest.fail(
            f"{label}\n\n"
            f"Right shape ({got.shape[0]:,} rows), wrong values.{order_note}\n"
            f"Yours:\n{preview(got)}\n\n"
            f"Expected:\n{preview(expected)}\n\n"
            f"pandas reported:\n{exc}",
            pytrace=False,
        )


@pytest.fixture
def sql_answer(request, con) -> SqlAnswer:
    """Bound to the topic directory the calling test file lives in."""
    topic_dir = Path(request.path).parent.parent
    return SqlAnswer(topic_dir, con)


# ---------------------------------------------------------------------------
# Python answers
# ---------------------------------------------------------------------------

@lru_cache(maxsize=None)
def _load_module(path_str: str) -> ModuleType:
    path = Path(path_str)
    name = f"course_{path.parent.parent.name.replace('-', '_')}_{path.stem}"
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:  # pragma: no cover
        raise ImportError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


class PyAnswer:
    """Finds the function you were asked to write, in exercises/ or solutions/."""

    def __init__(self, topic_dir: Path):
        self.topic_dir = topic_dir
        self.folder = "solutions" if use_solutions() else "exercises"

    def fn(self, tier: str, name: str):
        """Return your function, wrapped so an unwritten stub becomes a skip."""
        path = self.topic_dir / self.folder / f"{tier}.py"
        if not path.exists():
            pytest.fail(f"{path.relative_to(ROOT)} is missing.", pytrace=False)

        try:
            module = _load_module(str(path))
        except Exception as exc:  # noqa: BLE001
            pytest.fail(
                f"{path.relative_to(ROOT)} could not be imported.\n\n"
                f"Python said:\n{type(exc).__name__}: {exc}\n\n"
                f"An error at import time is usually a typo or an indentation "
                f"problem somewhere in the file — not necessarily in the "
                f"function being tested.",
                pytrace=False,
            )

        func = getattr(module, name, None)
        if func is None:
            pytest.fail(
                f"{path.relative_to(ROOT)} has no function called {name!r}.\n"
                f"Check the spelling — it must match the exercise exactly.",
                pytrace=False,
            )
        if not callable(func):
            pytest.fail(f"{name!r} exists but is not a function.", pytrace=False)

        def wrapper(*args, **kwargs):
            try:
                return func(*args, **kwargs)
            except NotImplementedError:
                pytest.skip(f"{name}: not attempted yet")

        wrapper.__name__ = name
        wrapper.raw = func
        return wrapper


@pytest.fixture
def py_answer(request) -> PyAnswer:
    topic_dir = Path(request.path).parent.parent
    return PyAnswer(topic_dir)


# ---------------------------------------------------------------------------
# turning a topic's questions.py into one test per question
# ---------------------------------------------------------------------------

def load_questions(test_file: str | Path):
    """Load the questions.py that sits next to a topic's test file."""
    path = Path(test_file).parent / "questions.py"
    if not path.exists():
        return None
    topic = path.parent.parent
    name = f"questions_{topic.parent.name}_{topic.name.replace('-', '_')}"
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def pytest_generate_tests(metafunc):
    """Any test taking a `q` argument gets one run per question in the topic."""
    if "q" not in metafunc.fixturenames:
        return
    module = load_questions(metafunc.module.__file__)
    if module is None:  # pragma: no cover
        return
    metafunc.parametrize("q", module.QUESTIONS, ids=lambda item: item["id"])


# ---------------------------------------------------------------------------
# nicer reporting
# ---------------------------------------------------------------------------

def pytest_report_header(config):  # noqa: ARG001
    mode = "SOLUTIONS" if use_solutions() else "your answers"
    db = "built" if DB_PATH.exists() else "MISSING — run: python data/build_db.py"
    return [f"course: checking {mode}", f"database: {db}"]
