-- 04_Aggregate_Functions.sql
-- ======================================
-- LESSON: SQL Aggregate Functions
-- Aggregate functions are used to perform calculations
-- on a set of values and return a single value.

-- Common aggregate functions:
-- COUNT() - counts rows
-- SUM()   - adds values
-- AVG()   - calculates average
-- MIN()   - finds the smallest value
-- MAX()   - finds the largest value

-- ======================================
-- Example Table: sales
-- id | product  | quantity | price | sale_date
--  1 | Apple    |    10    |  2.5  | 2025-09-01
--  2 | Orange   |    5     |  3.0  | 2025-09-01
--  3 | Apple    |    7     |  2.5  | 2025-09-02
--  4 | Banana   |    8     |  1.5  | 2025-09-02
--  5 | Orange   |    12    |  3.0  | 2025-09-03

-- ======================================
-- 1. COUNT: Count total number of sales records
SELECT COUNT(*) AS total_sales
FROM sales;

-- 2. SUM: Total quantity sold
SELECT SUM(quantity) AS total_quantity
FROM sales;

-- 3. AVG: Average quantity sold
SELECT AVG(quantity) AS avg_quantity
FROM sales;

-- 4. MIN & MAX: Smallest and largest quantity sold
SELECT MIN(quantity) AS smallest_quantity,
       MAX(quantity) AS largest_quantity
FROM sales;

-- ======================================
-- 5. Using GROUP BY with aggregate functions
-- Example: total quantity sold per product
SELECT product, SUM(quantity) AS total_quantity
FROM sales
GROUP BY product;

-- 6. COUNT with GROUP BY
-- How many sales records per product
SELECT product, COUNT(*) AS sales_count
FROM sales
GROUP BY product;

-- 7. AVG with GROUP BY
-- Average quantity per product
SELECT product, AVG(quantity) AS avg_quantity
FROM sales
GROUP BY product;

-- ======================================
-- 8. Filtering groups with HAVING
-- Show only products with total quantity > 15
SELECT product, SUM(quantity) AS total_quantity
FROM sales
GROUP BY product
HAVING SUM(quantity) > 15;

-- ======================================
-- PRACTICE QUESTIONS
-- 1. Find the total sales revenue (quantity * price).
-- 2. Find the average price of all products.
-- 3. Show the product with the maximum quantity sold in one sale.
-- 4. Find how many different days sales were recorded.
-- 5. Show products where the average quantity sold is less than 8.

-- ======================================
-- END OF LESSON
