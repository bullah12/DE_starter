"""Generate the fictional finance dataset in data/raw/.

You do not need to run this — the CSVs it produces are committed to the
repository. It is here so you can see exactly where the data came from, and so
the dataset can be regenerated identically if it is ever lost.

The company is Ashcombe Components Ltd, a mid-sized UK distributor of
industrial components. Its fiscal year runs 1 April to 31 March. The data
covers 1 January 2022 to 31 December 2024.

Everything is deterministic: the random seed is fixed, so running this twice
produces byte-identical files.

The generator works in two phases:

  1. Build a *clean*, internally consistent set of records. Every journal
     balances, every invoice ties to its ledger postings, every payment ties to
     an invoice.
  2. Deliberately damage a small, documented subset of it — duplicates, nulls,
     casing, whitespace, mixed date formats, a handful of unbalanced journals.

Phase 2 is the point. Real extracts always look like this, and the cleaning
exercises need something real to bite on. Every defect injected here is listed
in data/README.md.
"""

from __future__ import annotations

import csv
import random
from datetime import date, timedelta
from pathlib import Path

RAW = Path(__file__).parent / "raw"
SEED = 20240401

START = date(2022, 1, 1)
END = date(2024, 12, 31)

rng = random.Random(SEED)


# ---------------------------------------------------------------------------
# small helpers
# ---------------------------------------------------------------------------

def month_starts(start: date, end: date) -> list[date]:
    out, cur = [], date(start.year, start.month, 1)
    while cur <= end:
        out.append(cur)
        cur = date(cur.year + (cur.month == 12), cur.month % 12 + 1, 1)
    return out


def month_end(d: date) -> date:
    nxt = date(d.year + (d.month == 12), d.month % 12 + 1, 1)
    return nxt - timedelta(days=1)


def working_day(d: date) -> date:
    """Nudge a date off the weekend and onto the preceding Friday.

    Never returns a date before the start of the dataset — the very first
    week would otherwise spill back into December 2021.
    """
    while d.weekday() >= 5:
        d -= timedelta(days=1)
    while d < START:
        d += timedelta(days=1)
        while d.weekday() >= 5:
            d += timedelta(days=1)
    return d


def money(x: float) -> float:
    return round(x + 1e-9, 2)


def fiscal_year(d: date) -> str:
    """FY label for a date. FY ends 31 March, labelled by the ending year."""
    return f"FY{d.year + 1}" if d.month >= 4 else f"FY{d.year}"


def fiscal_period(d: date) -> int:
    """Period 1 = April ... period 12 = March."""
    return (d.month - 4) % 12 + 1


def write_csv(name: str, header: list[str], rows: list[list]) -> None:
    RAW.mkdir(parents=True, exist_ok=True)
    path = RAW / name
    with path.open("w", newline="", encoding="utf-8") as fh:
        w = csv.writer(fh, lineterminator="\n")
        w.writerow(header)
        w.writerows(rows)
    print(f"  wrote {path.relative_to(Path(__file__).parent.parent)}  ({len(rows)} rows)")


# ---------------------------------------------------------------------------
# 1. chart of accounts
# ---------------------------------------------------------------------------

# (code, name, type, report_section, normal_balance)
COA = [
    (1010, "Freehold Property", "ASSET", "Fixed Assets", "DEBIT"),
    (1020, "Plant and Machinery", "ASSET", "Fixed Assets", "DEBIT"),
    (1030, "Motor Vehicles", "ASSET", "Fixed Assets", "DEBIT"),
    (1040, "Office Equipment", "ASSET", "Fixed Assets", "DEBIT"),
    (1090, "Accumulated Depreciation", "ASSET", "Fixed Assets", "CREDIT"),
    (1200, "Trade Debtors", "ASSET", "Current Assets", "DEBIT"),
    (1210, "Other Debtors", "ASSET", "Current Assets", "DEBIT"),
    (1220, "Prepayments", "ASSET", "Current Assets", "DEBIT"),
    (1300, "Stock - Raw Materials", "ASSET", "Current Assets", "DEBIT"),
    (1310, "Stock - Finished Goods", "ASSET", "Current Assets", "DEBIT"),
    (1400, "Bank Current Account", "ASSET", "Current Assets", "DEBIT"),
    (1410, "Bank Deposit Account", "ASSET", "Current Assets", "DEBIT"),
    (1420, "Petty Cash", "ASSET", "Current Assets", "DEBIT"),
    (2000, "Trade Creditors", "LIABILITY", "Current Liabilities", "CREDIT"),
    (2010, "Accruals", "LIABILITY", "Current Liabilities", "CREDIT"),
    (2100, "VAT Control", "LIABILITY", "Current Liabilities", "CREDIT"),
    (2110, "PAYE and NI Control", "LIABILITY", "Current Liabilities", "CREDIT"),
    (2120, "Pension Control", "LIABILITY", "Current Liabilities", "CREDIT"),
    (2200, "Bank Loan", "LIABILITY", "Long Term Liabilities", "CREDIT"),
    (2300, "Deferred Income", "LIABILITY", "Current Liabilities", "CREDIT"),
    (3000, "Ordinary Share Capital", "EQUITY", "Equity", "CREDIT"),
    (3100, "Retained Earnings", "EQUITY", "Equity", "CREDIT"),
    (4000, "Sales - Components UK", "INCOME", "Revenue", "CREDIT"),
    (4010, "Sales - Components Export", "INCOME", "Revenue", "CREDIT"),
    (4020, "Sales - Services", "INCOME", "Revenue", "CREDIT"),
    (4030, "Sales - Spare Parts", "INCOME", "Revenue", "CREDIT"),
    (4900, "Other Income", "INCOME", "Revenue", "CREDIT"),
    (5000, "Materials Purchases", "EXPENSE", "Cost of Sales", "DEBIT"),
    (5010, "Carriage Inwards", "EXPENSE", "Cost of Sales", "DEBIT"),
    (5020, "Subcontractor Costs", "EXPENSE", "Cost of Sales", "DEBIT"),
    (5030, "Stock Movement", "EXPENSE", "Cost of Sales", "DEBIT"),
    (6000, "Salaries and Wages", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6010, "Employer National Insurance", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6020, "Pension Contributions", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6030, "Recruitment", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6040, "Training", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6100, "Rent", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6110, "Business Rates", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6120, "Light and Heat", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6130, "Insurance", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6140, "Repairs and Maintenance", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6200, "Motor Expenses", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6210, "Travel and Subsistence", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6220, "Entertaining", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6300, "Telephone and Internet", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6310, "IT Software and Licences", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6320, "Postage and Stationery", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6400, "Advertising and Marketing", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6500, "Audit and Accountancy", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6510, "Legal and Professional", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6520, "Bank Charges", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6600, "Depreciation", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6700, "Bad Debt Expense", "EXPENSE", "Operating Expenses", "DEBIT"),
    (6900, "Foreign Exchange Gain or Loss", "EXPENSE", "Operating Expenses", "DEBIT"),
    (7000, "Interest Payable", "EXPENSE", "Finance Costs", "DEBIT"),
    (8000, "Corporation Tax", "EXPENSE", "Tax", "DEBIT"),
]

