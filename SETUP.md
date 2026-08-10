# Setup

Budget about an hour. At the end of it you will have run your first program and
built a finance database on your own machine.

Nothing here needs admin approval from an IT department beyond installing
software, and nothing needs a server, a cloud account or a credit card. Once the
install finishes, the entire course runs offline.

---

## 0. What you are installing, and why

Four things. It helps to know what each one is for before you install it, so the
first hour feels less like following instructions blindly.

| Thing | What it is | The Excel analogy |
|---|---|---|
| **Python** | The programming language, plus the program that runs your code. | Excel itself — the application that executes what you write. |
| **VS Code** | A text editor built for code: colours, autocomplete, error squiggles. | The Excel window: the grid, the formula bar, the ribbon. |
| **git** | Version control. Records snapshots of your files so you can see what changed and undo mistakes. | "Save As `_v2_FINAL_v3`", but done properly and automatically. |
| **DuckDB** | A database engine that lives in a single file. No server to run. | An Access file, but fast, modern, and speaking standard SQL. |

Python and DuckDB are essential. VS Code is strongly recommended. git is
optional for week 1 but you will want it soon.

---

## 1. Install Python (3.11 or newer)

### Windows

1. Go to <https://www.python.org/downloads/> and download the latest Windows
   installer.
2. Run it. **On the first screen, tick "Add python.exe to PATH".** This is the
   single most common setup failure — if you miss it, your terminal will say
   `'python' is not recognized`. If that happens, re-run the installer, choose
   *Modify*, and tick it.
3. Click *Install Now*.

### macOS

The Python that ships with macOS is old and partly reserved for the system. Do
not use it. Either:

- Download the macOS installer from <https://www.python.org/downloads/>, or
- If you have Homebrew: `brew install python@3.12`

### Check it worked

Open a terminal — **Terminal** on macOS, **PowerShell** on Windows — and type:

```bash
python --version
```

You should see something like:

```
Python 3.12.4
```

If Windows opens the Microsoft Store instead, or says `python` is not
recognised, try `py --version`. If `py` works, use `py` everywhere this course
says `python`.

On macOS you may need `python3` instead of `python`. Same rule: whichever one
prints a 3.11+ version number is your command from now on.

---

## 2. Install VS Code

1. Download from <https://code.visualstudio.com/> and install.
2. Open it.
3. Click the Extensions icon in the left sidebar (four squares) and install:
   - **Python** (by Microsoft) — syntax highlighting, running scripts, debugging
   - **Jupyter** (by Microsoft) — notebooks, for later topics

VS Code has a built-in terminal: **View → Terminal**, or `` Ctrl+` ``. Use it —
it opens in your project folder automatically, which saves a lot of `cd`.

---

## 3. Install git

- **Windows**: download from <https://git-scm.com/download/win> and accept the
  defaults.
- **macOS**: run `git --version` in a terminal. If it is not installed, macOS
  offers to install the developer tools. Accept.

Then tell git who you are (it stamps this on every snapshot you make):

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

You will learn what git actually *does* in Python topic 08. For now this is just
so the tooling stops nagging you.

---

## 4. Get this repository onto your machine

If you were given a URL:

```bash
git clone <the-url>
cd DE_starter
```

If you were given a zip, unzip it somewhere sensible (`Documents/DE_starter` is
fine — avoid folder names with spaces or apostrophes; they cause avoidable
friction on the command line).

Then open the folder in VS Code: **File → Open Folder**, and pick the folder
containing this `SETUP.md`.

---

## 5. Create a virtual environment

A **virtual environment** is a private copy of Python for one project, with its
own libraries. It stops project A's library versions from breaking project B.
Think of it as a separate workbook rather than dumping everything into one giant
one.

In the VS Code terminal, from the project folder:

```bash
python -m venv .venv
```

That creates a `.venv` folder. Now **activate** it:

```bash
# macOS / Linux
source .venv/bin/activate

# Windows PowerShell
.venv\Scripts\Activate.ps1

