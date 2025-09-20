```mermaid
mindmap
  root((Composite Indexes))
    
    📚 What They Are
      Multiple columns in one index
      :Like a phone book: sorted by last name, then first name
      More efficient than multiple single-column indexes
    
    🎯 How They Work
      Column Order Matters
        📋 Leftmost prefix principle
        🔍 Index (A,B,C) can search:
          A alone
          A AND B
          A AND B AND C
        🚫 But NOT: B alone, C alone, B AND C
    
    💡 When to Use
      Multiple WHERE conditions
        WHERE country = 'US' AND city = 'NYC'
      Covering queries
        SELECT email FROM users WHERE country='US' AND city='NYC'
      Multi-column sorting
        ORDER BY last_name, first_name
    
    ⚠️ Limitations
      Leftmost Prefix Rule
        Index (A,B,C) can't help queries with only B or C
      Storage Overhead
        Larger than single-column indexes
      Maintenance Cost
        Slower inserts/updates on indexed columns
    
    🛠️ Best Practices
      Column Order Strategy
        High selectivity first (most unique values)
        Most frequently used columns first
        Equality before range columns
      Real-World Examples
        📊 (category, price) for e-commerce
        📅 (user_id, date) for time-series
        👥 (last_name, first_name) for people search
    
    🔍 Common Mistakes
      Wrong Column Order
        (country, city) vs (city, country)
      Redundant Indexes
        (A) and (A,B) - the first is redundant
      Indexing Low-Selectivity Columns
        (gender, last_name) - gender doesn't help much
```

# 📚 Composite Indexes: The Ultimate Guide

## 🎯 What Are Composite Indexes?

A **composite index** (also called a **compound index** or **multi-column index**) is an index that includes multiple columns. Think of it like a phone book that's sorted by **last name + first name** instead of just last name alone.

## 🏗️ Basic Syntax

```sql
CREATE INDEX index_name ON table_name (column1, column2, column3, ...);
```

## 📊 Sample Data: Users Table

Let's create a realistic example:

```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    country VARCHAR(50),
    city VARCHAR(50),
    signup_date DATE,
    last_login DATE
);

-- Insert 1,000,000+ users from around the world
```

## 🔍 How Composite Indexes Work: The Phone Book Analogy

### Single Index (Phone Book by Last Name Only):
```
Smith, John
Smith, Jane
Smith, Bob
Johnson, Amy
Johnson, David
```

### Composite Index (Phone Book by Last Name + First Name):
```
Johnson, Amy
Johnson, David
Smith, Bob  
Smith, Jane
Smith, John
```

**The composite index is sorted by the first column, then the second, and so on!**

## 🎯 When to Use Composite Indexes

### 1. Multiple WHERE Conditions
```sql
-- Without composite index (might be slow)
SELECT * FROM users 
WHERE country = 'USA' AND city = 'New York';

-- Create composite index
CREATE INDEX idx_users_country_city ON users(country, city);

-- Now super fast! ⚡
SELECT * FROM users 
WHERE country = 'USA' AND city = 'New York';
```

### 2. Covering Queries (Index-Only Scans)
```sql
-- If we only need indexed columns
CREATE INDEX idx_users_country_city_email ON users(country, city, email);

-- This query can be answered using ONLY the index! 🚀
SELECT email FROM users 
WHERE country = 'USA' AND city = 'New York';
```

### 3. Multi-Column Sorting
```sql
-- Without index: Database must sort all data
SELECT * FROM users 
ORDER BY last_name, first_name;

-- Create composite index for sorting
CREATE INDEX idx_users_name_sort ON users(last_name, first_name);

-- Now sorting is instant! ⚡
SELECT * FROM users 
ORDER BY last_name, first_name;
```

## ⚠️ The Leftmost Prefix Rule: IMPORTANT!

**Composite indexes only help queries that use the leftmost columns!**

```sql
-- Index: (country, city, signup_date)

-- ✅ These queries can use the index:
SELECT * FROM users WHERE country = 'USA';
SELECT * FROM users WHERE country = 'USA' AND city = 'New York';
SELECT * FROM users WHERE country = 'USA' AND city = 'New York' AND signup_date > '2023-01-01';

-- ❌ These queries CANNOT use the index effectively:
SELECT * FROM users WHERE city = 'New York';                      -- Missing country
SELECT * FROM users WHERE signup_date > '2023-01-01';             -- Missing country & city
SELECT * FROM users WHERE city = 'New York' AND signup_date > '2023-01-01'; -- Missing country
```

## 🎯 Smart Column Ordering