# accounts that are closed but kept on the chart, to give WHERE-clause practice
INACTIVE = {1410, 4900, 6030}


def build_chart_of_accounts() -> list[list]:
    rows = []
    for code, name, atype, section, normal in COA:
        rows.append([
            code,
            name,
            atype,
            section,
            normal,
            "N" if code in INACTIVE else "Y",
        ])
    return rows


# ---------------------------------------------------------------------------
# 2. cost centres
# ---------------------------------------------------------------------------

COST_CENTRES = [
    ("CC100", "Head Office", "South East", "SUPPORT"),
    ("CC200", "Sales - North", "North West", "REVENUE"),
    ("CC210", "Sales - South", "South East", "REVENUE"),
    ("CC220", "Sales - Export", "South East", "REVENUE"),
    ("CC300", "Warehouse and Logistics", "Midlands", "OPERATIONS"),
    ("CC400", "Manufacturing", "Midlands", "OPERATIONS"),
    ("CC500", "Finance", "South East", "SUPPORT"),
    ("CC600", "IT", "South East", "SUPPORT"),
]

SALES_CCS = ["CC200", "CC210", "CC220"]


# ---------------------------------------------------------------------------
# 3. employees
# ---------------------------------------------------------------------------

FIRST_NAMES = [
    "Alice", "Bhavin", "Catherine", "Daniel", "Eleanor", "Farhan", "Grace",
    "Hamish", "Isobel", "Jamal", "Katrina", "Liam", "Marta", "Niall", "Olu",
    "Priya", "Quentin", "Rosa", "Stefan", "Tomas", "Ursula", "Vikram", "Wendy",
    "Xiaoli", "Yusuf", "Zara", "Aidan", "Bridget", "Callum", "Delphine",
    "Ewan", "Fiona", "Gareth", "Heidi", "Ismail", "Joanna", "Kwame", "Lucia",
    "Malachy", "Nadia", "Oscar", "Petra", "Rhys", "Sofia", "Terence",
]

LAST_NAMES = [
    "Ainsworth", "Barrow", "Chatterjee", "Donnelly", "Evershed", "Fairbairn",
    "Gallagher", "Hollingworth", "Ikeda", "Jarvis", "Kowalski", "Lindqvist",
    "Mensah", "Nowak", "Ogilvie", "Pemberton", "Quirke", "Rasmussen",
    "Sandoval", "Thackeray", "Underhill", "Vasquez", "Whitfield", "Yardley",
    "Zieliński", "Ashby", "Bramwell", "Corrigan", "Dunmore", "Eastwood",
]

JOB_TITLES = {
    "CC100": ["Managing Director", "Executive Assistant", "HR Manager"],
    "CC200": ["Area Sales Manager", "Account Manager", "Sales Executive"],
    "CC210": ["Area Sales Manager", "Account Manager", "Sales Executive"],
    "CC220": ["Export Sales Manager", "Export Coordinator"],
    "CC300": ["Warehouse Manager", "Forklift Operator", "Goods In Clerk"],
    "CC400": ["Production Manager", "Machine Operator", "Quality Inspector"],
    "CC500": ["Finance Director", "Management Accountant", "Purchase Ledger Clerk",
              "Sales Ledger Clerk", "Payroll Officer"],
    "CC600": ["IT Manager", "Systems Administrator", "Support Analyst"],
}

