/*
===============================================
    TRANSACTIONS EXAMPLES
    Practical SQL examples for transaction control
===============================================
*/

-- ============================================
-- 1. BASIC TRANSACTION STRUCTURE
-- ============================================

-- Simple transaction example
BEGIN TRANSACTION;
    INSERT INTO customers (name, email) VALUES ('John Doe', 'john@email.com');
    UPDATE accounts SET balance = balance - 100 WHERE customer_id = 1;
    INSERT INTO transactions (customer_id, amount, type) VALUES (1, -100, 'withdrawal');
COMMIT;

-- Transaction with error handling
BEGIN TRANSACTION;
BEGIN TRY
    -- Your database operations here
    INSERT INTO orders (customer_id, total) VALUES (1, 299.99);
    UPDATE inventory SET quantity = quantity - 1 WHERE product_id = 123;
    
    -- If we get here, everything worked
    COMMIT;
    PRINT 'Transaction completed successfully';
END TRY
BEGIN CATCH
    -- Something went wrong, undo everything
    ROLLBACK;
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
END CATCH;

-- ============================================
-- 2. BANK TRANSFER EXAMPLE (ACID in Action)
-- ============================================

-- Setup: Create sample bank accounts
CREATE TABLE bank_accounts (
    account_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    balance DECIMAL(10,2)
);

INSERT INTO bank_accounts VALUES 
(1, 'Alice Johnson', 1000.00),
(2, 'Bob Smith', 500.00);

-- Transfer $200 from Alice to Bob
BEGIN TRANSACTION;
BEGIN TRY
    -- Check sufficient funds first
    DECLARE @alice_balance DECIMAL(10,2);
    SELECT @alice_balance = balance FROM bank_accounts WHERE account_id = 1;
    
    IF @alice_balance < 200
    BEGIN
        RAISERROR('Insufficient funds', 16, 1);
        RETURN;
    END
    
    -- Perform the transfer
    UPDATE bank_accounts SET balance = balance - 200 WHERE account_id = 1; -- Alice
    UPDATE bank_accounts SET balance = balance + 200 WHERE account_id = 2; -- Bob
    
    -- Log the transaction
    INSERT INTO transaction_log (from_account, to_account, amount, transaction_date)
    VALUES (1, 2, 200, GETDATE());
    
    COMMIT;
    PRINT 'Transfer completed successfully';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Transfer failed: ' + ERROR_MESSAGE();
END CATCH;

-- Verify the transfer
SELECT * FROM bank_accounts;

-- ============================================
-- 3. SAVEPOINTS EXAMPLE
-- ============================================

-- Complex transaction with multiple savepoints
BEGIN TRANSACTION;

    -- First operation
    INSERT INTO orders (customer_id, order_date) VALUES (1, GETDATE());
    DECLARE @order_id INT = SCOPE_IDENTITY();
    
    SAVE TRANSACTION after_order_insert;
    
    -- Second operation - add order items
    BEGIN TRY
        INSERT INTO order_items (order_id, product_id, quantity, price) 
        VALUES (@order_id, 101, 2, 25.99);
        
        INSERT INTO order_items (order_id, product_id, quantity, price) 
        VALUES (@order_id, 102, 1, 49.99);
        
        SAVE TRANSACTION after_items_insert;
    END TRY
    BEGIN CATCH
        -- Rollback to savepoint if item insertion fails
        ROLLBACK TRANSACTION after_order_insert;
        PRINT 'Order items insertion failed, rolling back to order creation';
    END CATCH
    
    -- Third operation - update inventory
    BEGIN TRY
        UPDATE inventory SET quantity = quantity - 2 WHERE product_id = 101;
        UPDATE inventory SET quantity = quantity - 1 WHERE product_id = 102;
        
        SAVE TRANSACTION after_inventory_update;
    END TRY
    BEGIN CATCH
        -- Rollback to savepoint if inventory update fails
        ROLLBACK TRANSACTION after_items_insert;
        PRINT 'Inventory update failed, rolling back to items insertion';
    END CATCH
    
    -- If everything succeeded, commit the entire transaction
    COMMIT;
    PRINT 'Complete order processing successful';

-- ============================================
-- 4. ISOLATION LEVELS DEMONSTRATION
-- ============================================

-- READ UNCOMMITTED (Dirty Reads Allowed)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION;
    SELECT * FROM products WHERE price > 100;
    -- Can see uncommitted changes from other transactions
COMMIT;

-- READ COMMITTED (Default - No Dirty Reads)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
    SELECT * FROM products WHERE price > 100;
    -- Only sees committed data
COMMIT;

-- REPEATABLE READ (No Phantom Reads)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
    SELECT COUNT(*) FROM products WHERE category = 'Electronics';
    WAITFOR DELAY '00:00:05'; -- Wait 5 seconds
    SELECT COUNT(*) FROM products WHERE category = 'Electronics';
    -- Count should be the same both times
COMMIT;

-- SERIALIZABLE (Highest Isolation)
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
    SELECT * FROM products WHERE category = 'Books';
    -- No other transaction can modify 'Books' products
    INSERT INTO products (name, category, price) VALUES ('New Book', 'Books', 29.99);
