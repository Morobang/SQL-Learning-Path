/*
===============================================
    DATABASE CONSTRAINTS EXERCISES
    Practice with Primary Keys, Foreign Keys, Unique, NOT NULL, Check Constraints, and Defaults
===============================================
*/

-- ============================================
-- SETUP: Create Database for Constraint Practice
-- ============================================

DROP DATABASE IF EXISTS constraint_practice;
CREATE DATABASE constraint_practice;
USE constraint_practice;

-- We'll build an e-commerce database step by step, adding constraints as we go

-- ============================================
-- EXERCISE 1: Primary Key Constraints
-- ============================================

-- 1.1: Create a basic table with single-column primary key
-- Create a 'categories' table with:
-- - category_id (auto-increment primary key)
-- - category_name (variable character, 50 chars)
-- - description (text)
-- YOUR ANSWER:

-- 1.2: Create a table with composite primary key
-- Create an 'order_items' table with:
-- - order_id (integer)
-- - product_id (integer)  
-- - quantity (integer)
-- - unit_price (decimal 10,2)
-- Primary key should be combination of order_id and product_id
-- YOUR ANSWER:

-- 1.3: Add primary key to existing table
-- First create a table without primary key, then add it
CREATE TABLE suppliers (
    supplier_id INT,
    company_name VARCHAR(100),
    contact_name VARCHAR(50)
);
-- Now add primary key constraint to supplier_id
-- YOUR ANSWER:

-- 1.4: Try to violate primary key constraint
-- Insert some data into categories, then try to insert duplicate primary key
-- Document what happens
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 2: Foreign Key Constraints
-- ============================================

-- 2.1: Create tables with foreign key relationship
-- Create 'products' table that references categories:
-- - product_id (primary key, auto-increment)
-- - product_name (varchar 100, not null)
-- - category_id (integer, foreign key to categories)
-- - price (decimal 10,2)
-- - stock_quantity (integer, default 0)
-- YOUR ANSWER:

-- 2.2: Create foreign key with cascade options
-- Create 'customers' table first:
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20)
);

-- Now create 'orders' table with foreign key that cascades on delete:
-- - order_id (primary key, auto-increment)
-- - customer_id (foreign key to customers, cascade on delete)
-- - order_date (date, default current date)
-- - total_amount (decimal 10,2)
-- - status (varchar 20, default 'pending')
-- YOUR ANSWER:

-- 2.3: Add foreign key to existing table
-- The order_items table we created earlier needs foreign keys
-- Add foreign key constraints for order_id (references orders) and product_id (references products)
-- YOUR ANSWER:

-- 2.4: Test foreign key constraints
-- Insert some sample data and try to:
-- a) Insert an order with non-existent customer_id
-- b) Delete a customer who has orders
-- c) Insert order_item with non-existent product_id
-- Document what happens in each case
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 3: Unique Constraints
-- ============================================

-- 3.1: Add unique constraint to existing table
-- Add unique constraint to customers email column
-- YOUR ANSWER:

-- 3.2: Create table with multiple unique constraints
-- Create 'employees' table with:
-- - employee_id (primary key, auto-increment)
-- - first_name (varchar 50, not null)
-- - last_name (varchar 50, not null)
-- - email (varchar 100, unique)
-- - employee_code (varchar 10, unique)
-- - hire_date (date)
-- - salary (decimal 10,2)
-- YOUR ANSWER:

-- 3.3: Create composite unique constraint
-- Create 'product_reviews' table where combination of customer_id and product_id must be unique:
-- - review_id (primary key, auto-increment)
-- - customer_id (foreign key to customers)
-- - product_id (foreign key to products)
-- - rating (integer)
-- - review_text (text)
-- - review_date (date, default current date)
-- Constraint: one review per customer per product
-- YOUR ANSWER:

-- 3.4: Test unique constraints
-- Try to violate the unique constraints you created and document the results
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 4: NOT NULL Constraints
-- ============================================

-- 4.1: Add NOT NULL to existing column
-- Add NOT NULL constraint to products.product_name (if not already set)
-- YOUR ANSWER:

-- 4.2: Create table with strategic NOT NULL constraints
-- Create 'addresses' table with:
-- - address_id (primary key, auto-increment)
-- - customer_id (foreign key, NOT NULL)
-- - address_type (varchar 20, NOT NULL) -- 'billing' or 'shipping'
-- - street_address (varchar 200, NOT NULL)
-- - city (varchar 50, NOT NULL)
-- - state (varchar 20, NOT NULL)
-- - postal_code (varchar 10, NOT NULL)
-- - country (varchar 50, NOT NULL, default 'USA')
-- YOUR ANSWER:

-- 4.3: Test NOT NULL constraints
-- Try to violate NOT NULL constraints and document what happens
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 5: Check Constraints
-- ============================================

-- 5.1: Add check constraint to existing table
-- Add check constraint to products table ensuring price is positive
-- YOUR ANSWER:

-- 5.2: Create table with multiple check constraints
-- Create 'discount_codes' table with:
-- - code_id (primary key, auto-increment)
-- - code (varchar 20, unique, not null)
-- - discount_percent (decimal 5,2, check: between 0 and 100)
-- - min_order_amount (decimal 10,2, check: >= 0)
-- - max_uses (integer, check: > 0)
-- - start_date (date, not null)
-- - end_date (date, not null)
-- - is_active (boolean, default true)
-- Add check constraint: end_date must be after start_date
-- YOUR ANSWER:

-- 5.3: Create table with complex check constraints
-- Create 'employees_advanced' table with business rules:
-- - employee_id (primary key)
-- - age (integer, check: between 18 and 70)
-- - salary (decimal 10,2, check: between 25000 and 200000)
-- - department (varchar 50, check: must be one of 'HR', 'IT', 'Sales', 'Finance', 'Marketing')
-- - email (varchar 100, check: must contain '@' symbol)
-- YOUR ANSWER:

-- 5.4: Test check constraints
-- Try to violate each check constraint and document the results
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 6: Default Values
-- ============================================

-- 6.1: Add default values to existing table
-- Add default values to orders table:
-- - order_date should default to current date
-- - status should default to 'pending'
-- YOUR ANSWER:

-- 6.2: Create table with various default types
-- Create 'user_preferences' table with:
-- - pref_id (primary key, auto-increment)
-- - customer_id (foreign key, not null)
-- - newsletter_signup (boolean, default true)
-- - preferred_contact (varchar 20, default 'email')
-- - timezone (varchar 50, default 'UTC')
-- - created_at (timestamp, default current timestamp)
-- - updated_at (timestamp, default current timestamp on update)
-- YOUR ANSWER:

-- 6.3: Test default value behavior
-- Insert records with and without specifying values for default columns
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 7: Complex Constraint Scenarios
-- ============================================

-- 7.1: Inventory Management System
-- Create a comprehensive inventory tracking system:
-- 
-- Create 'warehouses' table:
-- - warehouse_id (primary key)
-- - warehouse_name (unique, not null)
-- - location (not null)
-- - is_active (boolean, default true)
--
-- Create 'inventory' table:
-- - inventory_id (primary key)
-- - product_id (foreign key to products, not null)
-- - warehouse_id (foreign key to warehouses, not null)
-- - quantity_on_hand (integer, default 0, check >= 0)
-- - reorder_level (integer, default 10, check > 0)
-- - last_updated (timestamp, default current timestamp)
-- - Unique constraint: one inventory record per product per warehouse
-- YOUR ANSWER:

-- 7.2: Order Processing System
-- Create tables for order processing with proper constraints:
--
-- Create 'order_status_history' table:
-- - history_id (primary key)
-- - order_id (foreign key to orders, not null)
-- - old_status (varchar 20)
-- - new_status (varchar 20, not null)
-- - changed_by (varchar 50, not null)
-- - changed_at (timestamp, default current timestamp)
-- - notes (text)
-- Add check: new_status must be one of specific values
-- YOUR ANSWER:

-- 7.3: Customer Credit System
-- Create 'customer_credit' table with business rules:
-- - credit_id (primary key)
-- - customer_id (foreign key, unique - one credit record per customer)
-- - credit_limit (decimal 10,2, default 1000.00, check >= 0)
-- - current_balance (decimal 10,2, default 0.00)
-- - available_credit (computed as credit_limit - current_balance)
-- - last_payment_date (date)
-- - created_date (date, default current date)
-- Add check: current_balance cannot exceed credit_limit
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 8: Constraint Management
-- ============================================

