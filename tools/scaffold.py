"""Generate exercise stubs and exercise READMEs from each topic's question list.

Every topic keeps its questions in ``tests/questions.py``. This script turns
that single source of truth into:

  * ``exercises/README.md``  — the questions, grouped by tier
  * ``exercises/qNN.sql``    — an empty stub per question (SQL topics)
  * ``exercises/warmup.py``, ``core.py``, ``stretch.py`` (Python topics)

Existing files that already contain work are **never overwritten**. Stubs are
only written where the file is missing or still empty.

Usage:

    python tools/scaffold.py                # every topic
    python tools/scaffold.py sql/04-joins   # one topic
"""

from __future__ import annotations

import importlib.util
import sys
import textwrap
from pathlib import Path

ROOT = Path(__file__).parent.parent

TIER_TITLES = {
    "warmup": ("Warm-up", "One idea at a time, and close to a worked example."),
    "core": ("Core", "Realistic tasks that combine this topic with earlier ones."),
    "stretch": ("Stretch", "Vague on purpose. Expect to think, and to look things up."),
}
TIER_ORDER = ["warmup", "core", "stretch"]


def load_questions(topic_dir: Path):
    path = topic_dir / "tests" / "questions.py"
    if not path.exists():
        return None
    spec = importlib.util.spec_from_file_location(
        f"questions_{topic_dir.name.replace('-', '_')}", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def wrap(text: str, prefix: str, width: int = 76) -> str:
    text = textwrap.dedent(text)
    return "\n".join(
        textwrap.fill(line, width=width, initial_indent=prefix,
                      subsequent_indent=prefix) or prefix.rstrip()
        for line in text.strip().splitlines()
    )


def write_if_empty(path: Path, content: str) -> bool:
    if path.exists() and path.read_text(encoding="utf-8").strip():
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    return True


def build_readme(module, topic_dir: Path) -> str:
    kind = "sql" if str(topic_dir).replace("\\", "/").split("/")[-2] == "sql" else "python"
    out = [f"# Exercises — {module.TITLE}", ""]
    out.append(module.INTRO.strip())
    out.append("")
    if kind == "sql":
        out += [
            "Write each answer in `exercises/qNN.sql`. One query per file.",
            "",
            "Check your work with:",
            "",
            "```bash",
            f"pytest {topic_dir.relative_to(ROOT).as_posix()}",
            "```",
            "",
            "Anything you have not written yet is reported as *skipped*, not failed.",
        ]
    else:
        out += [
            "Write each answer in `exercises/warmup.py`, `core.py` or `stretch.py`.",
            "The function names and arguments must match exactly — the tests call",
            "them by name.",
            "",
            "Check your work with:",
            "",
            "```bash",
            f"pytest {topic_dir.relative_to(ROOT).as_posix()}",
            "```",
            "",
            "Anything still raising `NotImplementedError` is reported as *skipped*.",
        ]
    out.append("")

    for tier in TIER_ORDER:
        qs = [q for q in module.QUESTIONS if q["tier"] == tier]
        if not qs:
            continue
        title, blurb = TIER_TITLES[tier]
        out += ["---", "", f"## {title} ({len(qs)} questions)", "", f"*{blurb}*", ""]
        for q in qs:
            label = q["id"] if kind == "sql" else f"{q['id']} — `{q['signature']}`"
            out += [f"### {label}. {q['title']}", ""]
            out.append(textwrap.dedent(q["question"]).strip())
            out += ["", f"**Expected output:** {q['shape'].strip()}", ""]
            out += [f"> **Hint.** {q['hint'].strip()}", ""]
    return "\n".join(out).rstrip() + "\n"


def scaffold_sql(topic_dir: Path, module) -> None:
    made = 0
    for q in module.QUESTIONS:
        body = [
            f"-- {q['id']} ({q['tier']}) — {q['title']}",
            "--",
            wrap(q["question"], "-- "),
            "--",
            wrap(f"Expected output: {q['shape']}", "-- "),
            "--",
            wrap(f"Hint: {q['hint']}", "-- "),
            "",
            "-- Write your query below. One statement, ending in a semicolon.",
            "",
            "",
        ]
        made += write_if_empty(topic_dir / "exercises" / f"{q['id']}.sql",
                               "\n".join(body))
    print(f"  {topic_dir.relative_to(ROOT)}: {made} new stubs")


PY_HEADER = '''"""{tier_title} exercises — {title}.

Fill in each function. Delete the `raise NotImplementedError` line when you
start one; until then the test for it is skipped rather than failed.

Check your work with:  pytest {topic}
"""
'''


def scaffold_python(topic_dir: Path, module) -> None:
    made = 0
    for tier in TIER_ORDER:
        qs = [q for q in module.QUESTIONS if q["tier"] == tier]
        if not qs:
            continue
        path = topic_dir / "exercises" / f"{tier}.py"
        parts = [PY_HEADER.format(
            tier_title=TIER_TITLES[tier][0], title=module.TITLE,
            topic=topic_dir.relative_to(ROOT).as_posix())]
        for q in module.QUESTIONS:
            if q["tier"] != tier:
                continue
            doc = "\n".join([
                f'    """{q["title"]}.',
                "",
                wrap(q["question"], "    "),
                "",
                wrap(f"Returns: {q['shape']}", "    "),
                "",
                wrap(f"Hint: {q['hint']}", "    "),
                '    """',
            ])
            parts.append(
                f"\ndef {q['signature']}:\n{doc}\n"
                f"    raise NotImplementedError({q['id']!r})\n"
            )
        made += write_if_empty(path, "\n".join(parts))
    print(f"  {topic_dir.relative_to(ROOT)}: {made} new stub modules")


def scaffold(topic_dir: Path) -> None:
    module = load_questions(topic_dir)
    if module is None:
        return
    kind = topic_dir.parent.name
    readme = topic_dir / "exercises" / "README.md"
    readme.parent.mkdir(parents=True, exist_ok=True)
    readme.write_text(build_readme(module, topic_dir), encoding="utf-8")
    if kind == "sql":
        scaffold_sql(topic_dir, module)
    else:
        scaffold_python(topic_dir, module)


def main(argv: list[str]) -> None:
    if argv:
        targets = [ROOT / a for a in argv]
    else:
        targets = sorted(
            p for kind in ("sql", "python")
            for p in (ROOT / kind).iterdir() if p.is_dir()
        )
    print("Scaffolding exercises...")
    for t in targets:
        scaffold(t)


if __name__ == "__main__":
    main(sys.argv[1:])
