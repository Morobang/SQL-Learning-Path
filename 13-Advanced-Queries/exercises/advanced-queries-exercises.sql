/*
===============================================
    ADVANCED SQL QUERIES EXERCISES
    Practice with Window Functions, LEAD/LAG, PIVOT/UNPIVOT, Partitioning, and Advanced Filtering
===============================================
*/

-- ============================================
-- SETUP: Create Database for Advanced Query Practice
-- ============================================

DROP DATABASE IF EXISTS advanced_queries_practice;
CREATE DATABASE advanced_queries_practice;
USE advanced_queries_practice;

-- Create comprehensive dataset for advanced query practice
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    hire_date DATE,
    department VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    manager_id INT,
    region VARCHAR(30),
    performance_rating DECIMAL(3,2),
    commission_rate DECIMAL(4,3)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    employee_id INT,
    customer_id INT,
    product_id INT,
    sale_date DATE,
    quantity INT,
    unit_price DECIMAL(10,2),
    discount_percent DECIMAL(5,2),
    total_amount DECIMAL(12,2),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    cost DECIMAL(10,2),
    price DECIMAL(10,2)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    customer_type ENUM('individual', 'business'),
    registration_date DATE
);

-- Insert sample data
INSERT INTO employees VALUES
(1, 'John', 'Smith', 'john.smith@company.com', '2020-01-15', 'Sales', 'Sales Manager', 85000.00, NULL, 'North', 4.2, 0.05),
(2, 'Jane', 'Doe', 'jane.doe@company.com', '2020-03-10', 'Sales', 'Sales Rep', 55000.00, 1, 'North', 4.0, 0.03),
(3, 'Bob', 'Wilson', 'bob.wilson@company.com', '2019-06-20', 'Sales', 'Sales Rep', 52000.00, 1, 'North', 3.8, 0.03),
(4, 'Alice', 'Johnson', 'alice.johnson@company.com', '2021-02-01', 'Marketing', 'Marketing Manager', 78000.00, NULL, 'South', 4.5, 0.02),
(5, 'Carol', 'Brown', 'carol.brown@company.com', '2021-04-15', 'Marketing', 'Marketing Specialist', 48000.00, 4, 'South', 3.9, 0.01),
(6, 'David', 'Davis', 'david.davis@company.com', '2018-11-30', 'IT', 'IT Manager', 95000.00, NULL, 'East', 4.1, 0.00),
(7, 'Eve', 'Miller', 'eve.miller@company.com', '2019-09-12', 'IT', 'Developer', 72000.00, 6, 'East', 4.3, 0.00),
(8, 'Frank', 'Garcia', 'frank.garcia@company.com', '2022-01-10', 'Sales', 'Sales Rep', 50000.00, 1, 'West', 3.7, 0.03),
(9, 'Grace', 'Rodriguez', 'grace.rodriguez@company.com', '2020-08-25', 'Finance', 'Financial Analyst', 65000.00, NULL, 'West', 4.0, 0.00),
(10, 'Henry', 'Martinez', 'henry.martinez@company.com', '2021-07-18', 'HR', 'HR Specialist', 58000.00, NULL, 'Central', 3.8, 0.00);

INSERT INTO products VALUES
(1, 'Laptop Pro', 'Electronics', 'Computers', 800.00, 1200.00),
(2, 'Smartphone X', 'Electronics', 'Mobile', 400.00, 699.99),
(3, 'Tablet Plus', 'Electronics', 'Mobile', 300.00, 499.99),
(4, 'Office Chair', 'Furniture', 'Seating', 150.00, 299.99),
(5, 'Standing Desk', 'Furniture', 'Desks', 400.00, 799.99),
(6, 'Wireless Mouse', 'Electronics', 'Accessories', 20.00, 49.99),
(7, 'Keyboard Pro', 'Electronics', 'Accessories', 50.00, 129.99),
(8, 'Monitor 27"', 'Electronics', 'Displays', 200.00, 399.99),
(9, 'Bookshelf', 'Furniture', 'Storage', 80.00, 199.99),
(10, 'Conference Table', 'Furniture', 'Tables', 600.00, 1299.99);

