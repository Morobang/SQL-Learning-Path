# CRUD Operations

Master the four fundamental database operations: Create, Read, Update, and Delete - the building blocks of all database interactions.

## What is CRUD?

**CRUD** is an acronym that represents the four basic operations you can perform on data:
- **C**reate - Add new data (INSERT)
- **R**ead - Retrieve existing data (SELECT)
- **U**pdate - Modify existing data (UPDATE)
- **D**elete - Remove data (DELETE)

These operations correspond to the primary SQL statements that every database developer needs to master.

## CREATE (INSERT) Operations

### Basic INSERT Syntax
```sql
INSERT INTO table_name (column1, column2, column3)
VALUES (value1, value2, value3);
```

### Single Record Insert
```sql
-- Insert a new customer
INSERT INTO customers (name, email, phone, city)
VALUES ('John Doe', 'john@email.com', '555-1234', 'New York');
```

### Multiple Records Insert
```sql
-- Insert multiple customers at once
INSERT INTO customers (name, email, phone, city)
VALUES 
    ('Jane Smith', 'jane@email.com', '555-5678', 'Los Angeles'),
    ('Bob Johnson', 'bob@email.com', '555-9012', 'Chicago'),
    ('Alice Brown', 'alice@email.com', '555-3456', 'Houston');
```

### INSERT with Auto-Increment
```sql
-- When ID is auto-generated
INSERT INTO customers (name, email, phone)
VALUES ('Mike Wilson', 'mike@email.com', '555-7890');

-- Get the generated ID (varies by database)
-- MySQL: SELECT LAST_INSERT_ID();
-- PostgreSQL: INSERT ... RETURNING id;
-- SQL Server: SELECT SCOPE_IDENTITY();
```

### INSERT from SELECT (Copy Data)
```sql
-- Copy customers from one table to another
INSERT INTO customers_backup (name, email, phone)
SELECT name, email, phone 
FROM customers 
WHERE registration_date >= '2023-01-01';
```

## READ (SELECT) Operations

### Basic SELECT Syntax
```sql
SELECT column1, column2
FROM table_name
WHERE condition;
```

### Select All Data
```sql
SELECT * FROM customers;
```

### Select Specific Columns
```sql
SELECT name, email FROM customers;
```

### Conditional Selection
```sql
-- Single condition
SELECT * FROM customers WHERE city = 'New York';

-- Multiple conditions
SELECT * FROM customers 
WHERE city = 'New York' AND registration_date >= '2023-01-01';

-- Pattern matching
SELECT * FROM customers WHERE name LIKE 'John%';

-- Range selection
SELECT * FROM products WHERE price BETWEEN 100 AND 500;
```

### Sorting Results
```sql
-- Sort by single column
SELECT * FROM customers ORDER BY name;

-- Sort by multiple columns
SELECT * FROM customers ORDER BY city, name;

-- Descending order
SELECT * FROM customers ORDER BY registration_date DESC;
```

### Limiting Results
```sql
-- MySQL/PostgreSQL
SELECT * FROM customers LIMIT 10;

-- SQL Server
SELECT TOP 10 * FROM customers;

-- Pagination
SELECT * FROM customers LIMIT 10 OFFSET 20;  -- Skip 20, take 10
```

## UPDATE Operations

### Basic UPDATE Syntax
```sql
UPDATE table_name
SET column1 = value1, column2 = value2
WHERE condition;
```

### Update Single Record
```sql
-- Update one customer's email
UPDATE customers 
SET email = 'newemail@example.com'
WHERE customer_id = 1;
```

### Update Multiple Records
```sql
-- Update all customers in New York
UPDATE customers 
SET city = 'NYC'
WHERE city = 'New York';
```

### Update Multiple Columns
```sql
-- Update multiple fields at once
UPDATE customers 
SET 
    email = 'updated@email.com',
    phone = '555-0000',
    last_updated = CURRENT_TIMESTAMP
WHERE customer_id = 1;
```

### Conditional Updates
```sql
-- Update based on multiple conditions
UPDATE products 
SET price = price * 1.1  -- 10% increase
WHERE category = 'Electronics' 
AND stock_quantity > 0;
```

### Update with Calculations
```sql
-- Increase all prices by 5%
UPDATE products 
SET price = price * 1.05;

-- Update based on other column values
UPDATE employees 
SET bonus = salary * 0.1
WHERE performance_rating >= 4;
```

## DELETE Operations

### Basic DELETE Syntax
```sql
DELETE FROM table_name
WHERE condition;
```

### Delete Specific Records
```sql
-- Delete one customer
DELETE FROM customers 
WHERE customer_id = 1;

-- Delete customers from specific city
DELETE FROM customers 
WHERE city = 'Chicago';
```

### Delete with Complex Conditions
```sql
-- Delete inactive customers older than 2 years
DELETE FROM customers 
WHERE status = 'inactive' 
AND last_login < DATE_SUB(NOW(), INTERVAL 2 YEAR);
```

### Delete All Records (Dangerous!)
```sql
-- Delete all records (keeps table structure)
DELETE FROM customers;

-- Alternative: TRUNCATE (faster, resets auto-increment)
TRUNCATE TABLE customers;
```

## Advanced CRUD Patterns

### UPSERT (INSERT or UPDATE)

