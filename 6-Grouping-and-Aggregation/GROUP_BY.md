
# GROUPING in SQL

In SQL, **grouping** is done using the `GROUP BY` clause.  
It is used to **arrange identical data into groups** and is often combined with **aggregate functions** like:
- `COUNT()` → counts rows
- `SUM()` → adds values
- `AVG()` → calculates average
- `MIN()` / `MAX()` → finds minimum or maximum values

---

## 1. Basic Syntax
```sql
SELECT column1, aggregate_function(column2)
FROM table_name
GROUP BY column1;
````

---

## 2. Example Dataset: `Employees`

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

## 3. Example: Average Salary by Department

```sql
SELECT Department, AVG(Salary) AS Avg_Salary
FROM Employees
GROUP BY Department;
```

**Result:**

| Department | Avg\_Salary |
| ---------- | ----------- |
| HR         | 52500       |
| IT         | 61000       |
| Finance    | 71000       |

---

## 4. Grouping with Multiple Columns

```sql
SELECT Department, Employee, SUM(Salary) AS Total_Salary
FROM Employees
GROUP BY Department, Employee;
```

Groups by **both** `Department` and `Employee`.

---

## 5. Using `HAVING` with `GROUP BY`

`HAVING` filters **after** grouping (unlike `WHERE` which filters before).

```sql
SELECT Department, AVG(Salary) AS Avg_Salary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 60000;
```

**Result:** Only shows departments where the average salary is greater than 60,000.

---

## 6. Counting Rows per Group

```sql
SELECT Department, COUNT(*) AS Num_Employees
FROM Employees
GROUP BY Department;
```

---

## 7. Combining `WHERE` and `GROUP BY`

```sql
SELECT Department, SUM(Salary) AS Total_Salary
FROM Employees
WHERE Salary > 55000
GROUP BY Department;
```

* `WHERE` filters rows **before** grouping.
* `GROUP BY` then groups the filtered rows.

---

## 8. Summary Table

| Clause     | Purpose                                                 |
| ---------- | ------------------------------------------------------- |
| `GROUP BY` | Groups rows that have the same values into summary rows |
| `HAVING`   | Filters groups based on aggregate conditions            |
| `WHERE`    | Filters rows **before** grouping                        |
| `ORDER BY` | Sorts the results (often used after grouping)           |

---

## Key Notes

* All columns in the `SELECT` statement that are **not** inside aggregate functions **must** be in the `GROUP BY` clause.
* Use `HAVING` instead of `WHERE` for filtering on aggregated results.
* `GROUP BY` works with aggregate functions to produce summarized results.

---

## References

* [SQL GROUP BY Documentation (W3Schools)](https://www.w3schools.com/sql/sql_groupby.asp)
* [SQL HAVING Clause](https://www.w3schools.com/sql/sql_having.asp)

