# SQL FULL OUTER JOIN – Beginner-Friendly Notes

## 🎯 Learning Objectives

By the end of this lesson, you should be able to:

* Understand what a `FULL OUTER JOIN` is.
* Explain it in everyday simple terms.
* Write queries using `FULL OUTER JOIN`.
* Know the difference between `INNER`, `LEFT`, `RIGHT`, and `FULL` joins.

---

## 1. What is a FULL OUTER JOIN?

A `FULL OUTER JOIN` returns **all rows from both tables**:

* If there is a match → it shows the matched row.
* If there is no match → it still shows the row, with `NULL` in the missing columns.

👉 Think of it as **combining LEFT JOIN and RIGHT JOIN together**.

---

## 2. Everyday Example

Imagine two classes:

* Class A: {Alice, Bob}
* Class B: {Bob, Charlie}

`FULL OUTER JOIN` would list **everyone from both classes**:

* Alice (only in Class A)
* Bob (in both)
* Charlie (only in Class B)

So no one is left out.

---

## 3. SQL Example

Suppose we have two tables:

**Table: customers**

```
id | name
---|------
1  | Alice
2  | Bob
3  | David
```

**Table: orders**

```
id | customer_name
---|---------------
1  | Bob
2  | Charlie
```

**Query:**

```sql
SELECT c.name AS customer, o.customer_name AS order_customer
FROM customers c
FULL OUTER JOIN orders o
ON c.name = o.customer_name;
```

**Result:**

```
customer | order_customer
---------|----------------
Alice    | NULL       -- customer with no order
Bob      | Bob        -- customer with order
David    | NULL       -- customer with no order
NULL     | Charlie    -- order with no customer
```

✅ Notice: We got all customers and all orders, even if they don’t match.

---

## 4. FULL OUTER JOIN vs Other Joins

* **INNER JOIN** → only matching rows.
* **LEFT JOIN** → all rows from the left table + matches.
* **RIGHT JOIN** → all rows from the right table + matches.
* **FULL OUTER JOIN** → all rows from both tables (matches + non-matches).

---

## 5. When to Use FULL OUTER JOIN

* To see all data from two tables, including unmatched rows.
* Useful in data analysis when you want to find:

  * Items in one table but missing in the other.
  * A complete picture of data from both sides.

⚠️ Not all SQL databases support `FULL OUTER JOIN` directly (e.g., MySQL requires a workaround using `UNION`).

---

## 6. Practice Questions

1. Write a query to combine all students from `classA` and `classB`, showing NULL if a student is missing in one class.
2. Show all employees and all departments, even if an employee has no department or a department has no employees.
3. In your own words, explain why `FULL OUTER JOIN` is more inclusive than `INNER JOIN`.

---

## ✅ Key Takeaways

* `FULL OUTER JOIN` = all rows from both tables.
* Missing matches are filled with `NULL`.
* It is like doing `LEFT JOIN` + `RIGHT JOIN`.
* Helpful when you don’t want to lose any data from either table.
