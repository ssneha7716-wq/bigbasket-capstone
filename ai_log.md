# AI-Assisted Prompting Log

Two AI-assisted prompts were used in this project, each structured against the five RCTCF
elements (Role, Context, Task, Constraints, Format), as required by the brief.

---

## Prompt #1 — SQL (Part 1, Task 7)

**Used for:** drafting/debugging the derived-fields variance query in `03_reporting.sql`
(Task 5c) — specifically getting the percentage-variance formula right under SQLite's
integer-division rules.

**Exact prompt used:**

> **Role:** You are an experienced SQLite analyst helping me debug a reporting query.
> **Context:** I have a SQLite database with an `orders` table (amount_inr INTEGER,
> status TEXT), a `products` table (product_id, category), and a `category_targets`
> table (category TEXT PRIMARY KEY, target_revenue_inr INTEGER). I need to compute, per
> category, the total Delivered revenue, the variance against the category's target, and
> the variance as a percentage of the target.
> **Task:** Write a single SQL query that joins these three tables, filters to Delivered
> orders, groups by category, and returns category, total_revenue, target_revenue_inr,
> variance (target minus total), and percentage_variance (relative variance as a percent
> of target). Also flag any risk that the percentage calculation could be wrong given the
> column types.
> **Constraints:** SQLite only (no other SQL dialect). total_revenue and
> target_revenue_inr are both INTEGER columns. The query must run correctly in a single
> pass with GROUP BY, no subqueries required.
> **Format:** Return the SQL query only, followed by a one-sentence explanation of any
> gotcha you flagged.

**Verification step actually performed:** I ran the AI-suggested query against
`bigbasket_capstone.db` and manually checked the `percentage_variance` column for the
"Fruits & Vegetables" row. The AI's first draft wrote the formula as
`(total_revenue - target_revenue_inr) / target_revenue_inr * 100`, which — because
`total_revenue` and `target_revenue_inr` are both SQLite INTEGER columns — truncates the
division to an integer (0) before the `* 100` ever runs, silently producing 0 for every
row. I confirmed this by running that exact draft and seeing every `percentage_variance`
value come back as `0`. I then rewrote it as
`((total_revenue - target_revenue_inr) * 100.0) / target_revenue_inr` (multiplying by
`100.0` first) and re-ran it; Fruits & Vegetables correctly returned
`-18.416666666666668` instead of `0`, matching a manual hand-calculation of
`(9790 - 12000) / 12000 * 100`.

---

## Prompt #2 — Python/Pandas (Part 4, Task 10)

**Used for:** explaining/debugging the IQR outlier-capping logic in `analysis.ipynb`.

**Exact prompt used:**

> **Role:** You are a Python/pandas data-cleaning expert reviewing my outlier-handling
> code.
> **Context:** I have a pandas DataFrame `df_clean` with an `amount_inr` column and a
> `status` column (values include "Delivered", "Cancelled", "Pending"). I've computed
> Q1, Q3, IQR, and an upper_fence using only the Delivered, non-null amount_inr values.
> I now want to cap (not remove) any Delivered row's amount_inr above that fence, while
> leaving Cancelled/Pending rows completely untouched.
> **Task:** Show me the correct pandas code to do this capping, using `.clip()` where
> possible, and explain any common mistake that would accidentally also affect
> non-Delivered rows or silently drop rows instead of capping them.
> **Constraints:** Must not drop any rows. Must not modify amount_inr for
> Cancelled/Pending orders. Should work with a boolean mask combined with the fence
> value, not a manual loop.
> **Format:** Return the code, then a short bullet list of the mistakes it avoids.

**Verification step actually performed:** I ran the AI-suggested
`np.where(delivered_mask & (df_clean["amount_inr"] > upper_fence), upper_fence, df_clean["amount_inr"])`
line, then manually inspected 3 rows that I knew were pre-capping outliers (identified by
re-running `df_clean.loc[delivered_mask & (df_clean["amount_inr"] > 552.5)]` before
applying the fix) and confirmed all 3 now showed `amount_inr` equal to exactly `552.5`
(the upper fence) after the `.clip`-equivalent logic ran, while a Cancelled row I checked
with an original amount_inr of `1400` was unchanged. I also added the assertion
`assert (df_clean.loc[delivered_mask, "amount_inr"] <= upper_fence + 1e-9).all()` to the
notebook itself so this check runs every time the notebook is re-executed, not just once
by hand.
