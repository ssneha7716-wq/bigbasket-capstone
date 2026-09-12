-- verify.sql
-- Verification results (run via: python3 -c "import sqlite3; ..." or any SQLite client)
--
-- SELECT COUNT(*) FROM products;         -> 31
-- SELECT COUNT(*) FROM customers;        -> 50
-- SELECT COUNT(*) FROM orders;           -> 500
-- SELECT COUNT(*) FROM category_targets; -> 6
-- SELECT status, COUNT(*) FROM orders GROUP BY status;
--   Delivered  -> 434
--   Cancelled  -> 42
--   Pending    -> 24

SELECT COUNT(*) AS product_count FROM products;
SELECT COUNT(*) AS customer_count FROM customers;
SELECT COUNT(*) AS order_count FROM orders;
SELECT COUNT(*) AS category_target_count FROM category_targets;

SELECT status, COUNT(*) AS n
FROM orders
GROUP BY status;
