/*
===============================================
    SQL FUNCTIONS EXERCISES
    Practice with String, Numeric, Date, and Aggregate Functions
===============================================
*/

-- ============================================
-- SETUP: Create Sample Database
-- ============================================

CREATE DATABASE functions_practice;
USE functions_practice;

-- Create sample tables with diverse data types
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    hire_date DATE,
    salary DECIMAL(10,2),
    department VARCHAR(50),
    birth_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    sale_date DATE,
    amount DECIMAL(10,2),
    quantity INT,
    product_name VARCHAR(100),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    cost DECIMAL(10,2),
    category VARCHAR(50),
    launch_date DATE
);

-- Insert sample data
INSERT INTO employees (first_name, last_name, email, phone, hire_date, salary, department, birth_date) VALUES
('John', 'DOE', 'john.doe@company.com', '(555) 123-4567', '2020-01-15', 75000.00, 'Sales', '1985-03-12'),
('jane', 'smith', 'jane.smith@company.com', '555-234-5678', '2019-06-01', 82000.50, 'Marketing', '1987-08-25'),
('Bob', 'Johnson', 'bob.johnson@company.com', '(555)345-6789', '2021-03-10', 68000.00, 'IT', '1990-11-03'),
('Alice', 'BROWN', 'alice.brown@company.com', '555.456.7890', '2018-09-15', 95000.75, 'Finance', '1982-07-18'),
('Charlie', 'Davis', 'charlie.davis@company.com', '555 567 8901', '2022-01-20', 72000.00, 'Sales', '1988-12-05');

INSERT INTO sales (employee_id, sale_date, amount, quantity, product_name) VALUES
(1, '2023-01-15', 1250.00, 5, 'Widget A'),
(1, '2023-02-20', 890.50, 3, 'Widget B'),
(2, '2023-01-10', 2100.00, 7, 'Widget A'),
(2, '2023-03-05', 1680.75, 4, 'Widget C'),
(3, '2023-02-12', 950.00, 2, 'Widget B'),
(4, '2023-01-25', 3200.00, 8, 'Widget A'),
(4, '2023-02-28', 1450.25, 6, 'Widget C'),
(5, '2023-03-15', 780.00, 1, 'Widget B'),
(1, '2023-03-20', 2250.00, 9, 'Widget A'),
(2, '2023-03-25', 1100.00, 5, 'Widget B');

INSERT INTO products (product_name, price, cost, category, launch_date) VALUES
('Widget A', 250.00, 150.00, 'Electronics', '2022-01-15'),
('Widget B', 320.50, 200.25, 'Electronics', '2022-03-20'),
('Widget C', 420.25, 280.75, 'Hardware', '2022-06-10'),
('Gadget X', 150.00, 90.00, 'Accessories', '2023-01-05'),
('Tool Y', 89.99, 45.50, 'Tools', '2022-11-30');

-- ============================================
-- EXERCISE 1: String Functions
-- ============================================

-- 1.1: Name Standardization
-- Write a query to display all employee names in proper case (first letter uppercase, rest lowercase)
-- Expected: "John Doe", "Jane Smith", etc.
-- YOUR ANSWER:

-- 1.2: Email Domain Extraction
-- Extract the domain part from each employee's email address
-- Expected: "company.com" for all emails
-- YOUR ANSWER:

-- 1.3: Phone Number Cleaning
-- Clean and standardize phone numbers to format: (XXX) XXX-XXXX
-- Remove all non-numeric characters first, then format
-- YOUR ANSWER:

-- 1.4: String Length Analysis
-- Find employees whose last name is longer than their first name
-- Display first name, last name, and the length difference
-- YOUR ANSWER:

-- 1.5: Email Username Creation
-- Create a username by taking first 3 letters of first name + first 3 letters of last name + employee_id
-- Make it lowercase. Example: "johdo1" for John Doe with ID 1
-- YOUR ANSWER:

-- 1.6: Search and Replace
-- Replace all occurrences of "Widget" with "Product" in the product_name column from sales table
-- Display original and modified names
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 2: Numeric Functions
-- ============================================

