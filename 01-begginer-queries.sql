-- ============================================
-- Beginner SQL Queries (Q1 to Q7)
-- ============================================
-- Project: E-Commerce Sales Analysis
-- Description: 7 beginner queries covering SELECT, WHERE, 
--              GROUP BY, ORDER BY, NULL handling, and aggregations
-- Skills: SELECT, WHERE, COUNT, SUM, AVG, IS NOT NULL, LIMIT

USE ecommerce_db;

-- Q1: List all orders with status and total price
SELECT OrderID, OrderStatus, TotalPrice
FROM orders
ORDER BY TotalPrice DESC;

-- Q2: Find all delivered orders
SELECT OrderID, CustomerID, OrderDate, TotalPrice
FROM orders
WHERE OrderStatus = 'Delivered'
ORDER BY OrderDate DESC;

-- Q3: Count total orders per status
SELECT OrderStatus, COUNT(*) AS total_orders
FROM orders
GROUP BY OrderStatus
ORDER BY total_orders DESC;

-- Q4: Top 5 most expensive orders
SELECT OrderID, CustomerID, TotalPrice, OrderStatus
FROM orders
ORDER BY TotalPrice DESC
LIMIT 5;

-- Q5: Orders where coupon was used
SELECT OrderID, CustomerID, CouponCode, TotalPrice
FROM orders
WHERE CouponCode IS NOT NULL
ORDER BY TotalPrice DESC;

-- Q6: Total revenue summary
SELECT 
  ROUND(SUM(TotalPrice), 2) AS total_revenue,
  COUNT(*) AS total_orders,
  ROUND(AVG(TotalPrice), 2) AS avg_order_value
FROM orders;

-- Q7: Payment method usage count
SELECT DISTINCT PaymentMethod, COUNT(*) AS usage_count
FROM customers
GROUP BY PaymentMethod
ORDER BY usage_count DESC;
