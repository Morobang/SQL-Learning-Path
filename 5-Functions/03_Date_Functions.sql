-- =========================================
-- 03_Date_Functions.sql
-- Beginner-Friendly SQL Date Functions Tutorial
-- =========================================

-- 🎯 In this script, we will learn how to:
-- 1. Get the current date and time
-- 2. Extract parts of a date (year, month, day)
-- 3. Add or subtract time intervals
-- 4. Format dates
-- 5. Use practical examples

-- NOTE: Different SQL dialects (MySQL, SQL Server, PostgreSQL, Oracle) 
-- have slightly different date functions. Below we show examples in ANSI SQL style 
-- and mention differences where needed.

------------------------------------------------
-- 1. Current Date and Time
------------------------------------------------
-- MySQL & PostgreSQL
SELECT CURRENT_DATE;         -- only the date
SELECT CURRENT_TIME;         -- only the time
SELECT CURRENT_TIMESTAMP;    -- date + time

-- SQL Server
SELECT GETDATE();            -- date + time

------------------------------------------------
-- 2. Extracting Parts of a Date
------------------------------------------------
-- Example: Extract year, month, and day from a date column called order_date

-- MySQL & PostgreSQL
SELECT
  EXTRACT(YEAR FROM order_date) AS order_year,
  EXTRACT(MONTH FROM order_date) AS order_month,
  EXTRACT(DAY FROM order_date) AS order_day
FROM orders;

-- SQL Server
SELECT
  YEAR(order_date) AS order_year,
  MONTH(order_date) AS order_month,
  DAY(order_date) AS order_day
FROM orders;

------------------------------------------------
-- 3. Date Arithmetic
------------------------------------------------
-- Adding and subtracting days
-- MySQL
SELECT order_date, order_date + INTERVAL 7 DAY AS one_week_later
FROM orders;

-- PostgreSQL
SELECT order_date, order_date + INTERVAL '7 days' AS one_week_later
FROM orders;

-- SQL Server
SELECT order_date, DATEADD(DAY, 7, order_date) AS one_week_later
FROM orders;

------------------------------------------------
-- 4. Date Difference
------------------------------------------------
-- MySQL
SELECT DATEDIFF(CURDATE(), order_date) AS days_passed
FROM orders;

-- PostgreSQL
SELECT CURRENT_DATE - order_date AS days_passed
FROM orders;

-- SQL Server
SELECT DATEDIFF(DAY, order_date, GETDATE()) AS days_passed
FROM orders;

------------------------------------------------
-- 5. Formatting Dates
------------------------------------------------
-- MySQL
SELECT DATE_FORMAT(order_date, '%Y-%m-%d') AS formatted_date
FROM orders;

-- PostgreSQL
SELECT TO_CHAR(order_date, 'YYYY-MM-DD') AS formatted_date
FROM orders;

-- SQL Server
SELECT FORMAT(order_date, 'yyyy-MM-dd') AS formatted_date
FROM orders;

------------------------------------------------
-- 6. Practical Example
------------------------------------------------
-- Find number of orders placed in each year
-- Works in most SQL dialects
SELECT EXTRACT(YEAR FROM order_date) AS order_year, COUNT(*) AS total_orders
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY order_year;

-- Find customers whose orders are older than 30 days
-- MySQL example
SELECT customer_id, order_date
FROM orders
WHERE order_date < (CURDATE() - INTERVAL 30 DAY);

------------------------------------------------
-- ✅ Key Takeaways
-- - Use CURRENT_DATE / GETDATE() to get today’s date.
-- - Use EXTRACT() or YEAR(), MONTH(), DAY() to get date parts.
-- - Use INTERVAL or DATEADD() to add/subtract time.
-- - Use DATEDIFF to calculate difference between dates.
-- - Use formatting functions (DATE_FORMAT, TO_CHAR, FORMAT) to display dates neatly.
------------------------------------------------