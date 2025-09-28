-- 03_CTEs.sql
-- Common Table Expressions (CTEs) in SQL
-- A comprehensive guide with practical examples

-- Sample Data: Employees Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    manager_id INT
);

INSERT INTO employees VALUES
(1, 'John', 'HR', 50000, NULL),
(2, 'Jane', 'HR', 55000, 1),
(3, 'Bob', 'IT', 60000, NULL),
(4, 'Alice', 'IT', 65000, 3),
(5, 'Charlie', 'Sales', 70000, NULL),
(6, 'Diana', 'Sales', 75000, 5);

-- Sample Data: Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10, 2)
);

INSERT INTO orders VALUES
(1, 101, '2023-01-15', 150),
(2, 101, '2023-02-20', 200),
(3, 102, '2023-01-10', 75),
(4, 103, '2023-03-05', 300),
(5, 101, '2023-03-25', 100),
(6, 102, '2023-04-12', 250);

-- Example 1: Basic CTE - Employees earning above average salary
WITH AverageSalary AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
)
SELECT e.name, e.salary, a.avg_salary
FROM employees e, AverageSalary a
WHERE e.salary > a.avg_salary;

-- Example 2: Multiple CTEs - Employees in high-paying departments
WITH 
DepartmentStats AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
),
HighPaidDepts AS (
    SELECT department
    FROM DepartmentStats
    WHERE avg_salary > 60000
)
SELECT e.name, e.department, e.salary
FROM employees e
WHERE e.department IN (SELECT department FROM HighPaidDepts);

-- Example 3: Recursive CTE - Organizational hierarchy
WITH RECURSIVE OrgChart AS (
    -- Anchor member: top-level managers
    SELECT employee_id, name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive member: subordinates
    SELECT e.employee_id, e.name, e.manager_id, oc.level + 1
    FROM employees e
    INNER JOIN OrgChart oc ON e.manager_id = oc.employee_id
)
SELECT employee_id, name, manager_id, level
FROM OrgChart
ORDER BY level, name;

-- Example 4: Customer segmentation analysis
WITH 
CustomerTotals AS (
    SELECT 
        customer_id, 
        COUNT(*) AS order_count, 
        SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
),
CustomerSegments AS (
    SELECT
        customer_id,
        order_count,
        total_spent,
        CASE
            WHEN total_spent >= 400 THEN 'VIP'
            WHEN total_spent >= 200 THEN 'Premium'
            ELSE 'Standard'
        END AS segment
    FROM CustomerTotals
)
SELECT 
    segment,
    COUNT(*) AS customer_count,
    AVG(total_spent) AS avg_spent,
    AVG(order_count) AS avg_orders
FROM CustomerSegments
GROUP BY segment
ORDER BY avg_spent DESC;

-- Example 5: CTE vs Subquery comparison
-- Subquery approach
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- CTE approach (more readable)
WITH AverageSalary AS (
    SELECT AVG(salary) AS avg_salary FROM employees
)
SELECT name, salary
FROM employees, AverageSalary
WHERE salary > avg_salary;

-- Example 6: Monthly sales analysis with CTEs
WITH MonthlySales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS sale_year,
        EXTRACT(MONTH FROM order_date) AS sale_month,
        SUM(amount) AS total_sales
    FROM orders
    GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
),
SalesWithPrevious AS (
    SELECT
        sale_year,
        sale_month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY sale_year, sale_month) AS prev_month_sales
    FROM MonthlySales
)
SELECT 
    sale_year,
    sale_month,
    total_sales,
    prev_month_sales,
    ROUND(((total_sales - prev_month_sales) / prev_month_sales) * 100, 2) AS growth_percentage
FROM SalesWithPrevious;

-- Clean up (optional)
-- DROP TABLE employees;
-- DROP TABLE orders;