INSERT INTO customers VALUES
(1, 'TechCorp Inc', 'New York', 'NY', 'USA', 'business', '2019-05-15'),
(2, 'StartupXYZ', 'San Francisco', 'CA', 'USA', 'business', '2020-01-20'),
(3, 'John Consumer', 'Chicago', 'IL', 'USA', 'individual', '2020-06-10'),
(4, 'MegaCorp Ltd', 'London', '', 'UK', 'business', '2018-12-01'),
(5, 'Jane Personal', 'Toronto', 'ON', 'Canada', 'individual', '2021-03-15'),
(6, 'SmallBiz Co', 'Austin', 'TX', 'USA', 'business', '2021-08-22'),
(7, 'Bob Individual', 'Seattle', 'WA', 'USA', 'individual', '2019-11-30'),
(8, 'Enterprise Solutions', 'Boston', 'MA', 'USA', 'business', '2017-04-10'),
(9, 'Alice Buyer', 'Miami', 'FL', 'USA', 'individual', '2022-01-05'),
(10, 'Global Corp', 'Sydney', '', 'Australia', 'business', '2020-09-18');

INSERT INTO sales VALUES
(1, 2, 1, 1, '2024-01-15', 5, 1200.00, 10.0, 5400.00),
(2, 2, 1, 6, '2024-01-15', 10, 49.99, 5.0, 474.91),
(3, 3, 2, 2, '2024-01-16', 3, 699.99, 0.0, 2099.97),
(4, 8, 3, 4, '2024-01-17', 1, 299.99, 0.0, 299.99),
(5, 2, 4, 1, '2024-01-18', 10, 1200.00, 15.0, 10200.00),
(6, 3, 5, 3, '2024-01-19', 2, 499.99, 5.0, 949.98),
(7, 8, 6, 5, '2024-01-20', 1, 799.99, 0.0, 799.99),
(8, 2, 7, 7, '2024-01-21', 3, 129.99, 0.0, 389.97),
(9, 3, 8, 8, '2024-01-22', 2, 399.99, 10.0, 719.98),
(10, 8, 9, 9, '2024-01-23', 1, 199.99, 0.0, 199.99),
(11, 2, 10, 10, '2024-01-24', 1, 1299.99, 5.0, 1234.99),
(12, 3, 1, 2, '2024-01-25', 2, 699.99, 0.0, 1399.98),
(13, 8, 2, 3, '2024-01-26', 1, 499.99, 0.0, 499.99),
(14, 2, 3, 4, '2024-01-27', 2, 299.99, 0.0, 599.98),
(15, 3, 4, 5, '2024-01-28', 1, 799.99, 10.0, 719.99),
(16, 8, 5, 6, '2024-01-29', 5, 49.99, 0.0, 249.95),
(17, 2, 6, 7, '2024-01-30', 2, 129.99, 5.0, 246.98),
(18, 3, 7, 8, '2024-01-31', 1, 399.99, 0.0, 399.99),
(19, 8, 8, 9, '2024-02-01', 3, 199.99, 5.0, 569.97),
(20, 2, 9, 10, '2024-02-02', 1, 1299.99, 0.0, 1299.99);

-- ============================================
-- EXERCISE 1: Window Functions Basics
-- ============================================

/*
TASK 1.1: Ranking Functions
Write queries using ROW_NUMBER(), RANK(), and DENSE_RANK() to analyze employee salaries:

a) Rank all employees by salary (highest to lowest)
b) Rank employees within each department by salary
c) Show the difference between RANK() and DENSE_RANK() when there are ties
*/

-- YOUR ANSWER for 1.1a:


-- YOUR ANSWER for 1.1b:


-- YOUR ANSWER for 1.1c:


/*
TASK 1.2: Aggregate Window Functions
Use aggregate window functions to calculate:

a) Running total of salaries ordered by hire_date
b) Moving average of salaries (3-employee window)
c) Percentage of each employee's salary relative to department total
*/

-- YOUR ANSWER for 1.2a:


-- YOUR ANSWER for 1.2b:


-- YOUR ANSWER for 1.2c:


/*
TASK 1.3: Value Window Functions
Use FIRST_VALUE(), LAST_VALUE(), and NTH_VALUE() to:

a) Show each employee with the highest paid person in their department
b) Show each employee with the most recently hired person in their department
c) Show the 2nd highest salary in each department
*/

-- YOUR ANSWER for 1.3a:


-- YOUR ANSWER for 1.3b:


-- YOUR ANSWER for 1.3c:


-- ============================================
-- EXERCISE 2: LEAD and LAG Functions
-- ============================================

/*
TASK 2.1: Sales Trend Analysis
Using the sales data, create queries with LEAD and LAG to:

a) Compare each sale with the previous sale by the same employee
b) Calculate the difference in days between consecutive sales
c) Show sales growth/decline trends for each employee
*/

-- YOUR ANSWER for 2.1a:


-- YOUR ANSWER for 2.1b:


-- YOUR ANSWER for 2.1c:


/*
TASK 2.2: Employee Progression Analysis
Analyze employee salary progression:

a) Show each employee's previous and next salary (simulate salary changes by hire_date)
b) Calculate salary change percentage compared to previous employee hired
c) Identify gaps in hiring dates
*/

-- YOUR ANSWER for 2.2a:


-- YOUR ANSWER for 2.2b:


-- YOUR ANSWER for 2.2c:


/*
TASK 2.3: Advanced LEAD/LAG with Multiple Offsets
Create queries that:

a) Compare current sales with sales from 2 periods ago and 2 periods ahead
b) Calculate a 3-period moving average using LAG
c) Find the maximum sale in the next 3 sales for each employee
*/

-- YOUR ANSWER for 2.3a:


-- YOUR ANSWER for 2.3b:


-- YOUR ANSWER for 2.3c:


-- ============================================
-- EXERCISE 3: Advanced Filtering
-- ============================================

/*
TASK 3.1: Complex WHERE Conditions
Write queries with advanced filtering:

a) Find employees whose salary is above the department average
b) Find customers who have made purchases in multiple product categories
c) Find employees who have sales in consecutive months
*/

-- YOUR ANSWER for 3.1a:


-- YOUR ANSWER for 3.1b:


-- YOUR ANSWER for 3.1c:


/*
TASK 3.2: Correlated Subqueries in Filtering
Use correlated subqueries to:

a) Find employees who earn more than their manager
b) Find products that have never been sold
c) Find top 3 customers by total purchase amount in each country
*/

-- YOUR ANSWER for 3.2a:


-- YOUR ANSWER for 3.2b:


-- YOUR ANSWER for 3.2c:


/*
TASK 3.3: Advanced Filtering with EXISTS and NOT EXISTS
Create queries using EXISTS/NOT EXISTS:

a) Find customers who have purchased both Electronics and Furniture
b) Find employees who have made sales but no sales above $1000
c) Find products that have been sold to business customers but not individuals
*/

-- YOUR ANSWER for 3.3a:


-- YOUR ANSWER for 3.3b:


-- YOUR ANSWER for 3.3c:


-- ============================================
-- EXERCISE 4: PIVOT and UNPIVOT Operations
-- ============================================

/*
TASK 4.1: Basic PIVOT Operations
Create pivot tables to show:

a) Total sales by employee (rows) and product category (columns)
b) Employee count by department (rows) and region (columns)
c) Average salary by department and performance rating ranges
*/

-- YOUR ANSWER for 4.1a (using conditional aggregation if PIVOT not available):


-- YOUR ANSWER for 4.1b:


-- YOUR ANSWER for 4.1c:


/*
TASK 4.2: Dynamic PIVOT with Multiple Aggregates
Create more complex pivot operations:

a) Show both COUNT and SUM of sales by employee and month
b) Pivot sales data showing quantity and revenue by product and customer type
c) Create a pivot showing min, max, and avg salary by department and region
*/

-- YOUR ANSWER for 4.2a:


-- YOUR ANSWER for 4.2b:


-- YOUR ANSWER for 4.2c:


/*
TASK 4.3: UNPIVOT Operations
If your database supports UNPIVOT, or simulate with UNION:

a) Convert department salary summary from columns to rows
b) Transform product pricing data from wide to long format
c) Unpivot quarterly sales data into monthly format
*/

-- YOUR ANSWER for 4.3a:


-- YOUR ANSWER for 4.3b:


-- YOUR ANSWER for 4.3c:


-- ============================================
-- EXERCISE 5: Partitioning and Frame Specifications
-- ============================================

/*
TASK 5.1: Custom Window Frames
Use different frame specifications with window functions:

a) Calculate running total with UNBOUNDED PRECEDING
b) Calculate centered moving average using ROWS BETWEEN
c) Calculate cumulative distribution using RANGE BETWEEN
*/

-- YOUR ANSWER for 5.1a:


-- YOUR ANSWER for 5.1b:


-- YOUR ANSWER for 5.1c:


/*
TASK 5.2: Complex Partitioning
Create queries with sophisticated partitioning:

a) Rank sales within each employee-month combination
b) Calculate percentiles within department and region combinations
c) Compare each sale to department average for that month
*/

-- YOUR ANSWER for 5.2a:


-- YOUR ANSWER for 5.2b:


-- YOUR ANSWER for 5.2c:


/*
TASK 5.3: Advanced Frame Specifications
Work with advanced frame specifications:

a) Calculate the sum of current and next 2 rows
b) Find the maximum value in a sliding window of 5 rows
c) Calculate weighted moving average using different frame sizes
*/

