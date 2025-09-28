# INNER JOIN - Combining Related Data

INNER JOIN is the most commonly used join type in SQL. It returns only the rows that have matching values in both tables based on the join condition.

## 🎯 What is INNER JOIN?

An INNER JOIN combines rows from two or more tables based on a related column. It only returns records that have matching values in both tables.

**Key Characteristics:**
- Returns only matching records
- Most restrictive join type
- Default join type in most databases
- Best performance for matched data queries

## 📊 Visual Representation

```
Table A     Table B     INNER JOIN Result
┌─────┐     ┌─────┐     ┌─────────────┐
│  A  │     │  B  │ ──→ │   A ∩ B    │
│ ∩ B │     │ ∩ A │     │  (matches   │
└─────┘     └─────┘     │    only)    │
                        └─────────────┘
```

## 🔧 Basic Syntax

```sql
SELECT columns
FROM table1
INNER JOIN table2
ON table1.column = table2.column;

-- Alternative syntax (same result)
SELECT columns  
FROM table1
JOIN table2  -- INNER is optional
ON table1.column = table2.column;
```

## 📝 Practical Examples

### Example 1: Customers and Orders

```sql
-- Sample data setup
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Amount DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO Customers VALUES 
(1, 'John Smith', 'New York'),
(2, 'Jane Doe', 'Los Angeles'), 
(3, 'Bob Johnson', 'Chicago'),
(4, 'Alice Brown', 'Houston');

INSERT INTO Orders VALUES
(101, 1, '2024-01-15', 250.00),
(102, 1, '2024-01-20', 175.50),
(103, 2, '2024-01-18', 320.75),
(104, 5, '2024-01-22', 89.99);  -- CustomerID 5 doesn't exist

-- INNER JOIN query
SELECT 
    c.CustomerName,
    c.City,
    o.OrderID,
    o.OrderDate,
    o.Amount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;
```

**Result:**
```
CustomerName | City        | OrderID | OrderDate  | Amount
-------------|-------------|---------|------------|--------
John Smith   | New York    | 101     | 2024-01-15 | 250.00
John Smith   | New York    | 102     | 2024-01-20 | 175.50
Jane Doe     | Los Angeles | 103     | 2024-01-18 | 320.75
```

**Note:** Bob Johnson and Alice Brown don't appear because they have no orders. Order 104 doesn't appear because CustomerID 5 doesn't exist in Customers table.

### Example 2: Multiple Column Join

```sql
-- Joining on multiple conditions
SELECT 
    p.ProductName,
    s.SupplierName,
    p.Price
FROM Products p
INNER JOIN Suppliers s 
    ON p.SupplierID = s.SupplierID 
    AND p.Category = s.Category;
```

### Example 3: Three Table Join

```sql
-- Customers, Orders, and OrderDetails
SELECT 
    c.CustomerName,
    o.OrderDate,
    od.ProductName,
    od.Quantity,
    od.UnitPrice
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= '2024-01-01';
```

## 🚀 Advanced INNER JOIN Techniques

### Using Table Aliases
```sql
-- Makes queries more readable
SELECT 
    c.CustomerName,
    o.OrderDate,
    o.Amount
FROM Customers c  -- 'c' is alias for Customers
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;  -- 'o' is alias for Orders
```

### JOIN with WHERE Clause
```sql
-- Filter results after joining
SELECT 
    c.CustomerName,
    o.Amount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.Amount > 200.00
    AND c.City = 'New York';
```

### JOIN with Aggregate Functions
```sql
-- Customer order summaries
SELECT 
    c.CustomerName,
    COUNT(o.OrderID) as TotalOrders,
    SUM(o.Amount) as TotalSpent,
    AVG(o.Amount) as AvgOrderValue
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(o.Amount) > 300;
```

## ⚡ Performance Tips

### 1. Use Indexes on Join Columns
```sql
-- Create indexes on frequently joined columns
CREATE INDEX idx_orders_customerid ON Orders(CustomerID);
CREATE INDEX idx_customers_customerid ON Customers(CustomerID);
```

### 2. Select Only Needed Columns
```sql
-- Good: Select specific columns
SELECT c.CustomerName, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Avoid: SELECT * unless you need all columns
```

### 3. Filter Early with WHERE
```sql
-- Filter before joining when possible
SELECT c.CustomerName, o.Amount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.City = 'New York'  -- Filter reduces join workload
    AND o.OrderDate > '2024-01-01';
```

## 🔍 Common Use Cases

1. **E-commerce**: Products and Categories
2. **HR Systems**: Employees and Departments  
3. **Financial**: Accounts and Transactions
4. **CRM**: Customers and Interactions
5. **Inventory**: Items and Suppliers

## ❌ Common Mistakes

### 1. Missing JOIN Condition
```sql
-- Wrong: Creates Cartesian product
SELECT * FROM Customers, Orders;

-- Correct: Always specify join condition
SELECT * FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;
```

### 2. Wrong Join Column
```sql
-- Wrong: Joining on wrong columns
SELECT * FROM Customers c
INNER JOIN Orders o ON c.CustomerName = o.OrderID;  -- Makes no sense!

-- Correct: Join on related columns
SELECT * FROM Customers c  
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;
```

## 🛠️ Practice Exercises

1. **Basic Join**: Write an INNER JOIN to find all employees and their department names
2. **Filtered Join**: Find all orders placed by customers from 'California' with amounts > $100
3. **Three-Table Join**: Join Customers, Orders, and Products to show customer names, order dates, and product names
4. **Aggregate Join**: Calculate total sales by customer using INNER JOIN and GROUP BY

## 🔄 What's Next?

After mastering INNER JOIN, continue with:
- [LEFT JOIN](./LEFT_JOIN.md) - Include unmatched left table records
- [RIGHT JOIN](./RIGHT_JOIN.md) - Include unmatched right table records  
- [FULL OUTER JOIN](./FULL_OUTER_JOIN.md) - Include all records from both tables

---
[← Back to Joins Index](./README.md) | [Next: LEFT JOIN →](./LEFT_JOIN.md)
