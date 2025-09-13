# Common Table Expressions (CTEs) in SQL

## What is a CTE?

A **Common Table Expression (CTE)** is a temporary named result set that you can reference within a SQL statement. Think of it as a temporary table that exists only during the execution of your query. CTEs make complex queries easier to read and maintain by breaking them down into simpler, logical parts.

## Why Use CTEs?

- **Improve readability**: Break complex queries into manageable pieces
- **Simplify debugging**: Test each part of your query separately
- **Avoid repetition**: Reference the same subquery multiple times
- **Handle recursive queries**: Work with hierarchical data like organizational charts

## Basic CTE Syntax

```sql
WITH cte_name AS (
    -- Your CTE query here
    SELECT column1, column2, ...
    FROM your_table
    WHERE conditions
)
-- Main query that uses the CTE
SELECT *
FROM cte_name;
```

## Sample Data

Let's imagine we have a simple `employees` table:

| employee_id | name     | department | salary | manager_id |
|-------------|----------|------------|--------|------------|
| 1           | John     | HR         | 50000  | NULL       |
| 2           | Jane     | HR         | 55000  | 1          |
| 3           | Bob      | IT         | 60000  | NULL       |
| 4           | Alice    | IT         | 65000  | 3          |
| 5           | Charlie  | Sales      | 70000  | NULL       |
| 6           | Diana    | Sales      | 75000  | 5          |

## Simple CTE Example

Let's find employees who earn more than the average salary:

```sql
-- First, let's find the average salary
WITH AverageSalary AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
)
-- Now compare each employee's salary to the average
SELECT e.name, e.salary, a.avg_salary
FROM employees e, AverageSalary a
WHERE e.salary > a.avg_salary;
```

**Result:**

| name    | salary | avg_salary |
|---------|--------|------------|
| Alice   | 65000  | 62500      |
| Charlie | 70000  | 62500      |
| Diana   | 75000  | 62500      |

**Explanation:**
1. The CTE `AverageSalary` calculates the average salary across all employees (62500)
2. The main query joins the employees table with this CTE
3. We filter to show only employees whose salary is greater than the average

## Multiple CTEs Example

You can define multiple CTEs in a single query:

```sql
WITH 
DepartmentStats AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
),
HighPaidDepts AS (
    SELECT department
    FROM DepartmentStats
    WHERE avg_salary > 60000
)
SELECT e.name, e.department, e.salary
FROM employees e
WHERE e.department IN (SELECT department FROM HighPaidDepts);
```

**Result:**

| name    | department | salary |
|---------|------------|--------|
| Bob     | IT         | 60000  |
| Alice   | IT         | 65000  |
| Charlie | Sales      | 70000  |
| Diana   | Sales      | 75000  |

**Explanation:**
1. `DepartmentStats` calculates the average salary for each department
2. `HighPaidDepts` selects only departments with average salary > 60000
3. The main query shows employees from these high-paying departments

## Recursive CTEs

Recursive CTEs are powerful for working with hierarchical data. Let's find the management hierarchy:

```sql
WITH RECURSIVE OrgChart AS (
    -- Anchor member: top-level managers (those with no manager)
    SELECT employee_id, name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive member: find subordinates
    SELECT e.employee_id, e.name, e.manager_id, oc.level + 1
    FROM employees e
    INNER JOIN OrgChart oc ON e.manager_id = oc.employee_id
)
SELECT employee_id, name, manager_id, level
FROM OrgChart
ORDER BY level, name;
```

**Result:**

| employee_id | name    | manager_id | level |
|-------------|---------|------------|-------|
| 1           | John    | NULL       | 1     |
| 3           | Bob     | NULL       | 1     |
| 5           | Charlie | NULL       | 1     |
| 2           | Jane    | 1          | 2     |
| 4           | Alice   | 3          | 2     |
| 6           | Diana   | 5          | 2     |

**Explanation:**
1. The anchor part finds all top-level managers (level 1)
2. The recursive part finds employees who report to those in the current level
3. This continues until no more subordinates are found
4. The final result shows the complete organizational hierarchy with levels

## Practical Example: Customer Analysis

Let's create a more complex example with customer data. Imagine we have an `orders` table:

| order_id | customer_id | order_date | amount |
|----------|-------------|------------|--------|
| 1        | 101         | 2023-01-15 | 150    |
| 2        | 101         | 2023-02-20 | 200    |
| 3        | 102         | 2023-01-10 | 75     |
| 4        | 103         | 2023-03-05 | 300    |
| 5        | 101         | 2023-03-25 | 100    |
| 6        | 102         | 2023-04-12 | 250    |

```sql
WITH 
CustomerTotals AS (
    SELECT 
        customer_id, 
        COUNT(*) AS order_count, 
        SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
),
CustomerSegments AS (
    SELECT
        customer_id,
        order_count,
        total_spent,
        CASE
            WHEN total_spent >= 400 THEN 'VIP'
            WHEN total_spent >= 200 THEN 'Premium'
            ELSE 'Standard'
        END AS segment
    FROM CustomerTotals
)
SELECT 
    segment,
    COUNT(*) AS customer_count,
    AVG(total_spent) AS avg_spent,
    AVG(order_count) AS avg_orders
FROM CustomerSegments
GROUP BY segment
ORDER BY avg_spent DESC;
```

**Result:**

| segment  | customer_count | avg_spent | avg_orders |
|----------|----------------|-----------|------------|
| VIP      | 1              | 450.00    | 3.00       |
| Premium  | 1              | 250.00    | 2.00       |
| Standard | 1              | 75.00     | 1.00       |

**Explanation:**
1. `CustomerTotals` calculates total orders and spending per customer
2. `CustomerSegments` categorizes customers based on their spending
3. The main query provides summary statistics for each segment

## CTEs vs. Subqueries

CTEs are often more readable than subqueries:

**Subquery approach (less readable):**
```sql
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

**CTE approach (more readable):**
```sql
WITH AverageSalary AS (
    SELECT AVG(salary) AS avg_salary FROM employees
)
SELECT name, salary
FROM employees, AverageSalary
WHERE salary > avg_salary;
```

## Best Practices

1. Use descriptive names for your CTEs
2. Keep each CTE focused on a single logical operation
3. Use CTEs to break down complex queries into manageable parts
4. Be cautious with recursive CTEs to avoid infinite loops
5. Test each CTE individually before combining them

## Limitations

- CTEs exist only during query execution
- They can't be reused in other queries
- Performance may vary compared to temporary tables for very large datasets

## Conclusion

CTEs are powerful tools that make your SQL code more readable, maintainable, and logical. They're especially useful for:
- Breaking down complex queries
- Recursive operations on hierarchical data
- Reusing the same subquery multiple times
- Improving code organization and readability

Start using CTEs in your queries to make them cleaner and easier to understand!