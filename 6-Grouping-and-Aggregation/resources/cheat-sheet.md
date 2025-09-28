# 📚 Grouping and Aggregation - Quick Reference

Essential syntax and functions for grouping and summarizing data.

## 🔧 Basic Syntax

### GROUP BY Structure
```sql
SELECT column1, aggregate_function(column2)
FROM table_name
WHERE condition                    -- Filter before grouping
GROUP BY column1                   -- Group the results
HAVING aggregate_condition         -- Filter after grouping
ORDER BY column1;                  -- Sort the groups
```

### Key Rule
**All non-aggregate columns in SELECT must be in GROUP BY**

## 📊 Aggregate Functions

| Function | Purpose | Example | Notes |
|----------|---------|---------|-------|
| `COUNT(*)` | Count all rows | `COUNT(*)` | Includes NULLs |
| `COUNT(column)` | Count non-NULL values | `COUNT(customer_id)` | Excludes NULLs |
| `SUM(column)` | Add up values | `SUM(amount)` | Numeric only |
| `AVG(column)` | Calculate average | `AVG(price)` | Excludes NULLs |
| `MIN(column)` | Find minimum | `MIN(date)` | Works with any type |
| `MAX(column)` | Find maximum | `MAX(salary)` | Works with any type |

## 🎯 Common Patterns

### Sales by Category
```sql
SELECT category, SUM(amount) as total_sales
FROM sales
GROUP BY category;
```

### Top Performers
```sql
SELECT salesperson, COUNT(*) as sales_count
FROM sales
GROUP BY salesperson
HAVING COUNT(*) > 5
ORDER BY sales_count DESC;
```

### Multi-Level Grouping
```sql
SELECT region, product, SUM(amount) as total
FROM sales
GROUP BY region, product
ORDER BY region, total DESC;
```

## ⚡ WHERE vs HAVING

| Aspect | WHERE | HAVING |
|--------|-------|--------|
| **When Applied** | Before grouping | After grouping |
| **What it Filters** | Individual rows | Groups |
| **Can Use Aggregates** | ❌ No | ✅ Yes |
| **Performance** | ⚡ Faster | 🐌 Slower |

### Example Comparison
```sql
-- WHERE: Filter before grouping (faster)
SELECT category, COUNT(*)
FROM products
WHERE price > 100          -- Filter individual products first
GROUP BY category;

-- HAVING: Filter after grouping
SELECT category, COUNT(*)
FROM products
GROUP BY category
HAVING COUNT(*) > 5;       -- Filter groups with more than 5 products
```

## 🔄 Advanced Grouping (SQL Server/PostgreSQL)

### ROLLUP - Subtotals and Grand Total
```sql
SELECT region, product, SUM(amount)
FROM sales
GROUP BY region, product WITH ROLLUP;
```

### CUBE - All Possible Combinations
```sql
SELECT region, product, SUM(amount)
FROM sales
GROUP BY region, product WITH CUBE;
```

### GROUPING SETS - Custom Combinations
```sql
SELECT region, product, SUM(amount)
FROM sales
GROUP BY GROUPING SETS ((region), (product), ());
```

## ❌ Common Mistakes

### 1. Missing GROUP BY Column
```sql
-- ❌ Wrong: name not in GROUP BY
SELECT name, COUNT(*)
FROM employees;

-- ✅ Correct: Include all non-aggregate columns
SELECT name, COUNT(*)
FROM employees
GROUP BY name;
```

### 2. Using WHERE with Aggregates
```sql
-- ❌ Wrong: Can't use aggregates in WHERE
SELECT department, AVG(salary)
FROM employees
WHERE AVG(salary) > 50000
GROUP BY department;

-- ✅ Correct: Use HAVING for aggregate conditions
SELECT department, AVG(salary)
FROM employees
GROUP BY department
HAVING AVG(salary) > 50000;
```

### 3. Incorrect NULL Handling
```sql
-- ❌ Misleading: COUNT(*) includes NULLs
SELECT COUNT(*) as total_customers
FROM customers;

-- ✅ Better: COUNT(column) excludes NULLs
SELECT COUNT(email) as customers_with_email
FROM customers;
```

## 🎯 Performance Tips

### 1. Filter Early with WHERE
```sql
-- ✅ Good: Filter before grouping
SELECT category, SUM(amount)
FROM sales
WHERE sale_date >= '2024-01-01'    -- Reduce rows first
GROUP BY category;
```

### 2. Use Indexes on GROUP BY Columns
```sql
-- Create index for better performance
CREATE INDEX idx_sales_category ON sales(category);
```

### 3. Limit Results When Possible
```sql
-- Get top 10 categories only
SELECT TOP 10 category, SUM(amount)
FROM sales
GROUP BY category
ORDER BY SUM(amount) DESC;
```

## 📈 Business Use Cases

### Sales Reporting
```sql
-- Monthly sales totals
SELECT 
    YEAR(sale_date) as year,
    MONTH(sale_date) as month,
    SUM(amount) as monthly_total
FROM sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY year, month;
```

### Customer Analysis
```sql
-- Customer purchase patterns
SELECT 
    customer_id,
    COUNT(*) as total_orders,
    SUM(amount) as total_spent,
    AVG(amount) as avg_order_value
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY total_spent DESC;
```

### Inventory Management
```sql
-- Product performance by category
SELECT 
    category,
    COUNT(*) as product_count,
    MIN(price) as min_price,
    MAX(price) as max_price,
    AVG(price) as avg_price
FROM products
GROUP BY category;
```

## 🔍 Debugging Tips

1. **Start Simple**: Begin with basic GROUP BY, add complexity gradually
2. **Check Your Logic**: Verify that grouping makes business sense
3. **Test with Small Data**: Validate results with known sample data
4. **Use DISTINCT**: `SELECT DISTINCT column FROM table` to see unique values
5. **Count Everything**: Use `COUNT(*)` to verify group sizes

---
[← Back to Grouping & Aggregation](../README.md)