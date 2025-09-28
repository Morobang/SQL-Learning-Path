# 7. Joins - Combining Data from Multiple Tables

Joins are one of the most powerful features of SQL, allowing you to combine data from multiple tables based on relationships between them.

## 📋 Learning Objectives
By the end of this section, you will be able to:
- Understand different types of SQL joins
- Write INNER JOIN queries to combine related data
- Use LEFT and RIGHT JOINs to include unmatched records
- Perform FULL OUTER JOINs for complete data sets
- Use CROSS JOINs for Cartesian products
- Create SELF JOINs to relate a table to itself
- Optimize join performance

## 📚 Join Types Covered

### [INNER JOIN](./INNER_JOIN.md)
- Most common join type
- Returns only matching records from both tables
- Essential for relational data queries
- Performance considerations

### [LEFT JOIN (LEFT OUTER JOIN)](./LEFT_JOIN.md)
- Returns all records from left table
- Returns matching records from right table
- NULL values for non-matching right table records

### [RIGHT JOIN (RIGHT OUTER JOIN)](./RIGHT_JOIN.md)
- Returns all records from right table
- Returns matching records from left table
- NULL values for non-matching left table records

### [FULL OUTER JOIN](./FULL_OUTER_JOIN.md)
- Returns all records from both tables
- NULL values where no match exists
- Less commonly used but powerful

### [CROSS JOIN](./CROSS_JOIN.md)
- Cartesian product of both tables
- Every row from first table with every row from second table
- Use with caution - can create huge result sets

### [SELF JOIN](./SELF_JOIN.md)
- Joining a table to itself
- Useful for hierarchical data
- Employee-manager relationships
- Comparing rows within the same table

## 🎯 Prerequisites
- Completed [6-Grouping-and-Aggregation](../6-Grouping-and-Aggregation/README.md)
- Understanding of table relationships
- Familiarity with SELECT statements

## ⏱️ Estimated Time
4-5 hours to master all join types

## 🛠️ Practice Scenarios

### Sample Tables for Practice
```sql
-- Customers table
CustomerID | CustomerName | City
1         | John Smith   | New York
2         | Jane Doe     | Los Angeles
3         | Bob Johnson  | Chicago

-- Orders table  
OrderID | CustomerID | OrderDate  | Amount
101     | 1          | 2024-01-15 | 250.00
102     | 1          | 2024-01-20 | 175.50
103     | 2          | 2024-01-18 | 320.75
104     | 4          | 2024-01-22 | 89.99
```

### Practice Exercises
1. **INNER JOIN**: Find all customers who have placed orders
2. **LEFT JOIN**: List all customers, including those without orders
3. **RIGHT JOIN**: Show all orders, including those with invalid customer IDs
4. **FULL OUTER JOIN**: Complete view of customers and orders
5. **SELF JOIN**: Find employees and their managers

## 🔍 Visual Join Guide

```
INNER JOIN:     LEFT JOIN:      RIGHT JOIN:     FULL OUTER JOIN:
   A ∩ B           A ∪ B            A ∪ B           A ∪ B
    ═══            ═══○             ○═══            ○═══○
   Only            All A +          All B +         All A +
   matches         matches          matches         All B
```

## 🚀 Advanced Topics
- Multiple table joins (3+ tables)
- Join optimization techniques
- Index usage in joins
- Join algorithms (Nested Loop, Hash, Merge)
- Subqueries vs Joins performance

## 🔄 Navigation
[← Previous: Grouping & Aggregation](../6-Grouping-and-Aggregation/README.md) | [Next: Subqueries & CTEs →](../8-Subqueries-and-CTEs/README.md)

---
[🏠 Back to Main](../README.md)