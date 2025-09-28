# 🔍 Subqueries and Common Table Expressions (CTEs)

Master advanced query techniques using subqueries and CTEs to write powerful, readable SQL code.

## 📋 What You'll Learn

This section covers subqueries and Common Table Expressions (CTEs), essential tools for writing complex queries that break down difficult problems into manageable parts.

### Core Topics
- **Subquery Fundamentals**: Single-row, multi-row, and scalar subqueries
- **Correlated Subqueries**: Subqueries that reference outer query columns
- **Common Table Expressions**: WITH clauses for improved readability
- **Recursive CTEs**: Self-referencing queries for hierarchical data

## 📁 Folder Structure

```
8-Subqueries-and-CTEs/
├── concepts/           # Theory and explanations
│   ├── subquery-basics.md
│   ├── correlated-subqueries.md
│   ├── common-table-expressions.md
│   └── recursive-ctes.md
├── examples/           # Practical SQL examples
│   ├── 01-basic-subqueries.sql
│   ├── 02-correlated-subqueries.sql
│   ├── 03-common-table-expressions.sql
│   └── 04-recursive-ctes.sql
├── exercises/          # Practice problems
│   └── subquery-cte-exercises.sql
└── resources/          # Additional learning materials
    └── subquery-cte-resources.md
```

## 🎯 Learning Objectives

By the end of this section, you will:

1. **Master Subqueries**
   - Write subqueries in SELECT, WHERE, and FROM clauses
   - Understand when to use subqueries vs JOINs
   - Handle single-row and multi-row subqueries

2. **Work with Correlated Subqueries**
   - Create subqueries that reference outer query data
   - Use EXISTS and NOT EXISTS effectively
   - Optimize correlated subquery performance

3. **Utilize Common Table Expressions**
   - Write readable complex queries with CTEs
   - Use multiple CTEs in a single query
   - Replace complex subqueries with CTEs

4. **Implement Recursive CTEs**
   - Query hierarchical data structures
   - Generate sequences and series
   - Traverse tree-like data relationships

## 🚀 Quick Start

1. **Start with Concepts**: Read about subquery types and CTE fundamentals
2. **Study Examples**: Examine practical implementations in the examples folder
3. **Practice**: Work through exercises to build confidence
4. **Explore Resources**: Use additional materials for advanced techniques

## 💡 Key Concepts Preview

### Basic Subqueries
```sql
-- Subquery in WHERE clause
SELECT name, salary 
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Subquery in FROM clause
SELECT dept_name, avg_salary
FROM (SELECT department_id, AVG(salary) as avg_salary 
      FROM employees GROUP BY department_id) dept_avg
JOIN departments ON dept_avg.department_id = departments.department_id;
```

### Correlated Subqueries
```sql
-- EXISTS example
SELECT customer_name 
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- Correlated subquery for ranking
SELECT employee_name, salary,
       (SELECT COUNT(*) FROM employees e2 
        WHERE e2.salary > e1.salary AND e2.department_id = e1.department_id) + 1 as rank
FROM employees e1;
```

### Common Table Expressions
```sql
-- Basic CTE
WITH high_earners AS (
    SELECT employee_id, name, salary, department_id
    FROM employees 
    WHERE salary > 75000
)
SELECT d.department_name, COUNT(*) as high_earner_count
FROM high_earners he
JOIN departments d ON he.department_id = d.department_id
GROUP BY d.department_name;
```

### Recursive CTEs
```sql
-- Employee hierarchy
WITH employee_hierarchy AS (
    -- Anchor member: top-level managers
    SELECT employee_id, name, manager_id, 1 as level
    FROM employees 
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive member: employees under managers
    SELECT e.employee_id, e.name, e.manager_id, eh.level + 1
    FROM employees e
    JOIN employee_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT * FROM employee_hierarchy ORDER BY level, name;
```

## 🔗 Prerequisites

Before starting this section, make sure you're comfortable with:
- Basic SQL queries (Sections 1-3)
- Joins (Section 7)
- Aggregate functions and grouping (Section 6)
- Filtering and conditions (Section 4)

## ➡️ Next Steps

After completing this section, you'll be ready for:
- **Views and Indexes** (Section 9): Create reusable views using CTEs
- **Advanced Queries** (Section 13): Window functions and advanced techniques
- **Performance Tuning** (Section 14): Optimize complex queries

## 🎯 Real-World Applications

- **Reporting**: Create complex reports with hierarchical data
- **Data Analysis**: Compare individual records to group aggregates
- **Business Intelligence**: Build reusable query components with CTEs
- **Data Warehousing**: Query dimensional models with complex relationships

## 📚 Quick Reference

| Technique | Use Case | Performance |
|-----------|----------|-------------|
| Subquery in WHERE | Filter based on calculated values | Good for small result sets |
| Subquery in FROM | Create derived tables | Good for complex calculations |
| Correlated Subquery | Row-by-row comparisons | Can be slow for large datasets |
| EXISTS/NOT EXISTS | Check for related data existence | Often faster than IN/NOT IN |
| CTE | Improve query readability | Similar to subqueries |
| Recursive CTE | Hierarchical/tree data | Unique capability for recursion |

## 🏆 What Makes This Section Special

- **Problem-Solving Approach**: Learn to break complex problems into manageable parts
- **Readability Focus**: Write SQL that others can understand and maintain
- **Performance Awareness**: Understand when to use each technique for optimal results
- **Real-World Examples**: Practice with scenarios you'll encounter in actual projects

Start building sophisticated queries that solve complex business problems! 🚀