**MySQL - ON DUPLICATE KEY UPDATE:**
```sql
INSERT INTO customers (id, name, email)
VALUES (1, 'John Doe', 'john@email.com')
ON DUPLICATE KEY UPDATE 
    name = VALUES(name),
    email = VALUES(email);
```

**PostgreSQL - ON CONFLICT:**
```sql
INSERT INTO customers (id, name, email)
VALUES (1, 'John Doe', 'john@email.com')
ON CONFLICT (id) 
DO UPDATE SET 
    name = EXCLUDED.name,
    email = EXCLUDED.email;
```

**SQL Server - MERGE:**
```sql
MERGE customers AS target
USING (VALUES (1, 'John Doe', 'john@email.com')) AS source (id, name, email)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET name = source.name, email = source.email
WHEN NOT MATCHED THEN
    INSERT (id, name, email) VALUES (source.id, source.name, source.email);
```

### Bulk Operations

**Bulk INSERT:**
```sql
-- Load data from CSV file
LOAD DATA INFILE 'customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

**Bulk UPDATE:**
```sql
-- Update using temporary table
CREATE TEMPORARY TABLE price_updates (
    product_id INT,
    new_price DECIMAL(10,2)
);

-- Load new prices
INSERT INTO price_updates VALUES (1, 199.99), (2, 299.99);

-- Apply updates
UPDATE products p
JOIN price_updates pu ON p.product_id = pu.product_id
SET p.price = pu.new_price;
```

## CRUD with Relationships

### INSERT with Foreign Keys
```sql
-- First, insert the parent record
INSERT INTO customers (name, email)
VALUES ('John Doe', 'john@email.com');

-- Then, insert child records
INSERT INTO orders (customer_id, order_date, total)
VALUES (LAST_INSERT_ID(), NOW(), 299.99);
```

### JOIN in SELECT (Read Related Data)
```sql
-- Get customers with their orders
SELECT 
    c.name,
    c.email,
    o.order_date,
    o.total
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.name, o.order_date;
```

### UPDATE with JOINs
```sql
-- Update customer total spent
UPDATE customers c
SET total_spent = (
    SELECT COALESCE(SUM(total), 0)
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

### DELETE with Relationships
```sql
-- Delete orders first (child records)
DELETE FROM orders WHERE customer_id = 1;

-- Then delete customer (parent record)
DELETE FROM customers WHERE customer_id = 1;

-- Or use CASCADE constraints for automatic deletion
ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
ON DELETE CASCADE;
```

## Transaction-Safe CRUD

### Using Transactions
```sql
-- Start transaction
BEGIN TRANSACTION;

try {
    -- Perform multiple CRUD operations
    INSERT INTO customers (name, email) VALUES ('John Doe', 'john@email.com');
    UPDATE accounts SET balance = balance - 100 WHERE customer_id = 1;
    INSERT INTO transactions (customer_id, amount) VALUES (1, -100);
    
    -- If all succeed, commit
    COMMIT;
} catch {
    -- If any fail, rollback
    ROLLBACK;
}
```

## Performance Considerations

### Indexing for CRUD
```sql
-- Index for frequent WHERE clauses
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
```

### Batch Processing
```sql
-- Instead of many single INSERTs
INSERT INTO products (name, price) VALUES ('Product A', 19.99);
INSERT INTO products (name, price) VALUES ('Product B', 29.99);
-- ... repeat 1000 times

-- Use batch INSERT
INSERT INTO products (name, price) VALUES 
('Product A', 19.99),
('Product B', 29.99),
-- ... up to 1000 rows at once
```

## Common CRUD Patterns

### Audit Trail Pattern
```sql
-- Add audit columns to tables
ALTER TABLE customers ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE customers ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE customers ADD COLUMN created_by VARCHAR(50);
ALTER TABLE customers ADD COLUMN updated_by VARCHAR(50);
```

### Soft Delete Pattern
```sql
-- Instead of DELETE, mark as deleted
ALTER TABLE customers ADD COLUMN deleted_at TIMESTAMP NULL;
ALTER TABLE customers ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;

-- "Delete" a customer
UPDATE customers 
SET is_deleted = TRUE, deleted_at = NOW()
WHERE customer_id = 1;

-- Query only active customers
SELECT * FROM customers WHERE is_deleted = FALSE;
```

### Versioning Pattern
```sql
-- Keep version number for optimistic locking
ALTER TABLE customers ADD COLUMN version INT DEFAULT 1;

-- Update with version check
UPDATE customers 
SET name = 'New Name', version = version + 1
WHERE customer_id = 1 AND version = 1;
```

## Best Practices

### Safety First
1. **Always use WHERE in UPDATE/DELETE** (unless you really mean to affect all rows)
2. **Test queries with SELECT first** before UPDATE/DELETE
3. **Use transactions** for multi-step operations
4. **Backup before bulk operations**

### Performance
1. **Use indexes** on columns in WHERE clauses
2. **Batch operations** when possible
3. **Limit result sets** when you don't need all data
4. **Use appropriate data types** for storage efficiency

### Maintainability
1. **Use meaningful column names**
2. **Add comments** to complex queries
3. **Consistent formatting** for readability
4. **Document business rules** in constraints

CRUD operations are the foundation of all database applications. Master these patterns and you'll be able to handle most database tasks efficiently and safely!