-- 2.1: Salary Analysis
-- Calculate the following for each employee:
-- - Annual salary
-- - Monthly salary (rounded to 2 decimal places)
-- - Weekly salary (52 weeks per year, rounded to nearest dollar)
-- YOUR ANSWER:

-- 2.2: Commission Calculation
-- Calculate commission for sales employees (department = 'Sales'):
-- - 5% commission on sales amount
-- - Round to nearest cent
-- - Display employee name, total sales, and commission
-- YOUR ANSWER:

-- 2.3: Age Calculation
-- Calculate each employee's current age in years (use birth_date)
-- Also calculate their age when they were hired
-- Round ages to nearest year
-- YOUR ANSWER:

-- 2.4: Price Analysis
-- For products, calculate:
-- - Profit margin percentage: ((price - cost) / cost) * 100
-- - Markup percentage: ((price - cost) / price) * 100
-- - Round both to 1 decimal place
-- YOUR ANSWER:

-- 2.5: Statistical Analysis
-- Calculate statistics for employee salaries:
-- - Minimum, Maximum, Average (rounded to 2 decimals)
-- - Standard deviation (if supported by your database)
-- - Count of employees
-- YOUR ANSWER:

-- 2.6: Random Sample
-- Generate 3 random numbers between 1 and 100
-- Use these to create a "random bonus" for employees (salary * random_number / 100)
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 3: Date Functions
-- ============================================

-- 3.1: Date Formatting
-- Display hire dates in different formats:
-- - MM/DD/YYYY format
-- - Month DD, YYYY format (e.g., "January 15, 2020")
-- - Day of week format (e.g., "Wednesday")
-- YOUR ANSWER:

-- 3.2: Date Calculations
-- Calculate for each employee:
-- - Years of service (from hire_date to today)
-- - Days since hire
-- - Next anniversary date
-- YOUR ANSWER:

-- 3.3: Age Groups
-- Categorize employees by age:
-- - "Young" (under 30)
-- - "Middle-aged" (30-45)
-- - "Senior" (over 45)
-- Use current date for age calculation
-- YOUR ANSWER:

-- 3.4: Sales Trends
-- For sales data, extract:
-- - Year and month from sale_date
-- - Quarter of the year
-- - Day of the week
-- Group sales by month and show totals
-- YOUR ANSWER:

-- 3.5: Birthday Analysis
-- Find employees whose birthday is:
-- - In the current month
-- - Coming up in the next 30 days
-- - Show days until next birthday
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 4: Aggregate Functions
-- ============================================

-- 4.1: Department Statistics
-- For each department, calculate:
-- - Number of employees
-- - Average salary
-- - Total salary budget
-- - Highest and lowest salary
-- YOUR ANSWER:

-- 4.2: Sales Performance
-- Calculate for each employee:
-- - Total sales amount
-- - Number of sales transactions
-- - Average sale amount
-- - Best sale (highest amount)
-- Only include employees with sales
-- YOUR ANSWER:

-- 4.3: Product Performance
-- For products that have been sold:
-- - Total quantity sold
-- - Total revenue generated
-- - Average sale price (from sales, not product table)
-- - Number of transactions
-- YOUR ANSWER:

-- 4.4: Time-based Aggregations
-- Group sales by month and calculate:
-- - Monthly total sales
-- - Monthly average sale amount
-- - Monthly transaction count
-- - Running total (cumulative sum)
-- YOUR ANSWER:

-- 4.5: Complex Aggregations
-- Create a summary showing:
-- - Department with highest average salary
-- - Employee with most sales transactions
-- - Month with highest sales revenue
-- - Product category with best profit margin
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 5: Combined Function Usage
-- ============================================

-- 5.1: Employee Report
-- Create a comprehensive employee report with:
-- - Full name (properly formatted)
-- - Email domain
-- - Years of service (rounded to 1 decimal)
-- - Age category
-- - Salary range (Low: <70k, Medium: 70k-85k, High: >85k)
-- YOUR ANSWER:

-- 5.2: Sales Analysis Dashboard
-- Create a sales dashboard showing:
-- - Employee name (formatted)
-- - Department
-- - Total sales (formatted with currency symbol)
-- - Commission (5% of sales, formatted)
-- - Performance rating based on sales volume
-- YOUR ANSWER:

-- 5.3: Product Profitability Analysis
-- Combine product and sales data to show:
-- - Product name
-- - Launch date (formatted)
-- - Days since launch
-- - Total units sold
-- - Total profit (quantity * (price - cost))
-- - Profit margin percentage
-- YOUR ANSWER:

-- 5.4: Data Quality Report
-- Create a data quality report identifying:
-- - Employees with malformed phone numbers
-- - Employees with non-standard email formats
-- - Sales records with unusual amounts (z-score > 2 or < -2)
-- - Products with negative profit margins
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 6: Advanced Function Challenges
-- ============================================

-- 6.1: Dynamic Categorization
-- Create a query that dynamically categorizes employees based on:
-- - Salary percentile (Top 25%, Middle 50%, Bottom 25%)
-- - Experience level based on hire date
-- - Performance tier based on sales (if applicable)
-- YOUR ANSWER:

-- 6.2: Text Analysis
-- Analyze the product names to find:
-- - Most common word in product names
-- - Average word count per product name
-- - Products with duplicate words in their names
-- YOUR ANSWER:

-- 6.3: Financial Calculations
-- Calculate for each employee:
-- - Monthly take-home pay (assume 25% tax rate)
-- - Annual bonus (10% of salary for employees with >2 years service)
-- - Retirement contribution (6% of salary, matched by company)
-- - Total compensation package
-- YOUR ANSWER:

-- 6.4: Pattern Matching
-- Find patterns in the data:
-- - Employees hired in the same month across different years
-- - Sales that occurred on the same day of the week
-- - Products with similar naming patterns
-- YOUR ANSWER:

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Check your string function implementations
SELECT 
    CONCAT(first_name, ' ', last_name) as full_name,
    LENGTH(first_name) + LENGTH(last_name) as name_length,
    UPPER(email) as upper_email,
    SUBSTRING(phone, 1, 3) as area_code
FROM employees
LIMIT 3;

-- Check your numeric calculations
SELECT 
    AVG(salary) as avg_salary,
    ROUND(AVG(salary), 2) as rounded_avg,
    MAX(salary) - MIN(salary) as salary_range,
    COUNT(*) as employee_count
FROM employees;

-- Check your date functions
SELECT 
    hire_date,
    DATEDIFF(CURDATE(), hire_date) as days_employed,
    YEAR(hire_date) as hire_year,
    MONTHNAME(hire_date) as hire_month
FROM employees
LIMIT 3;

-- Check your aggregations
SELECT 
    department,
    COUNT(*) as emp_count,
    AVG(salary) as avg_salary,
    SUM(salary) as total_budget
FROM employees
GROUP BY department;

-- ============================================
-- BONUS CHALLENGES
-- ============================================

-- Bonus 1: Create a stored function
-- Write a function that takes a salary and returns the tax bracket
-- (15% for <50k, 25% for 50k-100k, 35% for >100k)

-- Bonus 2: Data Transformation
-- Write a query that pivots the sales data to show total sales by employee by month

-- Bonus 3: Recursive Calculation
-- Calculate compound interest for each employee's salary growing at 3% annually over 10 years

-- ============================================
-- REFLECTION QUESTIONS
-- ============================================

/*
1. Which string functions are most useful for data cleaning?

2. How do numeric functions help in business calculations?

3. What are the performance implications of using functions in WHERE clauses?

4. How do aggregate functions change when used with GROUP BY?

5. What's the difference between ROUND, FLOOR, and CEILING?

6. How do date functions vary between different database systems?

Answer these questions in comments below:

1. 

2. 

3. 

4. 

5. 

6. 

*/

-- ============================================
-- COMPLETION CHECKLIST
-- ============================================
/*
□ Completed string function exercises
□ Performed numeric calculations
□ Used date functions effectively
□ Applied aggregate functions correctly
□ Combined multiple function types
□ Handled advanced scenarios
□ Verified results with test queries
□ Answered reflection questions
□ Attempted bonus challenges
□ Tested all queries successfully
*/