COMMIT;

-- ============================================
-- 5. DEADLOCK PREVENTION EXAMPLE
-- ============================================

-- Always access tables in the same order to prevent deadlocks
-- BAD: Different order in different transactions
-- Transaction 1: UPDATE customers, then UPDATE orders
-- Transaction 2: UPDATE orders, then UPDATE customers

-- GOOD: Same order in all transactions
BEGIN TRANSACTION;
    -- Always update customers first, then orders
    UPDATE customers SET last_order_date = GETDATE() WHERE customer_id = 1;
    UPDATE orders SET status = 'completed' WHERE customer_id = 1 AND status = 'pending';
COMMIT;

-- ============================================
-- 6. LONG-RUNNING TRANSACTION PATTERN
-- ============================================

-- Process large dataset in batches to avoid blocking
DECLARE @batch_size INT = 1000;
DECLARE @rows_processed INT = 0;
DECLARE @total_rows INT;

SELECT @total_rows = COUNT(*) FROM large_table WHERE needs_processing = 1;

WHILE @rows_processed < @total_rows
BEGIN
    BEGIN TRANSACTION;
    
    -- Process a batch
    UPDATE TOP (@batch_size) large_table 
    SET processed = 1, processed_date = GETDATE()
    WHERE needs_processing = 1;
    
    SET @rows_processed = @rows_processed + @@ROWCOUNT;
    
    COMMIT;
    
    -- Give other transactions a chance
    WAITFOR DELAY '00:00:01';
    
    PRINT 'Processed ' + CAST(@rows_processed AS VARCHAR) + ' of ' + CAST(@total_rows AS VARCHAR) + ' rows';
END;

-- ============================================
-- 7. TRANSACTION LOG MANAGEMENT
-- ============================================

-- Check transaction log space usage
DBCC SQLPERF(LOGSPACE);

-- Backup transaction log (SQL Server)
BACKUP LOG YourDatabase TO DISK = 'C:\Backup\YourDatabase_Log.bak';

-- Checkpoint to write dirty pages to disk
CHECKPOINT;

-- ============================================
-- 8. COMMON TRANSACTION PATTERNS
-- ============================================

-- Pattern 1: Order Processing
CREATE PROCEDURE ProcessOrder
    @customer_id INT,
    @product_id INT,
    @quantity INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validate customer
        IF NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = @customer_id)
        BEGIN
            RAISERROR('Invalid customer ID', 16, 1);
            RETURN;
        END
        
        -- Check inventory
        DECLARE @available_qty INT;
        SELECT @available_qty = quantity FROM inventory WHERE product_id = @product_id;
        
        IF @available_qty < @quantity
        BEGIN
            RAISERROR('Insufficient inventory', 16, 1);
            RETURN;
        END
        
        -- Create order
        INSERT INTO orders (customer_id, order_date, status) 
        VALUES (@customer_id, GETDATE(), 'processing');
        
        DECLARE @order_id INT = SCOPE_IDENTITY();
        
        -- Add order item
        INSERT INTO order_items (order_id, product_id, quantity)
        VALUES (@order_id, @product_id, @quantity);
        
        -- Update inventory
        UPDATE inventory SET quantity = quantity - @quantity WHERE product_id = @product_id;
        
        COMMIT;
        PRINT 'Order processed successfully. Order ID: ' + CAST(@order_id AS VARCHAR);
        
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Order processing failed: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;

-- Pattern 2: Data Migration with Rollback
BEGIN TRANSACTION;
BEGIN TRY
    -- Create backup table
    SELECT * INTO customers_backup FROM customers;
    
    -- Perform migration
    UPDATE customers SET email = LOWER(email) WHERE email IS NOT NULL;
    UPDATE customers SET phone = REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', '') WHERE phone IS NOT NULL;
    
    -- Validate results
    DECLARE @invalid_emails INT;
    SELECT @invalid_emails = COUNT(*) FROM customers WHERE email NOT LIKE '%@%';
    
    IF @invalid_emails > 0
    BEGIN
        RAISERROR('Data validation failed - invalid emails found', 16, 1);
        RETURN;
    END
    
    COMMIT;
    
    -- Drop backup table on success
    DROP TABLE customers_backup;
    PRINT 'Data migration completed successfully';
    
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Data migration failed: ' + ERROR_MESSAGE();
    PRINT 'Original data preserved in customers_backup table';
END CATCH;

-- ============================================
-- 📚 KEY TAKEAWAYS
-- ============================================
-- 1. Always use transactions for multi-step operations
-- 2. Handle errors with TRY/CATCH blocks
-- 3. Use savepoints for complex transactions
-- 4. Choose appropriate isolation levels
-- 5. Keep transactions as short as possible
-- 6. Always consider deadlock prevention
-- 7. Test transaction behavior under load
-- 8. Monitor transaction log growth

-- ============================================
-- 🔄 NEXT STEPS
-- ============================================
-- Practice with: exercises/transaction-exercises.sql
-- Learn about: 11-Constraints for data integrity
-- Advanced topic: Distributed transactions