# Windows Command Prompt
.venv\Scripts\activate.bat
```

Your prompt should now start with `(.venv)`. That is how you know it worked.

> **Windows PowerShell blocks the script?** If you see *"running scripts is
> disabled on this system"*, run:
> ```powershell
> Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
> ```
> then try activating again.

You must activate the environment **every time you open a new terminal**. If a
command suddenly says a library is missing, check for `(.venv)` in your prompt
first — nine times out of ten that is the problem.

---

## 6. Install the libraries

```bash
pip install -r requirements.txt
```

This downloads four packages. It is the only step that needs an internet
connection; everything after this works offline.

| Package | What it does |
|---|---|
| `duckdb` | The database engine. Runs SQL against a local file. |
| `pandas` | Spreadsheet-like tables in Python. Used from Python topic 11. |
| `pytest` | Runs the automated checks on your exercises. |
| `ipykernel` | Lets VS Code run Jupyter notebooks. |

Check it worked:

```bash
python -c "import duckdb, pandas; print(duckdb.__version__, pandas.__version__)"
```

You should see two version numbers.

---

## 7. Point VS Code at the right Python

VS Code needs to know to use `.venv` rather than some other Python on your
machine.

Press `Ctrl+Shift+P` (`Cmd+Shift+P` on macOS), type **Python: Select
Interpreter**, and choose the one whose path contains `.venv`.

If you skip this, scripts you run with VS Code's ▶ button will fail to find
`duckdb` even though `pip install` succeeded.

---

## 8. Build the database

```bash
python data/build_db.py
```

This reads the CSVs in `data/raw/` and writes a single file, `data/finance.duckdb`.
It takes a few seconds and prints a summary of what it loaded — table names and
row counts.

Re-running it is safe. It rebuilds from scratch every time, so if you ever break
the database with a bad `UPDATE`, delete `data/finance.duckdb`, run this again,
and you are back to a clean slate. That property has a name — **idempotency** —
and you will meet it properly in Python topic 14.

---

## 9. Run your first program

Create a file called `first_script.py` in the project root, and type this in
(type it, do not paste — muscle memory starts now):

```python
import duckdb

con = duckdb.connect("data/finance.duckdb", read_only=True)

result = con.sql("""
    SELECT account_code, account_name, account_type
    FROM chart_of_accounts
    ORDER BY account_code
    LIMIT 10
""")

print(result)

con.close()
```

Run it:

```bash
python first_script.py
```

You should see a small table of account codes printed to the terminal.

Line by line, since this is your first one:

- `import duckdb` — load the DuckDB library so this file can use it. Like
  enabling an add-in.
- `con = duckdb.connect(...)` — open the database file and keep the connection
  in a **variable** called `con`. `read_only=True` means this script cannot
  damage anything.
- `con.sql("""...""")` — run some SQL. The triple quotes let the text span
  several lines.
- `print(result)` — show the answer in the terminal. Without this, the program
  computes the answer and tells nobody.
- `con.close()` — close the file properly.

If it printed a table: your environment works, and you have run SQL from Python
on day one. Delete `first_script.py` if you like; you will write plenty more.

---

## 10. Check the test runner works

```bash
pytest --version
```

Then, from the project root:

```bash
pytest sql/00-orientation
```

Some tests will fail. **That is correct.** They are checking exercise files you
have not written yet. Failing tests are the course's to-do list — the point is
that the machinery runs.

---

## Common problems

| Symptom | Cause | Fix |
|---|---|---|
| `'python' is not recognized` (Windows) | Python not on PATH | Re-run installer → Modify → tick "Add to PATH". Or use `py`. |
| `command not found: python` (macOS) | The command is `python3` | Use `python3` and `pip3`. |
| `ModuleNotFoundError: No module named 'duckdb'` | Virtual environment not activated, or VS Code using the wrong interpreter | Check for `(.venv)` in your prompt; redo steps 5 and 7. |
| `IO Error: Cannot open file ... finance.duckdb` | Running from the wrong folder | Your terminal must be in the project root. Run `pwd` (macOS) or `cd` (Windows) to see where you are. |
| `Conversion Error` / `Binder Error` when querying | A SQL mistake, not a setup problem | Good news — setup is fine. Read the message; it names the column. |
| Database file is locked | Another script still has it open | Close other terminals/notebooks, or connect with `read_only=True`. |
| PowerShell won't activate `.venv` | Execution policy | See the note in step 5. |

---

## You should now be able to...

- Open a terminal and confirm your Python version
- Create and activate a virtual environment
- Install project dependencies from `requirements.txt`
- Build `finance.duckdb` from the raw CSVs, and rebuild it if you break it
- Run a `.py` file and see its output
- Run `pytest` and read pass/fail output

That is genuinely the whole toolchain. Everything from here is the actual
learning.

Next: **[sql/00-orientation](sql/00-orientation/)**.
