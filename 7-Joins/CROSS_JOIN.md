# SQL CROSS JOIN – Beginner-Friendly Notes

## 🎯 Learning Objectives

By the end of this lesson, you should be able to:

* Understand what a `CROSS JOIN` is.
* Explain it in everyday simple terms.
* Write queries using `CROSS JOIN`.
* Know when to use it and when not to use it.

---

## 1. What is a CROSS JOIN?

A `CROSS JOIN` combines **every row from one table with every row from another table**.

👉 Think of it as making **all possible combinations** between two sets.

---

## 2. Everyday Example

Imagine:

* You have 2 shirts: {Red, Blue}
* You have 3 pants: {Black, White, Grey}

A `CROSS JOIN` will give you **all combinations of shirt + pants**:

* Red + Black
* Red + White
* Red + Grey
* Blue + Black
* Blue + White
* Blue + Grey

➡️ That’s **2 × 3 = 6 combinations**.

---

## 3. SQL Example

Let’s say we have two tables:

**Table: colors**

```
id | color
---|------
1  | Red
2  | Blue
```

**Table: shapes**

```
id | shape
---|------
1  | Circle
2  | Square
3  | Triangle
```

**Query:**

```sql
SELECT color, shape
FROM colors
CROSS JOIN shapes;
```

**Result:**

```
color | shape
------|---------
Red   | Circle
Red   | Square
Red   | Triangle
Blue  | Circle
Blue  | Square
Blue  | Triangle
```

✅ Notice: Every color is matched with every shape.

---

## 4. CROSS JOIN vs INNER JOIN

* `CROSS JOIN`: No condition, gives **all combinations**.
* `INNER JOIN`: Matches rows based on a condition (usually a key).

**Example INNER JOIN:**

```sql
SELECT employees.name, departments.name
FROM employees
INNER JOIN departments
ON employees.dept_id = departments.id;
```

➡️ Only shows employees matched to their department.

**Example CROSS JOIN:**

```sql
SELECT employees.name, departments.name
FROM employees
CROSS JOIN departments;
```

➡️ Shows every employee with every department (usually too many rows!).

---

## 5. When to Use CROSS JOIN

* When you need **all combinations** (like generating schedules, pairing items, or testing data).
* When creating a reference table (e.g., all dates × all products).

⚠️ Be careful: If one table has 100 rows and another has 1000 rows, the result will have **100 × 1000 = 100,000 rows**!

---

## 6. Practice Questions

1. You have a `students` table with 3 rows and a `courses` table with 2 rows. How many rows will a `CROSS JOIN` produce?
2. Write a query that cross joins a `products` table and a `regions` table to generate all possible product-region combinations.
3. Explain the difference between `CROSS JOIN` and `INNER JOIN` in your own words.

---

## ✅ Key Takeaways

* `CROSS JOIN` = all possible combinations.
* Often explained as a **cartesian product**.
* Can generate a lot of rows, so use carefully.
* Great for combinations, not for filtering matches.
