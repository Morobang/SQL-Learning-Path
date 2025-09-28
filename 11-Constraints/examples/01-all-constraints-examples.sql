/*
===============================================
    CONSTRAINTS EXAMPLES
    Practical SQL examples for all constraint types
===============================================
*/

-- ============================================
-- 1. PRIMARY KEY CONSTRAINTS
-- ============================================

-- Create table with PRIMARY KEY
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,        -- Single column primary key
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    hire_date DATE
);

-- Composite PRIMARY KEY (multiple columns)
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id)    -- Composite primary key
);

-- Add PRIMARY KEY to existing table
ALTER TABLE customers 
ADD CONSTRAINT pk_customers PRIMARY KEY (customer_id);

-- ============================================
-- 2. FOREIGN KEY CONSTRAINTS
-- ============================================

-- Create table with FOREIGN KEY
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    -- Foreign key reference
    CONSTRAINT fk_orders_customer 
        FOREIGN KEY (customer_id) 
        REFERENCES customers(customer_id)
);

-- Foreign key with CASCADE options
CREATE TABLE order_details (
    detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    -- Foreign key with cascade delete
    CONSTRAINT fk_details_order 
        FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) 
        ON DELETE CASCADE,
    -- Foreign key with set null on update
    CONSTRAINT fk_details_product 
        FOREIGN KEY (product_id) 
        REFERENCES products(product_id) 
        ON UPDATE SET NULL
);

-- Add FOREIGN KEY to existing table
ALTER TABLE employees
ADD CONSTRAINT fk_employees_department
    FOREIGN KEY (department_id) 
    REFERENCES departments(department_id);

-- ============================================
-- 3. UNIQUE CONSTRAINTS
-- ============================================

-- Create table with UNIQUE constraint
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) UNIQUE,        -- Single column unique
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
);

-- Composite UNIQUE constraint
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_code VARCHAR(20),
    category_id INT,
    product_name VARCHAR(100),
    -- Unique combination of code and category
    CONSTRAINT uk_product_code_category 
        UNIQUE (product_code, category_id)
);

-- Add UNIQUE constraint to existing table
ALTER TABLE employees
ADD CONSTRAINT uk_employees_email UNIQUE (email);

-- ============================================
-- 4. CHECK CONSTRAINTS
-- ============================================

-- Create table with CHECK constraints
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) CHECK (price > 0),              -- Price must be positive
    discount_percent INT CHECK (discount_percent BETWEEN 0 AND 100), -- Discount 0-100%
    category VARCHAR(50) CHECK (category IN ('Electronics', 'Clothing', 'Books')),
    stock_quantity INT CHECK (stock_quantity >= 0)       -- Stock cannot be negative
);

-- Complex CHECK constraint
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    hire_date DATE,
    salary DECIMAL(10,2),
    -- Check hire date is after birth date and salary is reasonable
    CONSTRAINT chk_employee_dates 
        CHECK (hire_date > birth_date),
    CONSTRAINT chk_employee_salary 
        CHECK (salary BETWEEN 20000 AND 500000)
);

-- Add CHECK constraint to existing table
ALTER TABLE orders
ADD CONSTRAINT chk_orders_total 
    CHECK (total_amount >= 0);

-- ============================================
-- 5. NOT NULL CONSTRAINTS
-- ============================================

-- Create table with NOT NULL constraints
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,    -- Required field
    last_name VARCHAR(50) NOT NULL,     -- Required field
    email VARCHAR(100) NOT NULL,        -- Required field
    phone VARCHAR(20),                  -- Optional field
    address TEXT,                       -- Optional field
    created_date DATETIME NOT NULL DEFAULT GETDATE()  -- Required with default
);

-- Modify existing column to NOT NULL
ALTER TABLE products
ALTER COLUMN product_name VARCHAR(100) NOT NULL;

-- ============================================
-- 6. DEFAULT VALUE CONSTRAINTS
-- ============================================

-- Create table with DEFAULT values
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE DEFAULT GETDATE(),              -- Default to current date
    status VARCHAR(20) DEFAULT 'Pending',           -- Default status
    priority VARCHAR(10) DEFAULT 'Normal',          -- Default priority
    total_amount DECIMAL(10,2) DEFAULT 0.00,        -- Default amount
    is_active BIT DEFAULT 1                         -- Default to active
);

-- Add DEFAULT to existing column
ALTER TABLE products
ADD CONSTRAINT df_products_created_date 
    DEFAULT GETDATE() FOR created_date;

-- ============================================
-- 7. CONSTRAINT MANAGEMENT
-- ============================================

-- View constraints on a table
SELECT 
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'employees';

-- Drop constraints
ALTER TABLE employees DROP CONSTRAINT fk_employees_department;
ALTER TABLE products DROP CONSTRAINT chk_products_price;
ALTER TABLE users DROP CONSTRAINT uk_users_email;

-- Disable/Enable constraints (SQL Server)
ALTER TABLE orders NOCHECK CONSTRAINT fk_orders_customer;  -- Disable
ALTER TABLE orders CHECK CONSTRAINT fk_orders_customer;     -- Enable

-- ============================================
-- 8. TESTING CONSTRAINTS
-- ============================================

-- Test PRIMARY KEY constraint
INSERT INTO employees (employee_id, first_name, last_name) 
VALUES (1, 'John', 'Doe');

-- This will fail - duplicate primary key
-- INSERT INTO employees (employee_id, first_name, last_name) 
-- VALUES (1, 'Jane', 'Smith');

-- Test NOT NULL constraint
-- This will fail - first_name cannot be NULL
-- INSERT INTO employees (employee_id, first_name, last_name) 
-- VALUES (2, NULL, 'Smith');

-- Test CHECK constraint
INSERT INTO products (product_id, product_name, price) 
VALUES (1, 'Laptop', 999.99);

-- This will fail - price cannot be negative
-- INSERT INTO products (product_id, product_name, price) 
-- VALUES (2, 'Mouse', -10.00);

-- Test UNIQUE constraint
INSERT INTO users (user_id, username, email) 
VALUES (1, 'john_doe', 'john@email.com');

-- This will fail - username must be unique
-- INSERT INTO users (user_id, username, email) 
-- VALUES (2, 'john_doe', 'john2@email.com');

-- ============================================
-- 9. CONSTRAINT ERROR HANDLING
-- ============================================

-- Handle constraint violations in application code
BEGIN TRY
    INSERT INTO products (product_id, product_name, price) 
    VALUES (1, 'Invalid Product', -100);
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE();
    -- Handle the constraint violation
END CATCH;

-- ============================================
-- 📚 KEY TAKEAWAYS
-- ============================================
-- 1. Constraints ensure data integrity and quality
-- 2. PRIMARY KEY uniquely identifies each row
-- 3. FOREIGN KEY maintains referential integrity
-- 4. UNIQUE prevents duplicate values
-- 5. CHECK validates data against business rules
-- 6. NOT NULL ensures required fields have values
-- 7. DEFAULT provides automatic values for columns
-- 8. Proper constraint design prevents data corruption

-- ============================================
-- 🔄 NEXT STEPS
-- ============================================
-- Practice with: exercises/constraint-exercises.sql
-- Learn about: 12-Data-Modeling for database design
-- Advanced topic: Constraint performance impact