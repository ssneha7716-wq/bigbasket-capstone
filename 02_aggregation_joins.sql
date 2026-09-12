-- 02_aggregation_joins.sql
-- Aggregation, JOIN, and HAVING queries

-- (a) INNER JOIN orders -> products, GROUP BY category, for Delivered orders only,
--     with a HAVING total_revenue > 10000 filter.
SELECT
    p.category,
    COUNT(*) AS order_count,
    SUM(o.amount_inr) AS total_revenue,
    AVG(o.amount_inr) AS avg_revenue
FROM orders o
INNER JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY p.category
HAVING total_revenue > 10000;

-- (b) LEFT JOIN products -> orders, GROUP BY product, counting total orders per product.
--     Uses COUNT(o.order_id) -- NOT COUNT(*) -- so the unmatched (all-NULL) row for a
--     product with zero orders correctly counts as 0, not 1.
--     Ordered ascending to surface the least-ordered products first.
--     Exactly one product ("Premium Face Cream 50g") has zero orders and must appear
--     with a count of 0.
SELECT
    p.product_id,
    p.product_name,
    COUNT(o.order_id) AS order_count
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY order_count ASC;