HEADCOUNT = {"CC100": 4, "CC200": 12, "CC210": 14, "CC220": 6,
             "CC300": 16, "CC400": 18, "CC500": 7, "CC600": 5}


def build_employees() -> list[list]:
    rows = []
    emp_id = 1001
    used_names: set[tuple[str, str]] = set()
    for cc, headcount in HEADCOUNT.items():
        for i in range(headcount):
            while True:
                first = rng.choice(FIRST_NAMES)
                last = rng.choice(LAST_NAMES)
                if (first, last) not in used_names:
                    used_names.add((first, last))
                    break
            title = JOB_TITLES[cc][min(i, len(JOB_TITLES[cc]) - 1)]
            # senior roles are the first in each list and pay more
            band = 0 if i == 0 else (1 if i < 3 else 2)
            base = {0: 78000, 1: 46000, 2: 31000}[band]
            salary = money(base * rng.uniform(0.88, 1.18) / 100) * 100
            hire = date(2013, 1, 1) + timedelta(days=rng.randint(0, 4000))
            # about one in nine has left
            term = None
            if rng.random() < 0.11:
                term = hire + timedelta(days=rng.randint(500, 3600))
                if term > END:
                    term = None
            rows.append([
                emp_id, first, last,
                f"{first.lower()}.{last.lower()}@ashcombe.example",
                title, cc, hire.isoformat(),
                term.isoformat() if term else "",
                salary,
            ])
            emp_id += 1
    return rows


# ---------------------------------------------------------------------------
# 4. customers and suppliers
# ---------------------------------------------------------------------------

CUST_PREFIX = ["Northgate", "Vulcan", "Redland", "Pinewood", "Trentham",
               "Halcyon", "Cavendish", "Brightside", "Kestrel", "Ironbridge",
               "Falkirk", "Meridian", "Oakfield", "Sanderling", "Thorncliff",
               "Whitmore", "Ardennes", "Beaufort", "Cranmere", "Dunbarton"]
CUST_SUFFIX = ["Engineering", "Industrial", "Systems", "Fabrication",
               "Machinery", "Holdings", "Motors", "Plant Hire", "Utilities",
               "Contracts"]
CUST_LEGAL = ["Ltd", "Ltd", "Ltd", "PLC", "GmbH", "SARL", "BV", "Inc"]

COUNTRIES = [
    ("United Kingdom", "GBP", 0.62),
    ("Ireland", "EUR", 0.08),
    ("Germany", "EUR", 0.09),
    ("France", "EUR", 0.06),
    ("Netherlands", "EUR", 0.04),
    ("United States", "USD", 0.07),
    ("Spain", "EUR", 0.04),
]


def pick_country() -> tuple[str, str]:
    r = rng.random()
    cum = 0.0
    for name, ccy, weight in COUNTRIES:
        cum += weight
        if r <= cum:
            return name, ccy
    return "United Kingdom", "GBP"


def build_customers(n: int = 62) -> list[list]:
    rows = []
    seen: set[str] = set()
    for i in range(n):
        while True:
            name = (f"{rng.choice(CUST_PREFIX)} {rng.choice(CUST_SUFFIX)} "
                    f"{rng.choice(CUST_LEGAL)}")
            if name not in seen:
                seen.add(name)
                break
        country, ccy = pick_country()
        terms = rng.choice([14, 30, 30, 30, 45, 60, 60, 90])
        limit = rng.choice([25000, 50000, 50000, 100000, 150000, 250000, 500000])
        created = date(2015, 1, 1) + timedelta(days=rng.randint(0, 2500))
        cc = "CC220" if country != "United Kingdom" else rng.choice(["CC200", "CC210"])
        rows.append([
            f"C{2000 + i}", name, country, ccy, terms, limit,
            created.isoformat(), cc, "Y" if rng.random() > 0.06 else "N",
        ])
    return rows


SUPP_PREFIX = ["Ardsley", "Coleridge", "Drakemoor", "Ellesmere", "Fenwick",
               "Grantham", "Hartlepool", "Inverclyde", "Jedburgh", "Kirkwall",
               "Lomond", "Marchmont", "Netherby", "Ormskirk", "Penhale",
               "Ravensworth", "Selkirk", "Tavistock"]
SUPP_SUFFIX = ["Supplies", "Metals", "Components", "Logistics", "Services",
               "Chemicals", "Packaging", "Tooling", "Energy", "Consulting"]


def build_suppliers(n: int = 46) -> list[list]:
    rows = []
    seen: set[str] = set()
    for i in range(n):
        while True:
            name = (f"{rng.choice(SUPP_PREFIX)} {rng.choice(SUPP_SUFFIX)} "
                    f"{rng.choice(CUST_LEGAL)}")
            if name not in seen:
                seen.add(name)
                break
        country, ccy = pick_country()
        terms = rng.choice([14, 30, 30, 30, 45, 60])
        created = date(2014, 1, 1) + timedelta(days=rng.randint(0, 2800))
        rows.append([
            f"S{3000 + i}", name, country, ccy, terms,
            created.isoformat(), "Y" if rng.random() > 0.05 else "N",
        ])
    return rows


# ---------------------------------------------------------------------------
# 5. FX rates
# ---------------------------------------------------------------------------

