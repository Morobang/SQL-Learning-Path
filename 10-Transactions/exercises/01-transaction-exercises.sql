/*
===============================================
    TRANSACTION EXERCISES
    Hands-on practice with transaction control
===============================================
*/

-- ============================================
-- SETUP: Create Sample Database
-- ============================================

-- Create tables for exercises
CREATE TABLE customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    balance DECIMAL(10,2) DEFAULT 0,
    created_date DATETIME DEFAULT GETDATE()
);

CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES customers(customer_id),
    order_date DATETIME DEFAULT GETDATE(),
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'pending'
);

CREATE TABLE products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0
);

CREATE TABLE order_items (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES orders(order_id),
    product_id INT FOREIGN KEY REFERENCES products(product_id),
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

-- Sample data
INSERT INTO customers (name, email, balance) VALUES
('Alice Johnson', 'alice@email.com', 1000.00),
('Bob Smith', 'bob@email.com', 750.50),
('Carol Davis', 'carol@email.com', 2000.00);

INSERT INTO products (name, price, stock_quantity) VALUES
('Laptop', 999.99, 10),
('Mouse', 29.99, 50),
('Keyboard', 79.99, 30),
('Monitor', 299.99, 15);

-- ============================================
-- EXERCISE 1: Basic Transaction Control
-- ============================================

/*
TASK: Complete the following transaction to transfer money between customers.
Requirements:
- Transfer $200 from Alice (customer_id = 1) to Bob (customer_id = 2)
- Ensure Alice has sufficient funds
- Use proper error handling
*/

-- YOUR CODE HERE:
BEGIN TRANSACTION;
BEGIN TRY
    -- Step 1: Check Alice's balance
    -- Write your SELECT statement here
    
    -- Step 2: Validate sufficient funds
    -- Write your IF statement here
    
    -- Step 3: Perform the transfer
    -- Write your UPDATE statements here
    
    -- Step 4: Commit if successful
    
    PRINT 'Transfer completed successfully';
END TRY
BEGIN CATCH
    -- Step 5: Handle errors
    -- Write your error handling here
    
END CATCH;

-- Verify the results
SELECT customer_id, name, balance FROM customers WHERE customer_id IN (1, 2);

-- ============================================
-- EXERCISE 2: Order Processing with Inventory
-- ============================================

/*
TASK: Create a complete order processing transaction.
Requirements:
- Customer 1 wants to buy 2 Laptops
- Check inventory availability
- Create order record
- Add order items
- Update stock
- Calculate and store total
*/

-- YOUR CODE HERE:
BEGIN TRANSACTION;
BEGIN TRY
    DECLARE @customer_id INT = 1;
    DECLARE @product_id INT = 1; -- Laptop
    DECLARE @quantity INT = 2;
    DECLARE @unit_price DECIMAL(10,2);
    
    -- Step 1: Get product price and check stock
    -- Write your SELECT statement here
    
    -- Step 2: Validate stock availability
    -- Write your validation logic here
    
    -- Step 3: Create order
    -- Write your INSERT statement here
    -- Get the order ID
    
    -- Step 4: Add order items
    -- Write your INSERT statement here
    
    -- Step 5: Update inventory
    -- Write your UPDATE statement here
    
    -- Step 6: Update order total
    -- Write your UPDATE statement here
    
    COMMIT;
    PRINT 'Order processed successfully';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Order processing failed: ' + ERROR_MESSAGE();
END CATCH;

-- ============================================
-- EXERCISE 3: Savepoints Practice
-- ============================================

/*
TASK: Create a complex transaction with multiple savepoints.
Scenario: Process a bulk order with multiple items, using savepoints 
to handle partial failures.
*/

BEGIN TRANSACTION;

    -- Create initial order
    INSERT INTO orders (customer_id, total_amount, status) 
    VALUES (2, 0, 'processing');
    
    DECLARE @order_id INT = SCOPE_IDENTITY();
    DECLARE @total DECIMAL(10,2) = 0;
    
    -- Savepoint after order creation
    SAVE TRANSACTION after_order;
    
    -- YOUR CODE HERE:
    -- Try to add item 1: 1 Laptop
    BEGIN TRY
        -- Write your code to add the item
        -- Remember to create a savepoint after success
        
    END TRY
    BEGIN CATCH
        -- Handle the error and rollback to appropriate savepoint
        
    END CATCH;
    
    -- Try to add item 2: 3 Monitors
    BEGIN TRY
        -- Write your code to add the item
        -- Remember to create a savepoint after success
        
    END TRY
    BEGIN CATCH
        -- Handle the error and rollback to appropriate savepoint
        
    END CATCH;
    
    -- Update final order total
    -- Write your code here
    
COMMIT;

-- ============================================
-- EXERCISE 4: Deadlock Prevention
-- ============================================

/*
TASK: Rewrite these two transactions to prevent deadlocks.
The original transactions access tables in different orders.
*/

-- Original Transaction A (causes deadlock):
-- BEGIN TRANSACTION;
--     UPDATE customers SET balance = balance - 100 WHERE customer_id = 1;
--     UPDATE orders SET status = 'completed' WHERE customer_id = 1;
-- COMMIT;

-- Original Transaction B (causes deadlock):
-- BEGIN TRANSACTION;
--     UPDATE orders SET total_amount = 500 WHERE order_id = 1;
--     UPDATE customers SET balance = balance + 50 WHERE customer_id = 2;
-- COMMIT;

-- YOUR IMPROVED VERSIONS:
-- Transaction A (deadlock-free):
-- Write your improved version here

-- Transaction B (deadlock-free):
-- Write your improved version here

-- ============================================
-- EXERCISE 5: Isolation Levels
-- ============================================

/*
TASK: Experiment with different isolation levels.
Run these in separate query windows to see the effects.
*/

-- Session 1: Run this first
-- YOUR CODE HERE:
-- Set isolation level to READ UNCOMMITTED
-- Begin transaction
-- Update a customer's balance but don't commit yet
-- Wait for user input before committing

-- Session 2: Run this while Session 1 is waiting
-- YOUR CODE HERE:
-- Set different isolation levels and observe behavior
-- READ UNCOMMITTED: Can you see the uncommitted change?
-- READ COMMITTED: Can you see the uncommitted change?

-- ============================================
-- EXERCISE 6: Error Handling and Logging
-- ============================================

/*
TASK: Create a robust transaction with comprehensive error handling.
Requirements:
- Create an error log table
- Log all transaction attempts
- Handle specific error types differently
- Provide meaningful error messages
*/

-- First, create an error log table
CREATE TABLE transaction_log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    transaction_type VARCHAR(50),
    customer_id INT,
    amount DECIMAL(10,2),
    status VARCHAR(20), -- 'success', 'failed'
    error_message VARCHAR(500),
    timestamp DATETIME DEFAULT GETDATE()
);

