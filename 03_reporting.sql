-- 03_reporting.sql
-- CASE WHEN tiering, date-based monthly report, and derived-fields (variance) queries

-- (a) Tier every product by its total Delivered revenue.
SELECT
    p.product_id,
    p.product_name,
    SUM(o.amount_inr) AS total_revenue,
    CASE
        WHEN SUM(o.amount_inr) >= 3000 THEN 'High'
        WHEN SUM(o.amount_inr) >= 1000 THEN 'Medium'
        ELSE 'Low'
    END AS revenue_tier
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY p.product_id, p.product_name;

-- (b) Monthly-by-category business report (Delivered orders only).
--     Columns: category, month, order_count, total_revenue, avg_revenue
--     This is the exact query whose result set is exported to
--     monthly_category_revenue.csv (Task 6) and consumed by Parts 2 and 3.
SELECT
    p.category AS category,
    strftime('%Y-%m', o.order_date) AS month,
    COUNT(*) AS order_count,
    SUM(o.amount_inr) AS total_revenue,
    AVG(o.amount_inr) AS avg_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY p.category, strftime('%Y-%m', o.order_date)
ORDER BY p.category, month;

-- (c) Derived-fields query: category-level total Delivered revenue joined against
--     category_targets, with variance and percentage_variance.
--     SQLite integer-division note: total_revenue and target_revenue_inr are both
--     INTEGER columns, so (total_revenue - target_revenue_inr) / target_revenue_inr
--     alone would truncate to an integer (almost always 0) before *100.0 ever runs.
--     The formula below multiplies by 100.0 first, so the true percentage comes
--     through instead of a truncated 0.
SELECT
    p.category AS category,
    SUM(o.amount_inr) AS total_revenue,
    ct.target_revenue_inr AS target_revenue_inr,
    (ct.target_revenue_inr - SUM(o.amount_inr)) AS variance,
    ((SUM(o.amount_inr) - ct.target_revenue_inr) * 100.0) / ct.target_revenue_inr AS percentage_variance,
    CASE
        WHEN SUM(o.amount_inr) >= ct.target_revenue_inr THEN 'Above Target'
        WHEN ((ct.target_revenue_inr - SUM(o.amount_inr)) * 100.0) / ct.target_revenue_inr <= 15 THEN 'Below Target - Watch'
        ELSE 'Below Target - Critical'
    END AS status_tag
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN category_targets ct ON p.category = ct.category
WHERE o.status = 'Delivered'
GROUP BY p.category, ct.target_revenue_inr
ORDER BY p.category;
