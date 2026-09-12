# BigBasket Category Performance Diagnostic — SQL, Sheets, Tableau \& Python

A single, connected diagnostic proving the same monthly category revenue numbers survive
three reporting tools untouched (SQL → Spreadsheet → Tableau), plus an independent
Python/Pandas cleaning-and-cross-validation exercise starting from the raw, never-cleaned
order export.



**Live Tableau Public dashboard:** https://public.tableau.com/app/profile/sneha.rani5088/viz/BigBasketCategoryPerformanceDiagnostic\_17892538939280/Dashboard1



## Project overview

BigBasket's category management team sets a monthly revenue target for each of 6 product
categories. This repo builds one small, deterministic SQLite database and traces the same
monthly category-revenue numbers through a SQL diagnostic, a spreadsheet reconciliation,
and a Tableau Public dashboard — then separately cleans the raw, messy version of the same
underlying order data in Pandas and confirms it points to the same conclusions.

## Repo structure

```
generate\_data.py                 Part 1, Task 1 — builds bigbasket\_capstone.db + raw exports
bigbasket\_capstone.db             SQLite database (products, customers, orders, category\_targets)
orders\_raw.csv                    Deliberately messy raw order export (Part 4 input)
products.csv                      Raw product export (Part 4 input)
verify.sql                        Part 1, Task 2 — row-count / status-split verification queries
verify\_output.txt                 Actual results of running verify.sql
01\_foundations.sql                Part 1, Task 3 — WHERE, DISTINCT, ORDER BY+LIMIT, AS, IN, BETWEEN, IS NULL
02\_aggregation\_joins.sql          Part 1, Task 4 — INNER JOIN + HAVING, LEFT JOIN + COUNT
03\_reporting.sql                  Part 1, Task 5 — CASE WHEN tiering, monthly report, variance query
monthly\_category\_revenue.csv      Part 1, Task 6 — fixed export consumed by Parts 2 \& 3
bigbasket\_category\_diagnostic\_STARTER.xlsx   Part 2 starting point (Monthly Data + Category
                                   Targets pre-loaded; build the Pivot Table / XLOOKUP /
                                   Category Summary sheet in Google Sheets, then re-export
                                   as .xlsx and commit the final workbook)
analysis.ipynb                    Part 4 — Python/Pandas cleaning, analysis, cross-validation
ai\_log.md                         Both required RCTCF-structured AI-assisted prompts
DATA\_STORY.md                     Part 3, Task 7 — written interpretation + 2 recommendations
README.md                         This file
```

## How to regenerate the database and raw exports

```bash
python3 generate\_data.py
```

This is deterministic (`random.seed(42)`) — it always produces the same
`bigbasket\_capstone.db`, `orders\_raw.csv`, and `products.csv`. Do not re-run it with a
different seed or hand-edit any exported CSV.

## Part 1 — SQL Data Setup \& Diagnostic

* Run `verify.sql` (results captured in `verify\_output.txt`) to confirm 31 products, 50
customers, 500 orders, 6 category targets, and a Delivered/Cancelled/Pending status
split of 434/42/24.
* `01\_foundations.sql` — one labelled query for each of WHERE, DISTINCT, ORDER BY+LIMIT,
Alias (AS), IN, BETWEEN/NOT BETWEEN, and IS NULL.
* `02\_aggregation\_joins.sql` — an INNER JOIN + HAVING aggregation by category, and a LEFT
JOIN by product using `COUNT(o.order\_id)` so the one zero-order product (Premium Face
Cream 50g) correctly shows a count of 0.
* `03\_reporting.sql` — a 3-tier CASE WHEN revenue classification, the monthly
category-revenue report (exported to `monthly\_category\_revenue.csv`), and a
target-variance query with the floating-point-safe percentage formula.

## Part 2 — Spreadsheet Cross-Check (build this in Google Sheets)

Starting from `bigbasket\_category\_diagnostic\_STARTER.xlsx` (already has `Monthly Data` —
the unmodified `monthly\_category\_revenue.csv` import — and `Category Targets` filled in):

1. Upload the starter workbook to Google Sheets (File → Import → Upload).
2. Build a **Pivot Table** from `Monthly Data`: Rows = `category`, Values = `SUM` of
`total\_revenue` and `SUM` of `order\_count`.
3. On the `Category Summary` sheet, for each of the 6 categories add: the pivot-referenced
total revenue, an `XLOOKUP` (with a stated `if\_not\_found` default) pulling
`target\_revenue\_inr` from `Category Targets`, `variance = target\_revenue\_inr - total\_revenue`, `percentage\_variance = (total\_revenue - target\_revenue\_inr) / target\_revenue\_inr`, and a nested `IF` tagging each row `"Above Target"`, `"Below Target - Watch"` (shortfall within 15%), or `"Below Target - Critical"`.
4. Add the `Matches Part 1 SQL total?` column — compare each category's pivot total
against the reference SQL totals listed at the bottom of the `Category Summary` sheet
(Household Essentials 21715, Personal Care 16382, Bakery 15410, Dairy \& Eggs 14090,
Snacks \& Beverages 10895, Fruits \& Vegetables 9790) and mark `Yes` only on an exact
match.
5. Apply conditional formatting to the tag column (green / amber / red).
6. **File → Download → Microsoft Excel (.xlsx)** and commit that file to this repo,
replacing/renaming the starter file.

## Part 3 — Tableau Public Dashboard \& Data Story

1. In Tableau Public, connect to `monthly\_category\_revenue.csv`.
2. Build: a monthly time-series chart (all 6 categories combined), a category revenue bar
chart (sorted descending, colored by tier — see `DATA\_STORY.md` for each category's
tier), 4 KPI cards (Total Revenue, Total Delivered Orders, Average Order Value,
Categories Meeting Target), and at least one dashboard-wide filter.
3. Combine everything into one Dashboard, publish it (Server → Publish), set sharing to
public, and paste the live URL at the top of this README.
4. The written data story and two concrete recommendations are in `DATA\_STORY.md`.

## Part 4 — Python/Pandas Cleaning, Analysis \& Cross-Validation

Open `analysis.ipynb`. It loads `orders\_raw.csv` (508 rows, including 8 duplicates),
independently cleans it (deduplicates to 500 rows, fixes casing/whitespace to 4 cities /
6 categories, excludes 10 rows with missing `amount\_inr` from revenue calculations,
IQR-caps 16 Delivered outlier rows), and confirms its own top category (**Household
Essentials**) and top supplier (**HomeEssentials Traders**) match Part 1's SQL findings —
even though the exact rupee totals differ because Part 4 started from dirtier data.

## AI-assisted prompting log

Both required RCTCF-structured prompts (one for the SQL variance query, one for the
Pandas outlier-capping logic), each with the concrete verification step actually
performed, are in `ai\_log.md`.