def build_fx_rates() -> tuple[list[list], dict[tuple[str, date], float]]:
    """Daily rates to GBP, with weekends and a few weekdays missing."""
    rows: list[list] = []
    lookup: dict[tuple[str, date], float] = {}
    levels = {"EUR": 0.8420, "USD": 0.7910}
    # start a week early so that dates nudged back off a weekend still resolve
    d = START - timedelta(days=7)
    while d <= END:
        for ccy in ("EUR", "USD"):
            levels[ccy] *= 1 + rng.gauss(0, 0.0035)
            lookup[(ccy, d)] = round(levels[ccy], 6)
            if d < START or d.weekday() >= 5:
                continue          # no rate published at the weekend
            if rng.random() < 0.012:
                continue          # the occasional missing weekday
            rows.append([d.isoformat(), ccy, "GBP", round(levels[ccy], 6)])
        d += timedelta(days=1)
    return rows, lookup


def to_gbp(amount: float, ccy: str, d: date,
           lookup: dict[tuple[str, date], float]) -> float:
    if ccy == "GBP":
        return money(amount)
    return money(amount * lookup[(ccy, d)])


# ---------------------------------------------------------------------------
# 6. the ledger: journals, GL lines, invoices, payments
# ---------------------------------------------------------------------------

class Ledger:
    """Accumulates journal headers and general ledger lines."""

    def __init__(self) -> None:
        self.journals: list[list] = []
        self.lines: list[list] = []
        self._seq: dict[int, int] = {}
        self._gl_id = 1

    def next_journal_id(self, d: date) -> str:
        n = self._seq.get(d.year, 0) + 1
        self._seq[d.year] = n
        return f"JE-{d.year}-{n:05d}"

    def post(self, d: date, source: str, description: str, legs: list[tuple],
             prepared_by: int, approved_by: int | None = None,
             status: str = "POSTED") -> str:
        """legs: (account_code, cost_centre, debit, credit, line_description)"""
        jid = self.next_journal_id(d)
        posted = working_day(d + timedelta(days=rng.randint(0, 3)))
        self.journals.append([
            jid, d.isoformat(), posted.isoformat(), d.strftime("%Y-%m"),
            fiscal_year(d), fiscal_period(d), source, description,
            prepared_by, approved_by if approved_by else "", status,
        ])
        for i, (acct, cc, dr, cr, desc) in enumerate(legs, start=1):
            self.lines.append([
                self._gl_id, jid, i, acct, cc if cc else "",
                d.isoformat(), desc, money(dr), money(cr),
            ])
            self._gl_id += 1
        return jid


VAT_RATE = 0.20

REVENUE_MIX = [
    ("UK", 4000, 0.46), ("UK", 4030, 0.14), ("UK", 4020, 0.08),
    ("EXPORT", 4010, 0.26), ("EXPORT", 4020, 0.06),
]

PURCHASE_MIX = [
    (5000, 0.34), (5010, 0.06), (5020, 0.09), (6100, 0.03), (6110, 0.02),
    (6120, 0.04), (6130, 0.03), (6140, 0.04), (6200, 0.04), (6210, 0.05),
    (6220, 0.02), (6300, 0.03), (6310, 0.05), (6320, 0.02), (6400, 0.05),
    (6500, 0.02), (6510, 0.03), (6040, 0.04),
]

PURCHASE_CC = {
    5000: ["CC400", "CC300"], 5010: ["CC300"], 5020: ["CC400"],
    6100: ["CC100"], 6110: ["CC100"], 6120: ["CC100", "CC300", "CC400"],
    6130: ["CC100"], 6140: ["CC300", "CC400"], 6200: SALES_CCS + ["CC300"],
    6210: SALES_CCS + ["CC100", "CC500"], 6220: SALES_CCS,
    6300: ["CC600"], 6310: ["CC600"], 6320: ["CC100", "CC500"],
    6400: ["CC200", "CC210", "CC220"], 6500: ["CC500"], 6510: ["CC500"],
    6040: ["CC100"],
}


def weighted_choice(pairs):
    total = sum(w for *_, w in pairs)
    r = rng.random() * total
    cum = 0.0
    for item in pairs:
        cum += item[-1]
        if r <= cum:
            return item
    return pairs[-1]


def seasonal_factor(d: date) -> float:
    """Sales are quiet in the summer and busy before the year end."""
    return {1: 0.92, 2: 0.95, 3: 1.08, 4: 0.98, 5: 1.02, 6: 1.05,
            7: 0.86, 8: 0.78, 9: 1.06, 10: 1.10, 11: 1.14, 12: 1.02}[d.month]


def growth_factor(d: date) -> float:
    months = (d.year - START.year) * 12 + (d.month - START.month)
    return 1.0 + 0.0055 * months