-- YOUR CODE HERE:
-- Create a procedure that:
-- 1. Attempts to process a payment
-- 2. Logs the attempt
-- 3. Handles different types of errors
-- 4. Updates the log with results

-- ============================================
-- EXERCISE 7: Batch Processing
-- ============================================

/*
TASK: Process a large number of records in batches to avoid long-running transactions.
Scenario: Update prices for all products, processing 100 at a time.
*/

-- YOUR CODE HERE:
-- Write a script that:
-- 1. Processes products in batches of 100
-- 2. Applies a 10% price increase
-- 3. Commits after each batch
-- 4. Provides progress updates
-- 5. Handles errors gracefully

-- ============================================
-- CHALLENGE EXERCISES
-- ============================================

-- Challenge 1: Multi-Customer Transfer
/*
Create a transaction that transfers money from one customer to multiple recipients.
Example: Customer 3 sends $100 each to customers 1 and 2.
*/

-- Challenge 2: Order Cancellation
/*
Create a transaction that cancels an order and restores inventory.
Handle cases where the order is already shipped or partially fulfilled.
*/

-- Challenge 3: Account Reconciliation
/*
Create a transaction that reconciles customer balances with their transaction history.
Fix any discrepancies found during the reconciliation process.
*/

-- Challenge 4: Database Migration
/*
Create a transaction that migrates data from an old table structure to a new one.
Include rollback capability if validation fails.
*/

-- ============================================
-- SOLUTIONS CHECK
-- ============================================

-- Run these queries to verify your solutions:

-- Check customer balances
SELECT customer_id, name, balance FROM customers ORDER BY customer_id;

-- Check order totals
SELECT o.order_id, c.name, o.total_amount, o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Check inventory levels
SELECT product_id, name, stock_quantity FROM products ORDER BY product_id;

-- Check transaction logs (if created)
-- SELECT * FROM transaction_log ORDER BY timestamp DESC;

-- ============================================
-- 📝 REFLECTION QUESTIONS
-- ============================================
/*
1. What happens if you don't use transactions for multi-step operations?
2. When would you choose SERIALIZABLE over READ COMMITTED isolation?
3. How do savepoints help in complex business processes?
4. What strategies can you use to minimize deadlocks?
5. How do you balance data consistency with system performance?
*/

-- ============================================
-- 🏆 COMPLETION CHECKLIST
-- ============================================
/*
□ Completed basic transaction exercise
□ Implemented order processing with inventory management
□ Used savepoints effectively
□ Prevented deadlocks through proper ordering
□ Experimented with isolation levels
□ Created comprehensive error handling
□ Implemented batch processing
□ Attempted challenge exercises
□ Answered reflection questions
*/