-- YOUR ANSWER for 5.3a:


-- YOUR ANSWER for 5.3b:


-- YOUR ANSWER for 5.3c:


-- ============================================
-- EXERCISE 6: Combining Advanced Techniques
-- ============================================

/*
TASK 6.1: Multi-Window Function Queries
Combine multiple window functions in single queries:

a) Show employee rank, running total, and percentage of total for salary
b) Display sales with rank, lag, and moving average
c) Create a comprehensive employee performance dashboard query
*/

-- YOUR ANSWER for 6.1a:


-- YOUR ANSWER for 6.1b:


-- YOUR ANSWER for 6.1c:


/*
TASK 6.2: Window Functions with CTEs
Use Common Table Expressions with window functions:

a) Create a CTE with ranked employees, then find those in top 25%
b) Use recursive CTE to build employee hierarchy with window functions
c) Chain multiple CTEs each adding different window function results
*/

-- YOUR ANSWER for 6.2a:


-- YOUR ANSWER for 6.2b:


-- YOUR ANSWER for 6.2c:


/*
TASK 6.3: Advanced Analytical Queries
Create complex analytical queries:

a) Customer lifetime value calculation with window functions
b) Sales performance trend analysis with multiple metrics
c) Product performance analysis with ranking and comparisons
*/

-- YOUR ANSWER for 6.3a:


-- YOUR ANSWER for 6.3b:


-- YOUR ANSWER for 6.3c:


-- ============================================
-- EXERCISE 7: Performance and Optimization
-- ============================================

/*
TASK 7.1: Query Optimization
Optimize these queries for better performance:

a) Rewrite correlated subquery using window functions
b) Optimize multiple separate aggregations using window functions
c) Improve filtering with window functions instead of subqueries
*/

-- Slow query example:
SELECT e1.employee_id, e1.salary,
       (SELECT AVG(e2.salary) FROM employees e2 WHERE e2.department = e1.department) as dept_avg
FROM employees e1;

-- YOUR OPTIMIZED VERSION for 7.1a:


-- YOUR ANSWER for 7.1b:


-- YOUR ANSWER for 7.1c:


/*
TASK 7.2: Index Considerations
Identify and create appropriate indexes for window function queries:

a) Analyze PARTITION BY and ORDER BY clauses to suggest indexes
b) Create composite indexes for multi-column window specifications
c) Consider covering indexes for window function queries
*/

-- YOUR ANSWER for 7.2a:


-- YOUR ANSWER for 7.2b:


-- YOUR ANSWER for 7.2c:


-- ============================================
-- EXERCISE 8: Real-World Scenarios
-- ============================================

/*
SCENARIO 1: Sales Commission Calculation
Create a comprehensive commission calculation system:

Requirements:
- Base commission rate from employee table
- Bonus for top 3 performers each month
- Penalty for bottom 10% performers
- Commission caps and thresholds
*/

-- YOUR SOLUTION for Scenario 1:


/*
SCENARIO 2: Customer Segmentation Analysis
Create customer segments based on purchasing behavior:

Requirements:
- RFM Analysis (Recency, Frequency, Monetary)
- Customer lifetime value calculation  
- Segment customers into tiers
- Identify at-risk customers
*/

-- YOUR SOLUTION for Scenario 2:


/*
SCENARIO 3: Product Performance Dashboard
Create a comprehensive product analysis:

Requirements:
- Product sales ranking by multiple dimensions
- Trend analysis with period-over-period comparisons
- Category performance with market share
- Inventory optimization recommendations
*/

-- YOUR SOLUTION for Scenario 3:


/*
SCENARIO 4: Employee Performance Review System
Design performance analysis queries:

Requirements:
- Performance ranking within departments
- Goal achievement tracking
- Career progression analysis
- Compensation benchmarking
*/

-- YOUR SOLUTION for Scenario 4:


-- ============================================
-- EXERCISE 9: Advanced Window Function Patterns
-- ============================================

/*
TASK 9.1: Gap and Island Problems
Solve gap and island problems using window functions:

a) Find consecutive sales periods for each employee
b) Identify gaps in customer purchase history
c) Find streaks of above-average performance
*/

-- YOUR ANSWER for 9.1a:


-- YOUR ANSWER for 9.1b:


-- YOUR ANSWER for 9.1c:


/*
TASK 9.2: Percentile and Distribution Analysis
Use percentile functions for statistical analysis:

a) Calculate salary percentiles within departments
b) Find employees in each quartile by performance rating
c) Identify outliers using percentile-based methods
*/

