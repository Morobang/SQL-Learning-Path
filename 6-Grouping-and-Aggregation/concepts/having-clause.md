# HAVING Clause in SQL

The **HAVING** clause in SQL is used to filter **groups of rows** after the `GROUP BY` operation.  
It works **like `WHERE`**, but for aggregated results.

---

## 1. Syntax
```sql
SELECT column1, aggregate_function(column2)
FROM table_name
GROUP BY column1
HAVING condition;
````

---

## 2. Difference Between `WHERE` and `HAVING`

| Feature                                            | WHERE | HAVING |
| -------------------------------------------------- | ----- | ------ |
| Filters **rows** before grouping                   | ✅ Yes | ❌ No   |
| Filters **groups** after grouping                  | ❌ No  | ✅ Yes  |
| Can use aggregate functions (`COUNT`, `AVG`, etc.) | ❌ No  | ✅ Yes  |

---

## 3. Example Dataset: `Employees`

| Department | Employee | Salary |
| ---------- | -------- | ------ |
| HR         | Alice    | 50000  |
| IT         | Bob      | 60000  |
| IT         | Charlie  | 65000  |
| Finance    | David    | 70000  |
| HR         | Eva      | 55000  |
| Finance    | Frank    | 72000  |
| IT         | Grace    | 58000  |

---

## 4. Basic Example

**Find departments where the average salary is greater than 60,000:**

```sql
SELECT Department, AVG(Salary) AS Avg_Salary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 60000;
```

**Result:**

| Department | Avg\_Salary |
| ---------- | ----------- |
| IT         | 61000       |
| Finance    | 71000       |

---

## 5. Combining `WHERE` and `HAVING`

**Find departments where:**

* Employees earn more than 55,000 (filter before grouping)
* The total salary is more than 150,000 (filter after grouping)

```sql
SELECT Department, SUM(Salary) AS Total_Salary
FROM Employees
WHERE Salary > 55000
GROUP BY Department
HAVING SUM(Salary) > 150000;
```

---

## 6. Using `HAVING` Without `GROUP BY`

You can use `HAVING` without `GROUP BY` if you want to filter an **aggregate across all rows**.

```sql
SELECT AVG(Salary) AS Avg_Salary
FROM Employees
HAVING AVG(Salary) > 60000;
```

---

## 7. Common Aggregate Functions with `HAVING`

* `COUNT()` → Count rows per group
* `SUM()` → Total values per group
* `AVG()` → Average value per group
* `MIN()` / `MAX()` → Minimum or maximum per group

---

## Key Notes

* **`HAVING`** is applied **after** grouping and aggregation.
* **`WHERE`** filters individual rows **before** grouping.
* In most databases, every non-aggregated column in the `SELECT` must appear in `GROUP BY`.

---

## References

* [SQL HAVING Clause – W3Schools](https://www.w3schools.com/sql/sql_having.asp)
* [SQL GROUP BY Documentation](https://dev.mysql.com/doc/refman/8.0/en/group-by-handling.html)
