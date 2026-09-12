-- 01_foundations.sql
-- Foundational queries: WHERE, DISTINCT, ORDER BY + LIMIT, Alias (AS), IN, BETWEEN/NOT BETWEEN, IS NULL

-- 1. WHERE: orders placed by customers in a specific city (Bengaluru)
SELECT o.order_id, o.order_date, c.city, o.amount_inr
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.city = 'Bengaluru';

-- 2. DISTINCT: list every distinct product category
SELECT DISTINCT category
FROM products;

-- 3. ORDER BY + LIMIT: the 5 highest-value orders by amount_inr
SELECT order_id, customer_id, product_id, amount_inr
FROM orders
ORDER BY amount_inr DESC
LIMIT 5;

-- 4. Alias (AS): rename an aggregate/column in the output
SELECT COUNT(*) AS total_orders
FROM orders;

-- 5. IN: orders whose payment_mode is in a 2-mode list
SELECT order_id, payment_mode, amount_inr
FROM orders
WHERE payment_mode IN ('UPI', 'Credit Card');

-- 6. BETWEEN: orders with amount_inr within a stated range
SELECT order_id, amount_inr
FROM orders
WHERE amount_inr BETWEEN 500 AND 1000;

-- 6b. NOT BETWEEN: orders with amount_inr outside that same range
SELECT order_id, amount_inr
FROM orders
WHERE amount_inr NOT BETWEEN 500 AND 1000;

-- 7. IS NULL: orders with no rating recorded (Cancelled / Pending orders never receive a rating)
SELECT order_id, status, rating
FROM orders
WHERE rating IS NULL;
