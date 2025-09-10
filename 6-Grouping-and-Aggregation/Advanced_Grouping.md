# Advanced SQL Grouping

## 🎯 Learning Objectives

By the end of this lesson, students will be able to:

* Understand advanced grouping techniques in SQL.
* Use `GROUPING SETS`, `ROLLUP`, and `CUBE`.
* Apply multiple grouping levels in queries.
* Write queries that provide summary reports.

---

## 1. Recap: Basic GROUP BY

We already know:

```sql
SELECT department, COUNT(*) AS num_employees
FROM employees
GROUP BY department;
```

➡️ Groups employees by department.

---

## 2. GROUPING SETS

### What is it?

`GROUPING SETS` allows you to create multiple grouping combinations in one query.

### Example

```sql
SELECT department, job_title, COUNT(*) AS num_employees
FROM employees
GROUP BY GROUPING SETS (
    (department),
    (job_title),
    (department, job_title)
);
```

✅ This produces 3 result sets in **one query**:

1. Grouped by department.
2. Grouped by job title.
3. Grouped by both.

---

## 3. ROLLUP

### What is it?

`ROLLUP` is used when we want subtotals and a grand total.

### Example

```sql
SELECT department, job_title, COUNT(*) AS num_employees
FROM employees
GROUP BY ROLLUP (department, job_title);
```

➡️ Results include:

* Count by (department, job\_title)
* Subtotal by department
* Grand total for all employees

---

## 4. CUBE

### What is it?

`CUBE` gives **all possible combinations** of grouping.

### Example

```sql
SELECT department, job_title, COUNT(*) AS num_employees
FROM employees
GROUP BY CUBE (department, job_title);
```

➡️ Results include:

* Grouped by department
* Grouped by job title
* Grouped by (department, job\_title)
* Grand total

---

## 5. GROUPING() Function

When we use `ROLLUP` or `CUBE`, SQL sometimes shows `NULL` for subtotals. The `GROUPING()` function helps identify them.

### Example

```sql
SELECT department,
       job_title,
       GROUPING(department) AS is_dept_total,
       GROUPING(job_title) AS is_job_total,
       COUNT(*) AS num_employees
FROM employees
GROUP BY ROLLUP (department, job_title);
```

✅ `is_dept_total = 1` means that row is a subtotal for department.

---

## 6. Practical Example: Sales Report

Imagine we have a `sales` table:

```sql
region   | product   | amount
---------|-----------|-------
East     | Laptop    | 1000
East     | Phone     | 500
West     | Laptop    | 1200
West     | Phone     | 700
```

### Using ROLLUP:

```sql
SELECT region, product, SUM(amount) AS total_sales
FROM sales
GROUP BY ROLLUP(region, product);
```

➡️ Output:

```
region | product | total_sales
-------|---------|------------
East   | Laptop  | 1000
East   | Phone   | 500
East   | NULL    | 1500   <-- subtotal for East
West   | Laptop  | 1200
West   | Phone   | 700
West   | NULL    | 1900   <-- subtotal for West
NULL   | NULL    | 3400   <-- grand total
```

---

## 7. Practice Questions

1. Write a query to show total sales by region, by product, and overall in one query.
2. Use `CUBE` to show all grouping combinations of region and product.
3. Use `GROUPING()` to label rows as **Subtotal** or **Grand Total**.

---

## ✅ Key Takeaways

* **GROUPING SETS**: custom combinations of groups.
* **ROLLUP**: subtotals + grand total.
* **CUBE**: all possible grouping combinations.
* **GROUPING()**: distinguishes regular rows from subtotals/grand totals.
