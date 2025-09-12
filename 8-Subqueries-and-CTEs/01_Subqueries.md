# SQL Subqueries: A Complete Beginner's Guide

## What is a Subquery?

A subquery is a **query within another query**. Think of it like asking a question to answer another question:

**"Which employees earn more than the average salary?"**
- Main question: "Which employees earn more than X?"
- Sub-question: "What is the average salary?" (X = average salary)

## Types of Subqueries

### 1. Scalar Subquery (Returns single value)
```sql
SELECT Name, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);
-- Returns: 45000 (or whatever the average is)
```

### 2. Column Subquery (Returns single column)
```sql
SELECT Name
FROM Employees
WHERE DepartmentID IN (SELECT DepartmentID FROM Departments WHERE Location = 'NY');
-- Returns: List of department IDs from NY
```

### 3. Table Subquery (Returns multiple columns)
```sql
SELECT *
FROM (SELECT Name, Salary, DepartmentID FROM Employees WHERE Salary > 50000) AS HighPaidEmployees;
-- Returns: Full table of high-paid employees
```

## Demo Data

Let's use this `Employees` table:

| EmployeeID | Name    | Salary | DepartmentID |
|------------|---------|--------|-------------|
| 1          | Alice   | 50000  | 1           |
| 2          | Bob     | 45000  | 1           |
| 3          | Charlie | 40000  | 1           |
| 4          | David   | 70000  | 2           |
| 5          | Eva     | 65000  | 2           |
| 6          | Frank   | 55000  | 2           |
| 7          | Grace   | 80000  | 3           |
| 8          | Henry   | 75000  | 3           |

And this `Departments` table:

| DepartmentID | DepartmentName | Location |
|--------------|----------------|----------|
| 1            | Sales          | NY       |
| 2            | Marketing      | CA       |
| 3            | IT             | NY       |
| 4            | HR             | TX       |

## Basic Subquery Examples

### Example 1: Scalar Subquery
**Find employees who earn more than average**
```sql
SELECT Name, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);
```

**Step-by-step:**
1. Subquery runs: `SELECT AVG(Salary) FROM Employees` → 57500
2. Main query becomes: `SELECT Name, Salary FROM Employees WHERE Salary > 57500`
3. Result: David, Eva, Grace, Henry

### Example 2: Column Subquery with IN
**Find employees in NY departments**
```sql
SELECT Name, DepartmentID
FROM Employees
WHERE DepartmentID IN (
    SELECT DepartmentID 
    FROM Departments 
    WHERE Location = 'NY'
);
```

**Step-by-step:**
1. Subquery runs: `SELECT DepartmentID FROM Departments WHERE Location = 'NY'` → 1, 3
2. Main query becomes: `SELECT Name, DepartmentID FROM Employees WHERE DepartmentID IN (1, 3)`
3. Result: Alice, Bob, Charlie, Grace, Henry

### Example 3: Subquery in SELECT clause
**Show each employee's salary and how much above/below average**
```sql
SELECT 
    Name,
    Salary,
    Salary - (SELECT AVG(Salary) FROM Employees) AS DifferenceFromAverage
FROM Employees;
```

## Correlated vs Non-Correlated Subqueries

### Non-Correlated Subquery (Runs once)
```sql
SELECT Name
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);
-- The subquery doesn't depend on the outer query
```

### Correlated Subquery (Runs for each row)
```sql
SELECT Name, Salary, DepartmentID
FROM Employees e
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
    WHERE DepartmentID = e.DepartmentID
);
-- The subquery needs values from the outer query (e.DepartmentID)
```

## Subqueries in Different Clauses

### WHERE Clause
```sql
SELECT Name
FROM Employees
WHERE DepartmentID IN (
    SELECT DepartmentID FROM Departments WHERE Location = 'NY'
);
```

### FROM Clause (Derived Tables)
```sql
SELECT AVG(Salary) AS AvgHighSalary
FROM (
    SELECT Salary 
    FROM Employees 
    WHERE Salary > 60000
) AS HighPaidEmployees;
```

### SELECT Clause
```sql
SELECT 
    Name,
    Salary,
    (SELECT AVG(Salary) FROM Employees) AS CompanyAverage
FROM Employees;
```

### HAVING Clause
```sql
SELECT DepartmentID, AVG(Salary) AS AvgDeptSalary
FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > (
    SELECT AVG(Salary) FROM Employees
);
```

## Common Operators with Subqueries

### IN / NOT IN
```sql
-- Employees in NY departments
SELECT Name FROM Employees
WHERE DepartmentID IN (
    SELECT DepartmentID FROM Departments WHERE Location = 'NY'
);

-- Employees NOT in NY departments  
SELECT Name FROM Employees
WHERE DepartmentID NOT IN (
    SELECT DepartmentID FROM Departments WHERE Location = 'NY'
);
```