def build_ledger(customers, suppliers, employees, fx_lookup):
    led = Ledger()
    invoices: list[list] = []
    payments: list[list] = []

    finance_staff = [e[0] for e in employees if e[5] == "CC500"]
    preparer = finance_staff[1] if len(finance_staff) > 1 else finance_staff[0]
    approver = finance_staff[0]

    cust_by_id = {c[0]: c for c in customers}
    active_customers = [c for c in customers if c[8] == "Y"]
    active_suppliers = [s for s in suppliers if s[6] == "Y"]

    ar_open: list[dict] = []   # unpaid sales invoices
    ap_open: list[dict] = []   # unpaid purchase invoices
    ar_seq = ap_seq = pay_seq = 0

    for m in month_starts(START, END):
        me = month_end(m)

        # ---------------- sales invoices ----------------
        n_sales = int(round(48 * seasonal_factor(m) * growth_factor(m)))
        for _ in range(n_sales):
            cust = rng.choice(active_customers)
            cid, _name, country, ccy, terms, _limit, _cr, cc, _act = cust
            is_uk = country == "United Kingdom"
            region = "UK" if is_uk else "EXPORT"
            options = [r for r in REVENUE_MIX if r[0] == region]
            _, revenue_account, _ = weighted_choice(options)

            inv_date = working_day(m + timedelta(days=rng.randint(0, (me - m).days)))
            net = money(rng.lognormvariate(9.0, 0.75) * growth_factor(m))
            net = min(net, 180000.0)
            vat = money(net * VAT_RATE) if is_uk else 0.0
            gross = money(net + vat)
            due = inv_date + timedelta(days=terms)

            ar_seq += 1
            inv_id = f"SI-{inv_date.year}-{ar_seq:05d}"

            net_gbp = to_gbp(net, ccy, inv_date, fx_lookup)
            vat_gbp = to_gbp(vat, ccy, inv_date, fx_lookup)
            gross_gbp = money(net_gbp + vat_gbp)

            legs = [(1200, cc, gross_gbp, 0, f"Sales invoice {inv_id}"),
                    (revenue_account, cc, 0, net_gbp, f"Sales invoice {inv_id}")]
            if vat_gbp:
                legs.append((2100, cc, 0, vat_gbp, f"Output VAT {inv_id}"))
            led.post(inv_date, "AR", f"Sales invoice {inv_id}", legs,
                     preparer, approver)

            invoices.append({
                "invoice_id": inv_id, "invoice_type": "SALES",
                "customer_id": cid, "supplier_id": "",
                "invoice_date": inv_date, "due_date": due,
                "currency": ccy, "net_amount": net, "tax_amount": vat,
                "gross_amount": gross, "gross_amount_gbp": gross_gbp,
                "cost_centre_code": cc, "status": "OPEN",
                "account_code": revenue_account,
            })
            ar_open.append(invoices[-1])

        # ---------------- purchase invoices ----------------
        n_purch = int(round(34 * growth_factor(m) * rng.uniform(0.9, 1.1)))
        for _ in range(n_purch):
            supp = rng.choice(active_suppliers)
            sid, _sname, scountry, sccy, sterms, _screated, _sact = supp
            account, _w = weighted_choice(PURCHASE_MIX)
            cc = rng.choice(PURCHASE_CC[account])
            inv_date = working_day(m + timedelta(days=rng.randint(0, (me - m).days)))
            base = 9000 if account == 5000 else 1400
            net = money(rng.lognormvariate(0, 0.8) * base * growth_factor(m))
            net = min(net, 120000.0)
            recoverable = scountry == "United Kingdom"
            vat = money(net * VAT_RATE) if recoverable else 0.0
            gross = money(net + vat)
            due = inv_date + timedelta(days=sterms)

            ap_seq += 1
            inv_id = f"PI-{inv_date.year}-{ap_seq:05d}"

            net_gbp = to_gbp(net, sccy, inv_date, fx_lookup)
            vat_gbp = to_gbp(vat, sccy, inv_date, fx_lookup)
            gross_gbp = money(net_gbp + vat_gbp)

            legs = [(account, cc, net_gbp, 0, f"Purchase invoice {inv_id}")]
            if vat_gbp:
                legs.append((2100, cc, vat_gbp, 0, f"Input VAT {inv_id}"))
            legs.append((2000, cc, 0, gross_gbp, f"Purchase invoice {inv_id}"))
            led.post(inv_date, "AP", f"Purchase invoice {inv_id}", legs,
                     preparer, approver)

            invoices.append({
                "invoice_id": inv_id, "invoice_type": "PURCHASE",
                "customer_id": "", "supplier_id": sid,
                "invoice_date": inv_date, "due_date": due,
                "currency": sccy, "net_amount": net, "tax_amount": vat,
                "gross_amount": gross, "gross_amount_gbp": gross_gbp,
                "cost_centre_code": cc, "status": "OPEN",
                "account_code": account,
            })
            ap_open.append(invoices[-1])

        # ---------------- customer receipts ----------------
        still_open = []
        for inv in ar_open:
            terms = cust_by_id[inv["customer_id"]][4]
            lateness = rng.choice([-3, 0, 2, 5, 9, 14, 22, 35, 60])
            pay_date = inv["due_date"] + timedelta(days=lateness)
            deadbeat = rng.random() < 0.035        # never pays within the data
            if deadbeat or pay_date > me or pay_date > END:
                still_open.append(inv)
                continue
            pay_date = working_day(pay_date)
            pay_seq += 1
            amount = inv["gross_amount"]
            amount_gbp = to_gbp(amount, inv["currency"], pay_date, fx_lookup)
            payments.append([
                f"RCP-{pay_date.year}-{pay_seq:05d}", inv["invoice_id"],
                "RECEIPT", pay_date.isoformat(), inv["currency"],
                money(amount), amount_gbp,
                rng.choice(["BACS", "BACS", "BACS", "CHEQUE", "CARD"]),
                f"BNK{rng.randint(100000, 999999)}",
            ])
            fx_diff = money(amount_gbp - inv["gross_amount_gbp"])
            legs = [(1400, inv["cost_centre_code"], amount_gbp, 0,
                     f"Receipt {inv['invoice_id']}"),
                    (1200, inv["cost_centre_code"], 0, inv["gross_amount_gbp"],
                     f"Receipt {inv['invoice_id']}")]
            if fx_diff:
                if fx_diff > 0:
                    legs.append((6900, inv["cost_centre_code"], 0, fx_diff, "FX on settlement"))
                else:
                    legs.append((6900, inv["cost_centre_code"], -fx_diff, 0, "FX on settlement"))
            led.post(pay_date, "CASH", f"Customer receipt {inv['invoice_id']}",
                     legs, preparer, approver)
            inv["status"] = "PAID"
        ar_open = still_open

        # ---------------- supplier payments ----------------
        still_open = []
        for inv in ap_open:
            pay_date = inv["due_date"] + timedelta(days=rng.choice([-2, 0, 0, 3, 7, 12, 20]))
            if pay_date > me or pay_date > END or rng.random() < 0.02:
                still_open.append(inv)
                continue
            pay_date = working_day(pay_date)
            pay_seq += 1
            amount = inv["gross_amount"]
            amount_gbp = to_gbp(amount, inv["currency"], pay_date, fx_lookup)
            payments.append([
                f"PAY-{pay_date.year}-{pay_seq:05d}", inv["invoice_id"],
                "PAYMENT", pay_date.isoformat(), inv["currency"],
                money(amount), amount_gbp,
                rng.choice(["BACS", "BACS", "BACS", "CHEQUE", "DD"]),
                f"BNK{rng.randint(100000, 999999)}",
            ])
            fx_diff = money(amount_gbp - inv["gross_amount_gbp"])
            legs = [(2000, inv["cost_centre_code"], inv["gross_amount_gbp"], 0,
                     f"Payment {inv['invoice_id']}"),
                    (1400, inv["cost_centre_code"], 0, amount_gbp,
                     f"Payment {inv['invoice_id']}")]
            if fx_diff:
                if fx_diff > 0:
                    legs.append((6900, inv["cost_centre_code"], fx_diff, 0, "FX on settlement"))
                else:
                    legs.append((6900, inv["cost_centre_code"], 0, -fx_diff, "FX on settlement"))
            led.post(pay_date, "CASH", f"Supplier payment {inv['invoice_id']}",
                     legs, preparer, approver)
            inv["status"] = "PAID"
        ap_open = still_open

        # ---------------- payroll ----------------
        pay_day = working_day(date(me.year, me.month, min(28, me.day)))
        gross_by_cc: dict[str, float] = {}
        for e in employees:
            hire = date.fromisoformat(e[6])
            term = date.fromisoformat(e[7]) if e[7] else None
            if hire > me or (term and term < m):
                continue
            gross_by_cc[e[5]] = gross_by_cc.get(e[5], 0.0) + e[8] / 12.0
        legs, total_gross, total_ni, total_pen = [], 0.0, 0.0, 0.0
        for cc, gross in sorted(gross_by_cc.items()):
            gross = money(gross)
            ni = money(gross * 0.138)
            pen = money(gross * 0.04)
            legs.append((6000, cc, gross, 0, "Payroll - gross pay"))
            legs.append((6010, cc, ni, 0, "Payroll - employer NI"))
            legs.append((6020, cc, pen, 0, "Payroll - pension"))
            total_gross += gross
            total_ni += ni
            total_pen += pen
        paye = money(total_gross * 0.24 + total_ni)
        net_pay = money(total_gross - money(total_gross * 0.24))
        legs.append((2110, None, 0, paye, "PAYE and NI due"))
        legs.append((2120, None, 0, money(total_pen), "Pension due"))
        legs.append((1400, None, 0, net_pay, "Net pay"))
        led.post(pay_day, "PAYROLL", f"Payroll {m.strftime('%B %Y')}", legs,
                 preparer, approver)

        # ---------------- depreciation ----------------
        dep = money(14500 + 220 * ((m.year - 2022) * 12 + m.month))
        led.post(me, "GENERAL", f"Depreciation {m.strftime('%b %Y')}",
                 [(6600, "CC100", dep, 0, "Monthly depreciation charge"),
                  (1090, "CC100", 0, dep, "Monthly depreciation charge")],
                 preparer, approver)

        # ---------------- bank interest and charges ----------------
        charges = money(rng.uniform(280, 620))
        interest = money(18000 * 0.0055)
        led.post(me, "GENERAL", f"Bank charges and interest {m.strftime('%b %Y')}",
                 [(6520, "CC500", charges, 0, "Bank charges"),
                  (7000, "CC500", interest, 0, "Loan interest"),
                  (1400, "CC500", 0, money(charges + interest), "Bank")],
                 preparer, approver)

        # ---------------- quarterly VAT payment ----------------
        if m.month in (1, 4, 7, 10):
            vat_due = money(rng.uniform(120000, 210000) * growth_factor(m))
            led.post(working_day(m + timedelta(days=6)), "GENERAL",
                     "VAT return payment", [
                         (2100, "CC500", vat_due, 0, "VAT paid to HMRC"),
                         (1400, "CC500", 0, vat_due, "VAT paid to HMRC"),
                     ], preparer, approver)

        # ---------------- year end journals ----------------
        if m.month == 3:
            accrual = money(rng.uniform(40000, 75000))
            led.post(me, "GENERAL", f"Year end accruals {fiscal_year(me)}",
                     [(6500, "CC500", accrual, 0, "Audit fee accrual"),
                      (2010, "CC500", 0, accrual, "Audit fee accrual")],
                     preparer, approver)
            tax = money(rng.uniform(180000, 320000))
            led.post(me, "GENERAL", f"Corporation tax provision {fiscal_year(me)}",
                     [(8000, "CC500", tax, 0, "Corporation tax charge"),
                      (2010, "CC500", 0, tax, "Corporation tax provision")],
                     preparer, approver)

    return led, invoices, payments, ar_open