### Rule 1: Put High-Selectivity Columns First
```sql
-- ❌ Bad: country has low selectivity (few unique values)
CREATE INDEX idx_bad_order ON users(country, last_name);

-- ✅ Better: last_name has high selectivity (many unique values)  
CREATE INDEX idx_good_order ON users(last_name, country);
```

### Rule 2: Put Equality Columns Before Range Columns
```sql
-- ❌ Bad: range column first
CREATE INDEX idx_bad_range ON users(signup_date, country);

-- ✅ Better: equality columns first, then range
CREATE INDEX idx_good_range ON users(country, signup_date);
```

## 📊 Real-World Examples

### Example 1: E-commerce Product Search
```sql
-- Common query: Filter by category, price range, and brand
SELECT * FROM products 
WHERE category = 'electronics' 
AND price BETWEEN 100 AND 500
AND brand = 'Sony';

-- Optimal composite index:
CREATE INDEX idx_products_category_brand_price 
ON products(category, brand, price);
```

### Example 2: User Analytics Dashboard
```sql
-- Common query: Users from specific country who signed up in date range
SELECT * FROM users 
WHERE country = 'USA' 
AND signup_date BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY signup_date DESC;

-- Optimal composite index:
CREATE INDEX idx_users_country_signupdate 
ON users(country, signup_date);
```

### Example 3: Social Media Feed
```sql
-- Common query: Posts by user, sorted by date
SELECT * FROM posts 
WHERE user_id = 123 
AND created_at > '2023-01-01'
ORDER BY created_at DESC;

-- Optimal composite index:
CREATE INDEX idx_posts_user_created 
ON posts(user_id, created_at);
```

## ⚠️ Common Composite Index Mistakes

### Mistake 1: Redundant Indexes
```sql
-- ❌ Redundant: single index is covered by composite
CREATE INDEX idx_users_country ON users(country);
CREATE INDEX idx_users_country_city ON users(country, city);  -- Already covers country queries!

-- ✅ Better: Just create the composite index
CREATE INDEX idx_users_country_city ON users(country, city);
```

### Mistake 2: Wrong Column Order for Sorting
```sql
-- ❌ Bad: Can't help this sort query
CREATE INDEX idx_users_city_country ON users(city, country);

-- Query needs different order:
SELECT * FROM users ORDER BY country, city;

-- ✅ Better: Match index order to query order
CREATE INDEX idx_users_country_city ON users(country, city);
```

### Mistake 3: Too Many Columns
```sql
-- ❌ Too many columns = big index, slow updates
CREATE INDEX idx_too_many_columns ON users(
    country, city, last_name, first_name, email, 
    signup_date, last_login, account_status
);

-- ✅ Better: Only include columns actually used in queries
CREATE INDEX idx_optimized ON users(country, city, last_name);
```

## 🧪 Testing Index Effectiveness

### Use EXPLAIN to See Query Plans:
```sql
-- See if your index is being used
EXPLAIN SELECT * FROM users 
WHERE country = 'USA' AND city = 'New York';

-- Look for "Index Scan" or "Index Only Scan" in results
```

### Compare Performance:
```sql
-- Test without index
-- Timing: 350ms
SELECT * FROM users WHERE country = 'USA' AND city = 'New York';

-- Create index
CREATE INDEX idx_users_country_city ON users(country, city);

-- Test with index  
-- Timing: 5ms ⚡ (70x faster!)
SELECT * FROM users WHERE country = 'USA' AND city = 'New York';
```

## 🚀 Advanced: INCLUDE Columns (PostgreSQL)

Some databases allow including non-search columns for covering queries:

```sql
-- PostgreSQL syntax: Include email for index-only scans
CREATE INDEX idx_users_country_city_include_email 
ON users(country, city) INCLUDE (email);

-- Now this query uses index only:
SELECT email FROM users 
WHERE country = 'USA' AND city = 'New York';
```

## 📝 Best Practices Summary

1. **Use for multiple WHERE conditions** 🎯
2. **Put high-selectivity columns first** 📊
3. **Match column order to query patterns** 🔍
4. **Consider covering queries** 🚀
5. **Avoid redundant indexes** ❌
6. **Test with EXPLAIN** 🧪
7. **Monitor index usage** 📈

## 🎓 Your Composite Index Action Plan

1. **Identify slow multi-column queries** in your application
2. **Analyze query patterns** to determine column order
3. **Create composite indexes** based on most common filters
4. **Test performance** before and after
5. **Use EXPLAIN** to verify index usage
6. **Monitor and adjust** as query patterns change

Remember: **Composite indexes are like compound words - they work together to create new meaning and efficiency!** 🌟