# 🔍 Filtering and Conditions

Master SQL filtering techniques to retrieve exactly the data you need from your databases.

## 📋 What You'll Learn

This section covers all aspects of filtering data in SQL, from basic comparisons to complex conditional logic.

### Core Topics
- **Comparison Operators**: `=`, `<>`, `<`, `>`, `<=`, `>=`
- **Logical Operators**: `AND`, `OR`, `NOT`
- **Special Operators**: `IN`, `BETWEEN`, `LIKE`, `IS NULL`
- **Conditional Logic**: `CASE` statements and expressions

## 📁 Folder Structure

```
4-Filtering-and-Conditions/
├── concepts/           # Theory and explanations
│   ├── comparison-operators.md
│   ├── logical-operators.md
│   ├── pattern-matching.md
│   └── conditional-expressions.md
├── examples/           # Practical SQL examples
│   ├── 01-comparison-operators.sql
│   ├── 02-logical-operators.sql
│   ├── 03-special-operators.sql
│   └── 04-case-statements.sql
├── exercises/          # Practice problems
│   └── filtering-exercises.sql
└── resources/          # Additional learning materials
    └── filtering-resources.md
```

## 🎯 Learning Objectives

By the end of this section, you will:

1. **Master Comparison Operators**
   - Use all comparison operators effectively
   - Handle different data types in comparisons
   - Work with NULL values properly

2. **Combine Conditions**
   - Use logical operators to build complex filters
   - Understand operator precedence
   - Group conditions with parentheses

3. **Apply Pattern Matching**
   - Use LIKE with wildcards for text searches
   - Work with regular expressions (database-specific)
   - Handle case sensitivity issues

4. **Build Conditional Logic**
   - Create CASE expressions for data transformation
   - Use CASE in SELECT, WHERE, and ORDER BY clauses
   - Implement complex business rules

## 🚀 Quick Start

1. **Start with Concepts**: Read the theory files to understand the fundamentals
2. **Study Examples**: Examine the SQL examples to see filtering in action
3. **Practice**: Work through exercises to reinforce your learning
4. **Explore Resources**: Use additional materials for deeper understanding

## 💡 Key Concepts Preview

### Comparison Operators
```sql
-- Basic comparisons
SELECT * FROM products WHERE price > 100;
SELECT * FROM customers WHERE city = 'New York';
SELECT * FROM orders WHERE order_date <> '2023-01-01';
```

### Logical Operators
```sql
-- Combining conditions
SELECT * FROM products 
WHERE price > 50 AND category = 'Electronics';

SELECT * FROM customers 
WHERE city = 'London' OR city = 'Paris';
```

### Pattern Matching
```sql
-- Using LIKE with wildcards
SELECT * FROM customers WHERE name LIKE 'John%';
SELECT * FROM products WHERE code LIKE 'A_B%';
```

### Conditional Logic
```sql
-- CASE expressions
SELECT name, price,
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price < 200 THEN 'Mid-range'
        ELSE 'Premium'
    END as price_category
FROM products;
```

## 🔗 Prerequisites

Before starting this section, make sure you're comfortable with:
- Basic SQL syntax (Section 1)
- SELECT statements (Section 3)
- Basic data types (Section 2)

## ➡️ Next Steps

After completing this section, you'll be ready for:
- **Functions** (Section 5): Apply functions to filtered data
- **Grouping and Aggregation** (Section 6): Group filtered results
- **Joins** (Section 7): Filter data across multiple tables

## 🎯 Real-World Applications

- **E-commerce**: Filter products by price range, category, availability
- **Customer Management**: Find customers by location, purchase history
- **Reporting**: Create conditional reports based on business rules
- **Data Analysis**: Segment data for analysis and insights

## 📚 Quick Reference

| Operator | Purpose | Example |
|----------|---------|---------|
| `=` | Equal to | `price = 100` |
| `<>` or `!=` | Not equal to | `status <> 'inactive'` |
| `>` | Greater than | `age > 18` |
| `>=` | Greater than or equal | `salary >= 50000` |
| `<` | Less than | `quantity < 10` |
| `<=` | Less than or equal | `discount <= 0.2` |
| `AND` | Both conditions true | `A AND B` |
| `OR` | Either condition true | `A OR B` |
| `NOT` | Negates condition | `NOT A` |
| `IN` | Value in list | `city IN ('NYC', 'LA')` |
| `BETWEEN` | Value in range | `price BETWEEN 10 AND 50` |
| `LIKE` | Pattern matching | `name LIKE 'John%'` |
| `IS NULL` | Null value check | `email IS NULL` |

Start your journey into effective data filtering! 🔍