-- YOUR ANSWER for 9.2a:


-- YOUR ANSWER for 9.2b:


-- YOUR ANSWER for 9.2c:


/*
TASK 9.3: Time Series Analysis
Perform time series analysis with window functions:

a) Calculate year-over-year growth rates
b) Seasonal trend analysis using window functions
c) Moving averages with different time windows
*/

-- YOUR ANSWER for 9.3a:


-- YOUR ANSWER for 9.3b:


-- YOUR ANSWER for 9.3c:


-- ============================================
-- EXERCISE 10: Error Handling and Edge Cases
-- ============================================

/*
TASK 10.1: Handling NULL Values
Handle NULL values properly in window functions:

a) Deal with NULL values in LAG/LEAD functions
b) Handle NULL values in ranking functions
c) Manage NULL values in frame specifications
*/

-- YOUR ANSWER for 10.1a:


-- YOUR ANSWER for 10.1b:


-- YOUR ANSWER for 10.1c:


/*
TASK 10.2: Edge Cases in Window Functions
Handle edge cases:

a) Empty partitions in window functions
b) Single-row partitions with LAG/LEAD
c) Boundary conditions in frame specifications
*/

-- YOUR ANSWER for 10.2a:


-- YOUR ANSWER for 10.2b:


-- YOUR ANSWER for 10.2c:


-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Verify window function results
SELECT 'Verifying window function calculations' AS verification_step;

-- Test ROW_NUMBER vs RANK vs DENSE_RANK
SELECT 
    employee_id,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) as row_num,
    RANK() OVER (ORDER BY salary DESC) as rank_num,
    DENSE_RANK() OVER (ORDER BY salary DESC) as dense_rank_num
FROM employees
ORDER BY salary DESC;

-- Test frame specifications
SELECT 
    employee_id,
    salary,
    SUM(salary) OVER (ORDER BY salary ROWS UNBOUNDED PRECEDING) as running_total,
    AVG(salary) OVER (ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as moving_avg
FROM employees
ORDER BY salary;

-- Verify LEAD/LAG results
SELECT 
    sale_id,
    employee_id,
    sale_date,
    total_amount,
    LAG(total_amount, 1) OVER (PARTITION BY employee_id ORDER BY sale_date) as prev_sale,
    LEAD(total_amount, 1) OVER (PARTITION BY employee_id ORDER BY sale_date) as next_sale
FROM sales
ORDER BY employee_id, sale_date;

-- ============================================
-- PERFORMANCE TESTING QUERIES
-- ============================================

-- Compare performance of different approaches
EXPLAIN 
SELECT e.employee_id, e.salary,
       AVG(salary) OVER (PARTITION BY department) as dept_avg
FROM employees e;

-- vs subquery approach
EXPLAIN
SELECT e1.employee_id, e1.salary,
       (SELECT AVG(e2.salary) FROM employees e2 WHERE e2.department = e1.department) as dept_avg
FROM employees e1;

-- ============================================
-- REFLECTION QUESTIONS
-- ============================================

/*
1. When should you use window functions instead of GROUP BY?

2. What are the performance implications of different PARTITION BY clauses?

3. How do frame specifications (ROWS vs RANGE) affect window function results?

4. When is it better to use LEAD/LAG vs self-joins?

5. What are the limitations of PIVOT operations in your database system?

6. How do NULL values affect window function calculations?

7. What indexing strategies work best for window function queries?

8. When should you use CTEs vs subqueries with window functions?

Answer these questions:

1. 

2. 

3. 

4. 

5. 

6. 

7. 

8. 

*/

-- ============================================
-- COMPLETION CHECKLIST
-- ============================================
/*
□ Practiced basic window functions (ROW_NUMBER, RANK, DENSE_RANK)
□ Used aggregate window functions (SUM, AVG, COUNT)
□ Implemented value window functions (FIRST_VALUE, LAST_VALUE, NTH_VALUE)
□ Applied LEAD and LAG functions for trend analysis
□ Created complex filtering conditions with subqueries
□ Used EXISTS and NOT EXISTS for advanced filtering
□ Implemented PIVOT operations (or conditional aggregation)
□ Worked with UNPIVOT transformations
□ Applied custom window frames and partitioning
□ Combined multiple window functions in single queries
□ Used CTEs with window functions
□ Created real-world analytical queries
□ Optimized queries using window functions
□ Handled NULL values and edge cases
□ Solved gap and island problems
□ Performed percentile and distribution analysis
□ Conducted time series analysis
□ Completed real-world scenarios
□ Answered reflection questions
*/