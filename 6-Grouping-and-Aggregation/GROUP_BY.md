# SQL GROUP BY – Beginner-Friendly Notes

## 🎯 Learning Objectives

By the end of this lesson, you should be able to:

* Explain what `GROUP BY` means in simple words.
* Use `GROUP BY` with functions like COUNT, SUM, AVG, MAX, and MIN.
* Group data by one or more columns.
* Understand the difference between `WHERE` and `HAVING`.

---

## 1. What is GROUP BY?

Think about a classroom:

* You have many students.
* Each student belongs to a grade (Grade 10, Grade 11, Grade 12).
* If you want to know how many students are in each grade, you don’t want to list them one by one—you want to **group them by grade**.

That is exactly what `GROUP BY` does in SQL. It puts rows that have the same value into one group.

**Example:**

```sql
SELECT department, COUNT(*) AS num_employees
FROM employees
GROUP BY department;
```

➡️ This means: “Group all employees by their department, then count how many are in each department.”

---

## 2. Why do we use GROUP BY with Aggregate Functions?

On its own, `GROUP BY` just makes groups. To get useful numbers, we combine it with functions like:

* `COUNT()` → counts rows.
* `SUM()` → adds numbers.
* `AVG()` → finds the average.
* `MAX()` → finds the biggest.
* `MIN()` → finds the smallest.

**Example: Average Salary per Department**

```sql
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;
```

➡️ Groups employees by department, then calculates the average salary for each department.

---

## 3. GROUP BY Multiple Columns

You can group by more than one thing at the same time.

**Example:**

```sql
SELECT department, job_title, COUNT(*) AS num_employees
FROM employees
GROUP BY department, job_title;
```

➡️ This means: “Group employees by department *and then* by job title inside each department.”

So in the HR department, you’ll see how many Managers, how many Analysts, etc.

---

## 4. GROUP BY with WHERE

* `WHERE` is used to filter rows **before** grouping.

**Example:**

```sql
SELECT department, COUNT(*) AS num_employees
FROM employees
WHERE salary > 50000
GROUP BY department;
```

➡️ Only employees who earn more than 50,000 are counted.

---

## 5. GROUP BY with HAVING

* `HAVING` is used to filter groups **after** grouping.
* Think of it like this:

  * `WHERE` → filter individual rows.
  * `HAVING` → filter groups.

**Example:**

```sql
SELECT department, COUNT(*) AS num_employees
FROM employees
GROUP BY department
HAVING COUNT(*) > 5;
```

➡️ Only shows departments where the number of employees is greater than 5.

---

## 6. Common Mistakes Beginners Make

❌ **Mistake:** Selecting a column that is not grouped or aggregated.

```sql
SELECT department, salary FROM employees GROUP BY department;
```

➡️ Wrong because SQL doesn’t know *which* salary to show (there are many salaries in one department).

✅ **Correct:** Use an aggregate function.

```sql
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;
```

---

## 7. Real-Life Example: Sales Data

Suppose we have a sales table:

```
region | product | amount
-------|---------|-------
East   | Laptop  | 1000
East   | Phone   | 500
West   | Laptop  | 1200
West   | Phone   | 700
```

**Question:** What is the total sales in each region?

```sql
SELECT region, SUM(amount) AS total_sales
FROM sales
GROUP BY region;
```

➡️ Answer:

```
region | total_sales
-------|------------
East   | 1500
West   | 1900
```

---

## 8. Practice Questions for Students

1. Count how many employees are in each department.
2. Show the average salary for each job title.
3. Find the highest salary in each department.
4. Count employees in each department, but only include employees with a salary greater than 40,000.
5. Find the total sales per product, but only show products where sales are greater than 1000.

---

## ✅ Key Takeaways

* `GROUP BY` = put rows with the same value into one group.
* Always use `GROUP BY` with aggregate functions (COUNT, SUM, AVG, MAX, MIN).
* Use `WHERE` to filter rows before grouping.
* Use `HAVING` to filter groups after grouping.
* Think of `GROUP BY` as: “I want one row per group, not one row per person.”