-- 8.1: Drop and recreate constraints
-- Drop the foreign key constraint from order_items to products
-- Then recreate it with a different name
-- YOUR ANSWER:

-- 8.2: Disable and enable constraints (if supported by your database)
-- Temporarily disable a constraint, insert data that would violate it,
-- then try to re-enable the constraint
-- YOUR ANSWER:

-- 8.3: Rename constraints
-- Give meaningful names to all unnamed constraints you've created
-- Use a consistent naming convention (e.g., fk_table_column, uk_table_column, etc.)
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 9: Constraint Violations and Error Handling
-- ============================================

-- 9.1: Create a comprehensive test scenario
-- Write INSERT statements that will violate each type of constraint:
-- - Primary key violation
-- - Foreign key violation  
-- - Unique constraint violation
-- - NOT NULL violation
-- - Check constraint violation
-- Document the error message for each
-- YOUR ANSWER:

-- 9.2: Bulk data operations with constraints
-- Try to load a CSV file or bulk insert data that contains constraint violations
-- How does your database handle partial failures?
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 10: Performance Impact of Constraints
-- ============================================

-- 10.1: Analyze constraint overhead
-- Create identical tables with and without constraints
-- Insert 1000 records into each and compare performance
-- YOUR ANSWER:

-- 10.2: Index creation by constraints
-- Examine what indexes are automatically created by your constraints
-- Use SHOW INDEXES or equivalent command
-- YOUR ANSWER:

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- List all constraints in your database
SELECT 
    TABLE_NAME,
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'constraint_practice'
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

-- Check foreign key relationships
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'constraint_practice'
AND REFERENCED_TABLE_NAME IS NOT NULL;

-- Verify check constraints
SELECT 
    TABLE_NAME,
    CONSTRAINT_NAME,
    CHECK_CLAUSE
FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'constraint_practice';

-- ============================================
-- REAL-WORLD SCENARIOS
-- ============================================

-- Scenario 1: E-commerce Platform
-- Design a complete constraint system for an e-commerce platform including:
-- - User registration with email verification
-- - Product catalog with categories and pricing rules
-- - Order processing with status workflows
-- - Inventory management with stock level controls
-- - Payment processing with amount validations

-- Scenario 2: Banking System
-- Design constraints for a banking system including:
-- - Account number uniqueness and format validation
-- - Transaction amount and balance constraints
-- - Customer identification requirements
-- - Audit trail requirements

-- Scenario 3: Hospital Management
-- Design constraints for a hospital system including:
-- - Patient identification and privacy requirements
-- - Medical record integrity
-- - Appointment scheduling conflicts
-- - Staff certification and role constraints

-- ============================================
-- ADVANCED CHALLENGES
-- ============================================

-- Challenge 1: Temporal Constraints
-- Create constraints that vary based on time
-- (e.g., different pricing rules for different date ranges)

-- Challenge 2: Cross-Table Constraints
-- Create constraints that span multiple tables
-- (e.g., total order items value must equal order total)

-- Challenge 3: Dynamic Constraints
-- Create constraints that change based on data values
-- (e.g., different validation rules for different user types)

-- ============================================
-- REFLECTION QUESTIONS
-- ============================================

/*
1. How do constraints improve data quality?

2. What's the performance impact of having many constraints?

3. When would you choose to enforce business rules in the database vs. application?

4. How do you handle constraint violations in production systems?

5. What's the difference between database constraints and application validation?

6. How do constraints affect database migration and schema changes?

Answer these questions:

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
□ Created primary key constraints (single and composite)
□ Implemented foreign key constraints with cascade options
□ Added unique constraints (single and composite)
□ Applied NOT NULL constraints appropriately
□ Created check constraints for business rules
□ Set up default values for columns
□ Handled complex multi-table constraint scenarios
□ Managed constraint lifecycle (create, drop, modify)
□ Tested constraint violations and error handling
□ Analyzed performance impact of constraints
□ Designed real-world constraint systems
□ Answered reflection questions
*/