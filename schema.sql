-- ============================================
-- E-Commerce Database Schema
-- Author: Guriya shaw
-- ============================================
-- Project: E-Commerce Sales Analysis
-- Description: Creates normalized 3-table MySQL database
--              (customers, products, orders) with foreign key relationships

CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- Customers Table
CREATE TABLE IF NOT EXISTS customers (
    CustomerID VARCHAR(10) PRIMARY KEY,
    ShippingAddress VARCHAR(100),
    ReferralSource VARCHAR(50),
    PaymentMethod VARCHAR(50)
);

-- Products Table
CREATE TABLE IF NOT EXISTS products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100),
    AvgUnitPrice DECIMAL(10,2)
);

-- Orders Table
CREATE TABLE IF NOT EXISTS orders (
    OrderID VARCHAR(15) PRIMARY KEY,
    CustomerID VARCHAR(10),
    ProductID INT,
    OrderDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    TotalPrice DECIMAL(10,2),
    OrderStatus VARCHAR(20),
    TrackingNumber VARCHAR(20),
    ItemsInCart INT,
    CouponCode VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);
