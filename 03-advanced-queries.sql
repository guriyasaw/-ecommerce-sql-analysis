-- ============================================
-- Advanced SQL Queries (Q15 to Q20)
-- ============================================

USE ecommerce_db;

-- Q15: Rank products by revenue (Window Function)
SELECT 
  p.ProductName,
  ROUND(SUM(o.TotalPrice), 2) AS total_revenue,
  RANK() OVER (ORDER BY SUM(o.TotalPrice) DESC) AS revenue_rank
FROM orders o
JOIN products p ON o.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY revenue_rank;

-- Q16: Running total of revenue (CTE + Window Function)
WITH monthly AS (
  SELECT 
    DATE_FORMAT(OrderDate, '%Y-%m') AS month,
    ROUND(SUM(TotalPrice), 2) AS monthly_revenue
  FROM orders
  GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
)
SELECT 
  month,
  monthly_revenue,
  ROUND(SUM(monthly_revenue) OVER (ORDER BY month), 2) AS running_total
FROM monthly
ORDER BY month;

-- Q17: Customers with only cancelled orders
SELECT CustomerID, COUNT(*) AS total_orders
FROM orders
GROUP BY CustomerID
HAVING SUM(CASE WHEN OrderStatus != 'Cancelled' THEN 1 ELSE 0 END) = 0
ORDER BY total_orders DESC;

-- Q18: Month-over-month revenue growth (LAG)
WITH monthly AS (
  SELECT 
    DATE_FORMAT(OrderDate, '%Y-%m') AS month,
    ROUND(SUM(TotalPrice), 2) AS revenue
  FROM orders
  GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
)
SELECT 
  month,
  revenue,
  LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
  ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 / 
        LAG(revenue) OVER (ORDER BY month), 2) AS growth_pct
FROM monthly
ORDER BY month;

-- Q19: Customer spend percentile ranking
SELECT 
  CustomerID,
  ROUND(SUM(TotalPrice), 2) AS total_spent,
  ROUND(PERCENT_RANK() OVER (ORDER BY SUM(TotalPrice)) * 100, 1) AS spend_percentile,
  NTILE(4) OVER (ORDER BY SUM(TotalPrice)) AS quartile
FROM orders
GROUP BY CustomerID
ORDER BY total_spent DESC;

-- Q20: Full business summary dashboard query
SELECT 
  p.ProductName,
  c.ReferralSource,
  COUNT(o.OrderID) AS total_orders,
  ROUND(SUM(o.TotalPrice), 2) AS total_revenue,
  ROUND(AVG(o.TotalPrice), 2) AS avg_order_value,
  SUM(CASE WHEN o.OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) AS cancellations,
  RANK() OVER (PARTITION BY c.ReferralSource ORDER BY SUM(o.TotalPrice) DESC) AS rank_in_channel
FROM orders o
JOIN products p ON o.ProductID = p.ProductID
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY p.ProductName, c.ReferralSource
ORDER BY total_revenue DESC;