### ANY / ALL
```sql
-- Employees earning more than ANY Sales person
SELECT Name FROM Employees
WHERE Salary > ANY (
    SELECT Salary FROM Employees WHERE DepartmentID = 1
);

-- Employees earning more than ALL Sales people
SELECT Name FROM Employees  
WHERE Salary > ALL (
    SELECT Salary FROM Employees WHERE DepartmentID = 1
);
```

### EXISTS / NOT EXISTS
```sql
-- Departments that have employees
SELECT DepartmentName FROM Departments d
WHERE EXISTS (
    SELECT 1 FROM Employees e WHERE e.DepartmentID = d.DepartmentID
);

-- Departments with NO employees
SELECT DepartmentName FROM Departments d
WHERE NOT EXISTS (
    SELECT 1 FROM Employees e WHERE e.DepartmentID = d.DepartmentID
);
```

## Practice Exercises

### Exercise 1: Find the highest paid employee
<details>
<summary>Answer</summary>

```sql
SELECT Name, Salary
FROM Employees
WHERE Salary = (SELECT MAX(Salary) FROM Employees);
```
</details>

### Exercise 2: Find employees who earn more than their department average
<details>
<summary>Answer</summary>

```sql
SELECT Name, Salary, DepartmentID
FROM Employees e
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
    WHERE DepartmentID = e.DepartmentID
);
```
</details>

### Exercise 3: Find departments with above-average total salary
<details>
<summary>Answer</summary>

```sql
SELECT DepartmentID, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
HAVING SUM(Salary) > (
    SELECT AVG(TotalSalary)
    FROM (
        SELECT SUM(Salary) AS TotalSalary
        FROM Employees
        GROUP BY DepartmentID
    ) AS DeptTotals
);
```
</details>

## Performance Considerations

1. **Correlated subqueries can be slow** - they run once for each row
2. **Use EXISTS instead of IN** when checking for existence
3. **Test subqueries separately** to ensure they work correctly
4. **Consider using JOINs** instead of subqueries when possible

## Common Mistakes

1. **Returning multiple columns when expecting one**
   ```sql
   -- WRONG:
   SELECT Name FROM Employees
   WHERE Salary > (SELECT Salary, DepartmentID FROM Employees WHERE EmployeeID = 1);
   
   -- RIGHT:
   SELECT Name FROM Employees
   WHERE Salary > (SELECT Salary FROM Employees WHERE EmployeeID = 1);
   ```

2. **Forgetting that NULL values affect IN/NOT IN**
   ```sql
   -- If subquery returns NULL, NOT IN might not work as expected
   SELECT Name FROM Employees
   WHERE DepartmentID NOT IN (SELECT NULL FROM Departments);
   -- This returns NO rows!
   ```

3. **Using = instead of IN for multiple possible values**
   ```sql
   -- WRONG (if multiple departments in NY):
   SELECT Name FROM Employees
   WHERE DepartmentID = (
       SELECT DepartmentID FROM Departments WHERE Location = 'NY'
   );
   
   -- RIGHT:
   SELECT Name FROM Employees
   WHERE DepartmentID IN (
       SELECT DepartmentID FROM Departments WHERE Location = 'NY'
   );
   ```

## When to Use Subqueries vs JOINs

**Use Subqueries when:**
- You need a single value for comparison
- You're checking for existence (EXISTS/NOT EXISTS)
- The logic is complex and better expressed in steps

**Use JOINs when:**
- You need data from multiple tables in the result
- Performance is critical (JOINs are often faster)
- You need to return multiple columns from related tables

## Real-World Example: Employee Analysis

```sql
-- Comprehensive employee report
SELECT 
    e.Name,
    e.Salary,
    d.DepartmentName,
    -- Salary compared to company average
    e.Salary - (SELECT AVG(Salary) FROM Employees) AS VsCompanyAvg,
    -- Salary compared to department average  
    e.Salary - (
        SELECT AVG(Salary) 
        FROM Employees 
        WHERE DepartmentID = e.DepartmentID
    ) AS VsDeptAvg,
    -- Salary rank in department
    (
        SELECT COUNT(*) + 1
        FROM Employees e2
        WHERE e2.DepartmentID = e.DepartmentID AND e2.Salary > e.Salary
    ) AS DeptRank
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentName, e.Salary DESC;
```

## Summary

**Subqueries are powerful tools that let you:**
- ✅ Ask questions within questions
- ✅ Compare values to calculated results
- ✅ Break complex problems into steps
- ✅ Write more expressive and readable queries

**Remember:**
- Scalar subqueries return single values
- Correlated subqueries reference outer query values
- Test subqueries separately before combining
- Consider performance implications

**Practice is key!** Start with simple subqueries and gradually work up to more complex ones.