# Correlated Subqueries: A Beginner's Guide with Demo Data

## Demo Data: Employees Table

Let's create a simple employees table:

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

## Department Averages

First, let's calculate the average salary for each department:

| DepartmentID | Average Salary |
|--------------|----------------|
| 1            | 45000          | (50000+45000+40000)/3
| 2            | 63333          | (70000+65000+55000)/3 ≈ 63333
| 3            | 77500          | (80000+75000)/2

## Example 1: Employees Earning Above Their Department's Average

**Question:** Which employees earn more than the average salary in their department?

```sql
SELECT e.Name, e.Salary, e.DepartmentID
FROM Employees e
WHERE e.Salary > (
    SELECT AVG(Salary)
    FROM Employees
    WHERE DepartmentID = e.DepartmentID
);
```

### Step-by-Step Execution:

1. **First row**: Alice (Dept 1, $50,000)
   - Inner query: `SELECT AVG(Salary) FROM Employees WHERE DepartmentID = 1`
   - Result: $45,000
   - Comparison: 50,000 > 45,000 ✓ (INCLUDED)

2. **Second row**: Bob (Dept 1, $45,000)
   - Inner query: `SELECT AVG(Salary) FROM Employees WHERE DepartmentID = 1`
   - Result: $45,000
   - Comparison: 45,000 > 45,000 ✗ (EXCLUDED)

3. **Third row**: Charlie (Dept 1, $40,000)
   - Inner query: `SELECT AVG(Salary) FROM Employees WHERE DepartmentID = 1`
   - Result: $45,000
   - Comparison: 40,000 > 45,000 ✗ (EXCLUDED)

4. **Fourth row**: David (Dept 2, $70,000)
   - Inner query: `SELECT AVG(Salary) FROM Employees WHERE DepartmentID = 2`
   - Result: $63,333
   - Comparison: 70,000 > 63,333 ✓ (INCLUDED)

... and so on for each employee.

### Final Result:

| Name    | Salary | DepartmentID |
|---------|--------|-------------|
| Alice   | 50000  | 1           |
| David   | 70000  | 2           |
| Eva     | 65000  | 2           |
| Grace   | 80000  | 3           |
| Henry   | 75000  | 3           |

## Example 2: Highest Paid in Each Department

**Question:** Who is the highest paid employee in each department?

```sql
SELECT e.Name, e.Salary, e.DepartmentID
FROM Employees e
WHERE e.Salary = (
    SELECT MAX(Salary)
    FROM Employees
    WHERE DepartmentID = e.DepartmentID
);
```

### Department Maximums:

| DepartmentID | Max Salary |
|--------------|------------|
| 1            | 50000      |
| 2            | 70000      |
| 3            | 80000      |

### Step-by-Step:

1. **Alice** (Dept 1, $50,000): 
   - Is 50,000 = MAX(Dept 1)? ✓ YES

2. **Bob** (Dept 1, $45,000): 
   - Is 45,000 = MAX(Dept 1)? ✗ NO

3. **Charlie** (Dept 1, $40,000): 
   - Is 40,000 = MAX(Dept 1)? ✗ NO

4. **David** (Dept 2, $70,000): 
   - Is 70,000 = MAX(Dept 2)? ✓ YES

... and so on.

### Final Result:

| Name    | Salary | DepartmentID |
|---------|--------|-------------|
| Alice   | 50000  | 1           |
| David   | 70000  | 2           |
| Grace   | 80000  | 3           |

## Example 3: Using EXISTS (Find Departments with Employees)

Let's add a Departments table:

| DepartmentID | DepartmentName |
|--------------|----------------|
| 1            | Sales          |
| 2            | Marketing      |
| 3            | IT             |
| 4            | HR             | ← No employees in HR

**Question:** Find departments that have at least one employee

```sql
SELECT d.DepartmentName
FROM Departments d
WHERE EXISTS (
    SELECT 1
    FROM Employees e
    WHERE e.DepartmentID = d.DepartmentID
);
```

### Step-by-Step:

1. **Sales** (Dept 1): 
   - Are there employees WHERE DepartmentID = 1? ✓ YES

2. **Marketing** (Dept 2): 
   - Are there employees WHERE DepartmentID = 2? ✓ YES

3. **IT** (Dept 3): 
   - Are there employees WHERE DepartmentID = 3? ✓ YES

4. **HR** (Dept 4): 
   - Are there employees WHERE DepartmentID = 4? ✗ NO

### Final Result:

| DepartmentName |
|----------------|
| Sales          |
| Marketing      |
| IT             |

## Visualizing the Correlation

Think of it like this pseudo-code:

```python
# This is what happens with a correlated subquery
for each row in outer_query:
    value = run_inner_query(using_values_from_current_outer_row)
    if condition_is_true(value):
        include_this_row_in_results
```

## Practice with Our Data

**Exercise:** Find employees who earn exactly the average salary of their department.

<details>
<summary>Answer</summary>

```sql
SELECT e.Name, e.Salary, e.DepartmentID
FROM Employees e
WHERE e.Salary = (
    SELECT AVG(Salary)
    FROM Employees
    WHERE DepartmentID = e.DepartmentID
);
```

**Result:** Only Bob (Dept 1, $45,000) earns exactly his department's average.
</details>

## Key Takeaways

1. **Correlated subqueries run in a loop** - once for each row in the outer query
2. **They're like asking a question about each row**: "Is this employee's salary greater than the average of THEIR department?"
3. **The inner query depends on the outer query** - it can't run on its own
4. **Use them when you need to compare each row to its group**

Remember: The magic happens in the `WHERE inner.column = outer.column` part - this is what makes it "correlated"!