# ---------------------------------------------------------------------------
# 7. budgets
# ---------------------------------------------------------------------------

def build_budgets(gl_lines) -> list[list]:
    """Budget by fiscal year / period / account / cost centre.

    Budgets are set from a base year's actuals plus an uplift and some noise,
    which is roughly how a real budget gets built and means variances are
    believable rather than random.

    Budgets exist for FY2023, FY2024 and FY2025 only. FY2022 (which in this
    dataset is just January to March 2022) has actuals but no budget — that
    gap is deliberate, and it is what makes a budget-vs-actual LEFT JOIN
    behave interestingly.
    """
    # which year's actuals each budget is built from
    BASE_YEAR = {"FY2023": "FY2023", "FY2024": "FY2023", "FY2025": "FY2024"}
    actual: dict[tuple[str, int, int, str], float] = {}
    for _gid, _jid, _ln, acct, cc, entry_date, _desc, dr, cr in gl_lines:
        if acct < 4000:
            continue
        d = date.fromisoformat(entry_date)
        key = (fiscal_year(d), fiscal_period(d), acct, cc or "CC100")
        signed = (cr - dr) if acct < 5000 else (dr - cr)
        actual[key] = actual.get(key, 0.0) + signed

    rows: list[list] = []
    bud_id = 1
    for fy in ("FY2023", "FY2024", "FY2025"):
        base = BASE_YEAR[fy]
        for period in range(1, 13):
            for (a_fy, a_period, acct, cc), amount in sorted(actual.items()):
                if a_fy != base or a_period != period:
                    continue
                if abs(amount) < 500:
                    continue
                uplift = 1.05 + rng.gauss(0, 0.06)
                budget = money(round(amount * uplift / 50) * 50)
                if budget == 0:
                    continue
                rows.append([bud_id, fy, period, acct, cc, budget, "APPROVED", "v2"])
                bud_id += 1
    return rows


