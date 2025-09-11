# Common Table Expressions (CTEs): A Complete Beginner's Guide

## What is a CTE?

A Common Table Expression (CTE) is like a **temporary named result set** that you can reference within your SQL query. Think of it as creating a temporary table that only exists during the execution of your query.

## Why Use CTEs?

1. **Readability**: Break complex queries into simpler parts
2. **Reusability**: Reference the same subquery multiple times
3. **Organization**: Structure your query in a logical way
4. **Recursion**: Handle hierarchical data (more advanced)

## Basic CTE Structure

```sql
WITH CTE_Name AS (
    -- Your query here
    SELECT column1, column2
    FROM some_table
    WHERE conditions
)
-- Main query that uses the CTE
SELECT *
FROM CTE_Name;
```

## Simple Example with Demo Data

Let's use a simple `Employees` table:

| EmployeeID | Name    | Salary | DepartmentID | ManagerID |
|------------|---------|--------|-------------|-----------|
| 1          | Alice   | 50000  | 1           | NULL      |
| 2          | Bob     | 45000  | 1           | 1         |
| 3          | Charlie | 40000  | 1           | 1         |
| 4          | David   | 70000  | 2           | NULL      |
| 5          | Eva     | 65000  | 2           | 4         |
| 6          | Frank   | 55000  | 2           | 4         |

### Example 1: Basic CTE

```sql
-- Create a CTE that gets high-paid employees
WITH HighPaidEmployees AS (
    SELECT Name, Salary, DepartmentID
    FROM Employees
    WHERE Salary > 60000
)
-- Use the CTE in our main query
SELECT *
FROM HighPaidEmployees
ORDER BY Salary DESC;
```

**Result:**
| Name  | Salary | DepartmentID |
|-------|--------|-------------|
| David | 70000  | 2           |
| Eva   | 65000  | 2           |

### How this works:
1. First, the CTE `HighPaidEmployees` is created with employees making over $60,000
2. Then, the main query selects everything from that CTE
3. The CTE only exists during this query execution

## Multiple CTEs

You can define multiple CTEs in a single query:

```sql
WITH 
DepartmentStats AS (
    SELECT DepartmentID, AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY DepartmentID
),
HighPaid AS (
    SELECT Name, Salary, DepartmentID
    FROM Employees
    WHERE Salary > 60000
)
SELECT h.Name, h.Salary, h.DepartmentID, d.AvgSalary
FROM HighPaid h
JOIN DepartmentStats d ON h.DepartmentID = d.DepartmentID;
```

## Real-World Example: Department Analysis

```sql
-- Step 1: Get department averages
WITH DepartmentAverages AS (
    SELECT DepartmentID, AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY DepartmentID
),
-- Step 2: Find employees above their department's average
AboveAverageEmployees AS (
    SELECT e.Name, e.Salary, e.DepartmentID, d.AvgSalary
    FROM Employees e
    JOIN DepartmentAverages d ON e.DepartmentID = d.DepartmentID
    WHERE e.Salary > d.AvgSalary
)
-- Step 3: Final selection
SELECT 
    Name AS EmployeeName, 
    Salary, 
    DepartmentID,
    AvgSalary AS DepartmentAverage,
    Salary - AvgSalary AS AboveAverageBy
FROM AboveAverageEmployees
ORDER BY AboveAverageBy DESC;
```

## Recursive CTEs (Advanced but Powerful)

Recursive CTEs are used for hierarchical data. Let's find the management chain:

```sql
WITH EmployeeHierarchy AS (
    -- Anchor member: top-level managers (no manager)
    SELECT EmployeeID, Name, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    -- Recursive member: employees who report to managers
    SELECT e.EmployeeID, e.Name, e.ManagerID, eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT *
FROM EmployeeHierarchy
ORDER BY Level, EmployeeID;
```

**Result:**
| EmployeeID | Name    | ManagerID | Level |
|------------|---------|-----------|-------|
| 1          | Alice   | NULL      | 1     |
| 4          | David   | NULL      | 1     |
| 2          | Bob     | 1         | 2     |
| 3          | Charlie | 1         | 2     |
| 5          | Eva     | 4         | 2     |
| 6          | Frank   | 4         | 2     |

## CTE vs Subquery: Which to Use?

**Use a CTE when:**
- You need to reference the same subquery multiple times
- You want to make complex queries more readable
- You're working with recursive data

**Use a subquery when:**
- You only need the result once
- The query is simple enough to be understandable

### Comparison Example:

**Subquery approach (harder to read):**
```sql
SELECT e.Name, e.Salary, e.DepartmentID
FROM Employees e
WHERE e.Salary > (
    SELECT AVG(Salary)
    FROM Employees
    WHERE DepartmentID = e.DepartmentID
);
```

**CTE approach (easier to read):**
```sql
WITH DepartmentAverages AS (
    SELECT DepartmentID, AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT e.Name, e.Salary, e.DepartmentID, d.AvgSalary
FROM Employees e
JOIN DepartmentAverages d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > d.AvgSalary;
```

## Performance Considerations

1. **CTEs are not stored** - they're reevaluated each time they're referenced
2. **Materialized CTEs** (some databases) can store results for better performance
3. **Use indexes** on tables used in CTEs for better performance

## Practice Exercises

### Exercise 1: Create a CTE that finds employees with above-average salaries

<details>
<summary>Answer</summary>

```sql
WITH CompanyAverage AS (
    SELECT AVG(Salary) AS AvgSalary
    FROM Employees
)
SELECT Name, Salary
FROM Employees
WHERE Salary > (SELECT AvgSalary FROM CompanyAverage);
```
</details>

### Exercise 2: Find the salary difference from department average

<details>
<summary>Answer</summary>

```sql
WITH DeptAverages AS (
    SELECT DepartmentID, AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY DepartmentID
)
SELECT 
    e.Name,
    e.Salary,
    e.DepartmentID,
    d.AvgSalary,
    e.Salary - d.AvgSalary AS Difference
FROM Employees e
JOIN DeptAverages d ON e.DepartmentID = d.DepartmentID;
```
</details>

## Common Mistakes

1. **Forgetting the WITH keyword**: Always start CTEs with `WITH`
2. **Missing commas between multiple CTEs**: Separate with commas
3. **Referencing CTEs in wrong order**: Define before use
4. **Assuming CTEs are stored**: They're reevaluated each time

## Best Practices

1. **Use descriptive names**: `EmployeeHierarchy` instead of `CTE1`
2. **Keep CTEs focused**: Each CTE should do one thing well
3. **Comment complex logic**: Explain what each CTE does
4. **Test CTEs individually**: Make sure each part works before combining

## When NOT to Use CTEs

- **Very simple queries** where CTEs add unnecessary complexity
- **Performance-critical applications** where temporary tables might be better
- **When you need to reuse results** across multiple queries (use temp tables instead)

## Summary

CTEs are like **SQL's version of outlining** - they help you organize complex queries into logical sections. They make your code:
- ✅ More readable
- ✅ Easier to maintain  
- ✅ Simpler to debug
- ✅ Better structured

Remember: CTEs are temporary, named result sets that exist only during query execution. They're fantastic for breaking down complex problems into manageable pieces!

**Next time you write a complex query, try using CTEs to make it more organized and understandable!**