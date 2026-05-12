-- ============================================
-- Intermediate SQL Queries (Q8 to Q14)
-- ============================================

USE ecommerce_db;

-- Q8: Total revenue per product (JOIN)
SELECT 
  p.ProductName,
  COUNT(o.OrderID) AS total_orders,
  SUM(o.TotalPrice) AS total_revenue
FROM orders o
JOIN products p ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY total_revenue DESC;

-- Q9: Referral source with highest revenue
SELECT 
  c.ReferralSource,
  COUNT(o.OrderID) AS total_orders,
  ROUND(SUM(o.TotalPrice), 2) AS total_revenue
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY c.ReferralSource
ORDER BY total_revenue DESC;

-- Q10: Monthly revenue trend
SELECT 
  DATE_FORMAT(OrderDate, '%Y-%m') AS month,
  COUNT(*) AS total_orders,
  ROUND(SUM(TotalPrice), 2) AS monthly_revenue
FROM orders
GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
ORDER BY month ASC;

-- Q11: Cancellation rate per product
SELECT 
  p.ProductName,
  COUNT(*) AS total_orders,
  SUM(CASE WHEN o.OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled,
  ROUND(SUM(CASE WHEN o.OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS cancel_rate_pct
FROM orders o
JOIN products p ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY cancel_rate_pct DESC;

-- Q12: Top 10 highest spending customers
SELECT 
  o.CustomerID,
  COUNT(o.OrderID) AS total_orders,
  ROUND(SUM(o.TotalPrice), 2) AS lifetime_value
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY o.CustomerID
ORDER BY lifetime_value DESC
LIMIT 10;

-- Q13: Coupon vs no coupon revenue comparison
SELECT 
  CASE WHEN CouponCode IS NULL THEN 'No Coupon' ELSE 'Used Coupon' END AS coupon_used,
  COUNT(*) AS total_orders,
  ROUND(AVG(TotalPrice), 2) AS avg_order_value,
  ROUND(SUM(TotalPrice), 2) AS total_revenue
FROM orders
GROUP BY coupon_used;

-- Q14: Customers with more than 1 order
SELECT 
  CustomerID,
  COUNT(OrderID) AS order_count,
  ROUND(SUM(TotalPrice), 2) AS total_spent
FROM orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 1
ORDER BY order_count DESC;