# ---------------------------------------------------------------------------
# 8. deliberate mess
# ---------------------------------------------------------------------------

DATE_FORMATS = ["%Y-%m-%d", "%d/%m/%Y", "%d-%b-%Y"]


def messy_date(d: date, i: int) -> str:
    """Cycle three formats so the column cannot be parsed naively."""
    return d.strftime(DATE_FORMATS[i % 3])


def scramble_case(s: str, i: int) -> str:
    return [s, s.upper(), s.lower(), s][i % 4]


def add_whitespace(s: str, i: int) -> str:
    return [s, f"  {s}", f"{s}  ", s][i % 4]


def main() -> None:
    print("Generating raw CSVs for Ashcombe Components Ltd...")

    coa = build_chart_of_accounts()
    employees = build_employees()
    customers = build_customers()
    suppliers = build_suppliers()
    fx_rows, fx_lookup = build_fx_rates()
    led, invoices, payments, ar_open = build_ledger(
        customers, suppliers, employees, fx_lookup)
    budgets = build_budgets(led.lines)

    # ---- mess: chart of accounts -----------------------------------------
    for i, row in enumerate(coa):
        if i % 7 == 3:
            row[1] = add_whitespace(row[1], 1)
        if i % 11 == 5:
            row[1] = row[1].upper()

    # ---- mess: customers --------------------------------------------------
    for i, row in enumerate(customers):
        row[1] = add_whitespace(scramble_case(row[1], i), i)
        if i % 13 == 4:
            row[2] = ""                      # missing country
        if i % 17 == 9:
            row[4] = ""                      # missing payment terms
    # two near-duplicate customer records (same company, re-keyed)
    dup_a = list(customers[7]);  dup_a[0] = "C2900"
    dup_a[1] = dup_a[1].strip().upper()
    dup_b = list(customers[21]); dup_b[0] = "C2901"
    dup_b[1] = dup_b[1].strip().title() + " "
    customers.extend([dup_a, dup_b])

    # ---- mess: suppliers --------------------------------------------------
    for i, row in enumerate(suppliers):
        row[1] = add_whitespace(scramble_case(row[1], i + 2), i + 1)
        if i % 15 == 6:
            row[2] = ""
    suppliers.append(list(suppliers[3]))     # exact duplicate row

    # ---- mess: employees --------------------------------------------------
    for i, row in enumerate(employees):
        row[6] = messy_date(date.fromisoformat(row[6]), i)
        if row[7]:
            row[7] = messy_date(date.fromisoformat(row[7]), i + 1)
        if i % 9 == 2:
            row[3] = row[3].upper()
        if i % 19 == 7:
            row[5] = ""                      # employee with no cost centre

    # ---- mess: invoices ---------------------------------------------------
    invoice_rows = []
    for i, inv in enumerate(invoices):
        status = inv["status"]
        status = [status, status.title(), status.lower(), f"{status} "][i % 4]
        invoice_rows.append([
            inv["invoice_id"], inv["invoice_type"], inv["customer_id"],
            inv["supplier_id"], messy_date(inv["invoice_date"], i),
            inv["due_date"].isoformat(), inv["currency"],
            inv["net_amount"], inv["tax_amount"], inv["gross_amount"],
            inv["gross_amount_gbp"], inv["cost_centre_code"], status,
        ])
    # a credit note, and two invoices pointing at customers that do not exist
    cn = list(next(r for r in invoice_rows[40:] if r[1] == "SALES"))
    cn[0] = "SI-2022-90001"
    cn[7], cn[8], cn[9], cn[10] = -cn[7], -cn[8], -cn[9], -cn[10]
    cn[12] = "CREDITED"
    invoice_rows.append(cn)
    a_sale = next(r for r in invoice_rows[500:] if r[1] == "SALES")
    orphan = list(a_sale); orphan[0] = "SI-2023-90002"; orphan[2] = "C2999"
    invoice_rows.append(orphan)
    a_purchase = next(r for r in invoice_rows[900:] if r[1] == "PURCHASE")
    orphan2 = list(a_purchase); orphan2[0] = "PI-2023-90003"; orphan2[3] = "S3999"
    invoice_rows.append(orphan2)

    # ---- mess: payments ---------------------------------------------------
    payments.append(list(payments[100]))     # exact duplicate receipt
    payments.append(list(payments[250]))     # exact duplicate receipt
    dup = list(payments[600])                # same payment, different reference
    dup[0] = dup[0].replace("PAY-", "PAY-D")
    payments.append(dup)
    for i, row in enumerate(payments):
        if i % 23 == 5:
            row[7] = row[7].lower()          # method casing

    # ---- mess: unbalanced journals ---------------------------------------
    # Six journals where a line was fat-fingered. The header still says POSTED.
    by_journal: dict[str, list[list]] = {}
    for line in led.lines:
        by_journal.setdefault(line[1], []).append(line)
    general = [jid for jid, ls in by_journal.items() if len(ls) >= 2]
    for jid in rng.sample(sorted(general), 6):
        line = by_journal[jid][0]
        if line[7]:
            line[7] = money(line[7] * rng.choice([0.9, 1.1, 10.0]))
        else:
            line[8] = money(line[8] * rng.choice([0.9, 1.1, 0.1]))

    # a few journals left in draft
    for row in rng.sample(led.journals, 8):
        row[10] = "DRAFT"

    # missing cost centre on some GL lines
    for i, line in enumerate(led.lines):
        if i % 137 == 41:
            line[4] = ""
        if i % 211 == 17:
            line[6] = add_whitespace(line[6].upper(), i)

    # ---- write -----------------------------------------------------------
    write_csv("chart_of_accounts.csv",
              ["account_code", "account_name", "account_type",
               "report_section", "normal_balance", "is_active"], coa)

    write_csv("cost_centres.csv",
              ["cost_centre_code", "cost_centre_name", "region",
               "cost_centre_type"], [list(c) for c in COST_CENTRES])

    write_csv("employees.csv",
              ["employee_id", "first_name", "last_name", "email", "job_title",
               "cost_centre_code", "hire_date", "termination_date",
               "annual_salary_gbp"], employees)

    write_csv("customers.csv",
              ["customer_id", "customer_name", "country", "currency",
               "payment_terms_days", "credit_limit_gbp", "created_date",
               "cost_centre_code", "is_active"], customers)

    write_csv("suppliers.csv",
              ["supplier_id", "supplier_name", "country", "currency",
               "payment_terms_days", "created_date", "is_active"], suppliers)

    write_csv("fx_rates.csv",
              ["rate_date", "from_currency", "to_currency", "rate"], fx_rows)

    write_csv("journal_entries.csv",
              ["journal_id", "journal_date", "posted_date", "period",
               "fiscal_year", "fiscal_period", "source", "description",
               "prepared_by", "approved_by", "status"], led.journals)

    write_csv("general_ledger.csv",
              ["gl_id", "journal_id", "line_number", "account_code",
               "cost_centre_code", "entry_date", "line_description",
               "debit", "credit"], led.lines)

    write_csv("invoices.csv",
              ["invoice_id", "invoice_type", "customer_id", "supplier_id",
               "invoice_date", "due_date", "currency", "net_amount",
               "tax_amount", "gross_amount", "gross_amount_gbp",
               "cost_centre_code", "status"], invoice_rows)

    write_csv("payments.csv",
              ["payment_id", "invoice_id", "direction", "payment_date",
               "currency", "amount", "amount_gbp", "method",
               "bank_reference"], payments)

    write_csv("budgets.csv",
              ["budget_id", "fiscal_year", "fiscal_period", "account_code",
               "cost_centre_code", "budget_amount_gbp", "status", "version"],
              budgets)

    print(f"\nDone. {len(ar_open)} sales invoices remain unpaid at "
          f"{END.isoformat()} — that is the AR ageing population.")


if __name__ == "__main__":
    main()
