# 📝 SQL Interview Questions: Complete Study Guide (100+ Questions)

## 🎯 Introduction: How to Use This Guide

This guide contains **100+ SQL questions** organized by difficulty level. Think of it like learning to drive: start with the basics (how to start the car), then move to advanced skills (parallel parking)! 🚗

**How to practice:**
1. Try to solve the question yourself first
2. Check the solution approach
3. Understand the concept, not just the answer
4. Practice with real database tools

---

## 📚 Section 1: Basic SQL Questions (1-25)

### 1. What is SQL?
**Answer:** SQL (Structured Query Language) is a programming language used to manage and query data in relational databases. It's like learning the grammar rules for talking to databases!

### 2. What are the different types of SQL commands?
**Answer:** 
- DDL (Data Definition Language): CREATE, ALTER, DROP
- DML (Data Manipulation Language): SELECT, INSERT, UPDATE, DELETE  
- DCL (Data Control Language): GRANT, REVOKE
- TCL (Transaction Control Language): COMMIT, ROLLBACK

### 3. What is a primary key?
**Answer:** A primary key is a unique identifier for each row in a table. Like your student ID - no two students have the same ID!

### 4. What is a foreign key?
**Answer:** A foreign key creates a relationship between two tables. It's like your library card number that links you to your borrowed books.

### 5. What is the difference between DELETE and TRUNCATE?
```sql
-- DELETE: Removes specific rows, can be rolled back
DELETE FROM students WHERE grade = 'F';

-- TRUNCATE: Removes ALL rows, faster, cannot be rolled back  
TRUNCATE TABLE students;
```

### 6. What is the difference between DROP and TRUNCATE?
**Answer:** DROP removes the entire table structure, TRUNCATE just removes all data but keeps the table.

### 7. How do you add a new column to a table?
```sql
ALTER TABLE students ADD COLUMN phone_number VARCHAR(15);
```

### 8. How do you remove a column from a table?
```sql
ALTER TABLE students DROP COLUMN phone_number;
```

### 9. What is the ORDER BY clause used for?
```sql
SELECT name, grade FROM students ORDER BY grade DESC;
```

### 10. What is the WHERE clause used for?
```sql
SELECT * FROM students WHERE grade = 'A';
```

### 11. How do you eliminate duplicate records?
```sql
SELECT DISTINCT department FROM employees;
```

### 12. What are SQL constraints?
**Answer:** Rules that enforce data integrity, like NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK.

### 13. How do you create a table?
```sql
CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 0)
);
```

### 14. What is the BETWEEN operator?
```sql
SELECT * FROM products WHERE price BETWEEN 10 AND 100;
```

### 15. What is the IN operator?
```sql
SELECT * FROM students WHERE grade IN ('A', 'B');
```

### 16. What is the LIKE operator?
```sql
SELECT * FROM employees WHERE name LIKE 'J%';  -- Names starting with J
```

### 17. What are wildcards in SQL?
**Answer:** % (multiple characters) and _ (single character)

### 18. What is the IS NULL operator?
```sql
SELECT * FROM customers WHERE email IS NULL;
```

### 19. How do you update records?
```sql
UPDATE students SET grade = 'B' WHERE id = 101;
```

### 20. How do you insert records?
```sql
INSERT INTO students (id, name, grade) VALUES (101, 'John', 'A');
```

### 21. What is the LIMIT clause?
```sql
SELECT * FROM products LIMIT 10;  -- Get first 10 records
```

### 22. What is the TOP clause?
```sql
SELECT TOP 5 * FROM products;  -- SQL Server syntax
```

### 23. What are SQL comments?
```sql
-- Single line comment
/* Multi-line comment */
```

### 24. What is the AS keyword?
```sql
SELECT name AS student_name FROM students;
```

### 25. What are SQL operators?
**Answer:** Arithmetic (+, -, *, /), Comparison (=, <>, >, <), Logical (AND, OR, NOT)

---

## 📊 Section 2: Intermediate SQL Questions (26-50)

### 26. What are SQL joins?
**Answer:** Joins combine data from two or more tables based on related columns.

### 27. Explain INNER JOIN with example
```sql
SELECT students.name, courses.course_name
FROM students
INNER JOIN courses ON students.id = courses.student_id;
```

### 28. Explain LEFT JOIN with example
```sql
SELECT students.name, courses.course_name
FROM students
LEFT JOIN courses ON students.id = courses.student_id;
```

### 29. Explain RIGHT JOIN with example
```sql
SELECT students.name, courses.course_name
FROM students
RIGHT JOIN courses ON students.id = courses.student_id;
```

### 30. Explain FULL OUTER JOIN with example
```sql
SELECT students.name, courses.course_name
FROM students
FULL OUTER JOIN courses ON students.id = courses.student_id;
```

### 31. What is a self join?
```sql
-- Find employees and their managers
SELECT e.name AS employee, m.name AS manager
FROM employees e
JOIN employees m ON e.manager_id = m.id;
```

### 32. What is the GROUP BY clause?
```sql
SELECT department, AVG(salary) 
FROM employees 
GROUP BY department;
```

### 33. What is the HAVING clause?
```sql
SELECT department, AVG(salary)
FROM employees
GROUP BY department
HAVING AVG(salary) > 50000;
```

### 34. Difference between WHERE and HAVING
**Answer:** WHERE filters rows before grouping, HAVING filters groups after grouping.

### 35. What are aggregate functions?
**Answer:** SUM(), AVG(), COUNT(), MAX(), MIN()

### 36. What is the difference between COUNT(*) and COUNT(column_name)?
**Answer:** COUNT(*) counts all rows, COUNT(column_name) counts non-NULL values in that column.

### 37. What is a subquery?
```sql
SELECT name FROM students 
WHERE grade = (SELECT MAX(grade) FROM students);
```

### 38. What is a correlated subquery?
```sql
-- Find employees who earn more than their department average
SELECT name, salary, department
FROM employees e1
WHERE salary > (SELECT AVG(salary) FROM employees e2 WHERE e2.department = e1.department);
```

### 39. What are SQL functions?
**Answer:** Built-in functions like UPPER(), LOWER(), LEN(), ROUND(), NOW()

### 40. What is the CASE statement?
```sql
SELECT name,
    CASE 
        WHEN grade = 'A' THEN 'Excellent'
        WHEN grade = 'B' THEN 'Good'
        ELSE 'Needs Improvement'
    END as performance
FROM students;
```

### 41. What is the COALESCE function?
```sql
SELECT name, COALESCE(phone, 'No Phone') as contact FROM customers;
```

### 42. What is the NULLIF function?
```sql
SELECT NULLIF(0, 0);  -- Returns NULL
SELECT NULLIF(5, 0);  -- Returns 5
```

### 43. What is a view?
```sql
CREATE VIEW top_students AS
SELECT name, grade FROM students WHERE grade = 'A';
```

### 44. What is an index?
```sql
CREATE INDEX idx_students_name ON students(name);
```

### 45. What is a stored procedure?
```sql
CREATE PROCEDURE GetTopStudents()
BEGIN
    SELECT name, grade FROM students WHERE grade = 'A';
END;
```

### 46. What is a trigger?
**Answer:** Code that automatically executes when certain events occur (INSERT, UPDATE, DELETE).

### 47. What is a transaction?
```sql
BEGIN TRANSACTION;
UPDATE account SET balance = balance - 100 WHERE id = 1;
UPDATE account SET balance = balance + 100 WHERE id = 2;
COMMIT;
```

### 48. What is ACID properties?
**Answer:** Atomicity, Consistency, Isolation, Durability - properties that ensure database transactions are processed reliably.

### 49. What is normalization?
**Answer:** The process of organizing data to reduce redundancy and improve data integrity.

### 50. What are the normal forms?
**Answer:** 1NF, 2NF, 3NF, BCNF - different levels of database normalization.

---

## 🚀 Section 3: Advanced SQL Questions (51-75)

### 51. What are window functions?
```sql
SELECT name, salary, 
       RANK() OVER (ORDER BY salary DESC) as rank
FROM employees;
```

### 52. Explain RANK() function
```sql
SELECT name, grade,
       RANK() OVER (ORDER BY grade DESC) as rank
FROM students;
```

### 53. Explain DENSE_RANK() function
```sql
SELECT name, grade,
       DENSE_RANK() OVER (ORDER BY grade DESC) as dense_rank
FROM students;
```

### 54. Explain ROW_NUMBER() function
```sql
SELECT name, grade,
       ROW_NUMBER() OVER (ORDER BY grade DESC) as row_num
FROM students;
```

### 55. What is the difference between RANK and DENSE_RANK?
**Answer:** RANK skips numbers for ties, DENSE_RANK doesn't.

### 56. What is the NTILE() function?
```sql
SELECT name, salary,
       NTILE(4) OVER (ORDER BY salary DESC) as quartile
FROM employees;
```

### 57. What are lead and lag functions?
```sql
SELECT month, sales,
       LAG(sales) OVER (ORDER BY month) as prev_month,
       LEAD(sales) OVER (ORDER BY month) as next_month
FROM monthly_sales;
```

### 58. What is a common table expression (CTE)?
```sql
WITH TopStudents AS (
    SELECT name, grade FROM students WHERE grade = 'A'
)
SELECT * FROM TopStudents;
```

### 59. What is a recursive CTE?
```sql
WITH RECURSIVE OrgChart AS (
    SELECT id, name, manager_id FROM employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.id, e.name, e.manager_id FROM employees e
    INNER JOIN OrgChart oc ON e.manager_id = oc.id
)
SELECT * FROM OrgChart;
```

### 60. What is the difference between UNION and UNION ALL?
**Answer:** UNION removes duplicates, UNION ALL keeps all records.

### 61. What is a pivot table in SQL?
```sql
SELECT *
FROM (
    SELECT department, gender, salary
    FROM employees
) AS SourceTable
PIVOT (
    AVG(salary)
    FOR gender IN ([Male], [Female])
) AS PivotTable;
```

### 62. What is the difference between EXISTS and IN?
```sql
-- EXISTS (usually more efficient for large datasets)
SELECT name FROM students s
WHERE EXISTS (SELECT 1 FROM grades g WHERE g.student_id = s.id AND g.grade = 'A');

-- IN
SELECT name FROM students 
WHERE id IN (SELECT student_id FROM grades WHERE grade = 'A');
```

### 63. What is the difference between ANY and ALL?
```sql
-- ANY: True if any value meets condition
SELECT name FROM students WHERE grade > ANY (SELECT grade FROM class_top);

-- ALL: True if all values meet condition  
SELECT name FROM students WHERE grade > ALL (SELECT grade FROM class_bottom);
```

### 64. What is a materialized view?
**Answer:** A view that stores the result set physically and gets updated periodically.

### 65. What is query optimization?
**Answer:** The process of improving SQL query performance through indexing, better joins, etc.

### 66. What is execution plan?
**Answer:** A roadmap that shows how the database will execute a query.

### 67. What are clustered and non-clustered indexes?
**Answer:** Clustered indexes determine physical order of data, non-clustered indexes are separate structures.

### 68. What is deadlock?
**Answer:** When two transactions are waiting for each other to release locks.

### 69. What is database isolation?
**Answer:** The degree to which operations in one transaction are isolated from operations in other transactions.

### 70. What are isolation levels?
**Answer:** Read Uncommitted, Read Committed, Repeatable Read, Serializable.

### 71. What is database replication?
**Answer:** The process of copying and maintaining database objects in multiple databases.

### 72. What is database sharding?
**Answer:** Horizontal partitioning of data across multiple servers.

### 73. What is ETL?
**Answer:** Extract, Transform, Load - process of moving data from source to data warehouse.

### 74. What is data warehousing?
**Answer:** A central repository of integrated data from one or more sources.

### 75. What is OLAP vs OLTP?
**Answer:** OLTP (Online Transaction Processing) for transactions, OLAP (Online Analytical Processing) for analysis.

---

## 💡 Section 4: Scenario-Based Questions (76-100)

### 76. How would you find the second highest salary?
```sql
SELECT MAX(salary) FROM employees 
WHERE salary < (SELECT MAX(salary) FROM employees);
```

### 77. How would you find duplicate emails?
```sql
SELECT email, COUNT(*) FROM users GROUP BY email HAVING COUNT(*) > 1;
```

### 78. How would you delete duplicates?
```sql
DELETE FROM users 
WHERE id NOT IN (SELECT MIN(id) FROM users GROUP BY email);
```

### 79. How would you find employees with the same salary?
```sql
SELECT salary, COUNT(*) 
FROM employees 
GROUP BY salary 
HAVING COUNT(*) > 1;
```

### 80. How would you find the nth highest salary?
```sql
SELECT DISTINCT salary
FROM employees e1
WHERE 2 = (SELECT COUNT(DISTINCT salary) FROM employees e2 WHERE e2.salary >= e1.salary);
```

### 81. How would you find department-wise maximum salary?
```sql
SELECT department, MAX(salary) 
FROM employees 
GROUP BY department;
```

### 82. How would you find employees who earn more than their managers?
```sql
SELECT e.name, e.salary, m.name as manager, m.salary as manager_salary
FROM employees e
JOIN employees m ON e.manager_id = m.id
WHERE e.salary > m.salary;
```

### 83. How would you find the cumulative sum of sales?
```sql
SELECT date, sales,
       SUM(sales) OVER (ORDER BY date) as cumulative_sales
FROM daily_sales;
```

### 84. How would you find month-over-month growth?
```sql
SELECT month, sales,
       (sales - LAG(sales) OVER (ORDER BY month)) / LAG(sales) OVER (ORDER BY month) * 100 as growth
FROM monthly_sales;
```

### 85. How would you find the top 3 products in each category?
```sql
SELECT category, product, sales
FROM (
    SELECT category, product, sales,
           RANK() OVER (PARTITION BY category ORDER BY sales DESC) as rank
    FROM products
) ranked
WHERE rank <= 3;
```

### 86. How would you find customers who bought all products?
```sql
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(DISTINCT product_id) = (SELECT COUNT(*) FROM products);
```

### 87. How would you find consecutive login days?
```sql
WITH login_dates AS (
    SELECT user_id, login_date,
           login_date - ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) as grp
    FROM logins
)
SELECT user_id, MIN(login_date) as start_date, MAX(login_date) as end_date,
       COUNT(*) as consecutive_days
FROM login_dates
GROUP BY user_id, grp
HAVING COUNT(*) >= 3;
```

### 88. How would you find the median salary?
```sql
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) as median
FROM employees;
```

### 89. How would you find students with grades above average?
```sql
SELECT name, grade
FROM students
WHERE grade > (SELECT AVG(grade) FROM students);
```

### 90. How would you find the most recent order for each customer?
```sql
SELECT customer_id, order_date, order_amount
FROM orders o1
WHERE order_date = (SELECT MAX(order_date) FROM orders o2 WHERE o2.customer_id = o1.customer_id);
```

### 91. How would you find employees in the same department with the same salary?
```sql
SELECT department, salary, GROUP_CONCAT(name) as employees
FROM employees
GROUP BY department, salary
HAVING COUNT(*) > 1;
```

### 92. How would you find the hierarchy of managers?
```sql
WITH RECURSIVE OrgChart AS (
    SELECT id, name, manager_id, 1 as level
    FROM employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.id, e.name, e.manager_id, oc.level + 1
    FROM employees e
    INNER JOIN OrgChart oc ON e.manager_id = oc.id
)
SELECT * FROM OrgChart;
```

### 93. How would you find customers who never ordered?
```sql
SELECT name FROM customers
WHERE id NOT IN (SELECT customer_id FROM orders);
```

### 94. How would you find the busiest day of the week?
```sql
SELECT DAYNAME(order_date) as day, COUNT(*) as orders
FROM orders
GROUP BY DAYNAME(order_date)
ORDER BY orders DESC
LIMIT 1;
```

### 95. How would you find products that always sold together?
```sql
SELECT o1.product_id as product1, o2.product_id as product2, COUNT(*) as times_together
FROM orders o1
JOIN orders o2 ON o1.order_id = o2.order_id AND o1.product_id < o2.product_id
GROUP BY o1.product_id, o2.product_id
HAVING COUNT(*) > 5;
```

### 96. How would you find the average time between orders?
```sql
SELECT customer_id, AVG(DATEDIFF(next_order_date, order_date)) as avg_days
FROM (
    SELECT customer_id, order_date,
           LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) as next_order_date
    FROM orders
) order_sequence
WHERE next_order_date IS NOT NULL
GROUP BY customer_id;
```

### 97. How would you find the retention rate?
```sql
SELECT month,
       COUNT(DISTINCT current_month.users) as retained_users,
       COUNT(DISTINCT current_month.users) / NULLIF(COUNT(DISTINCT previous_month.users), 0) as retention_rate
FROM user_activity current_month
LEFT JOIN user_activity previous_month 
    ON current_month.user_id = previous_month.user_id 
    AND current_month.month = previous_month.month + 1
GROUP BY month;
```

### 98. How would you find the most common purchase sequence?
```sql
WITH purchase_sequences AS (
    SELECT user_id, 
           GROUP_CONCAT(product_id ORDER BY purchase_date) as sequence
    FROM purchases
    GROUP BY user_id
)
SELECT sequence, COUNT(*) as frequency
FROM purchase_sequences
GROUP BY sequence
ORDER BY frequency DESC
LIMIT 1;
```

### 99. How would you find users with increasing purchases?
```sql
SELECT user_id
FROM (
    SELECT user_id, purchase_date, amount,
           amount > LAG(amount) OVER (PARTITION BY user_id ORDER BY purchase_date) as increased
    FROM purchases
) purchase_trends
GROUP BY user_id
HAVING SUM(CASE WHEN increased THEN 0 ELSE 1 END) = 0;
```

### 100. How would you find the most valuable customer?
```sql
SELECT customer_id, SUM(amount) as total_spent
FROM orders
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 1;
```

### 101. How would you find the longest streak of increasing sales?
```sql
WITH sales_growth AS (
    SELECT month, sales,
           sales > LAG(sales) OVER (ORDER BY month) as increased
    FROM monthly_sales
),
streaks AS (
    SELECT month, sales, increased,
           SUM(CASE WHEN increased THEN 0 ELSE 1 END) OVER (ORDER BY month) as streak_group
    FROM sales_growth
)
SELECT MAX(streak_length) as longest_streak
FROM (
    SELECT streak_group, COUNT(*) as streak_length
    FROM streaks
    WHERE increased = 1
    GROUP BY streak_group
) streak_lengths;
```

---

## 🎯 Final Tips for SQL Interviews

1. **Practice, practice, practice** - Use platforms like LeetCode, HackerRank
2. **Understand the concepts** - Don't just memorize answers
3. **Think out loud** - Explain your thought process
4. **Consider edge cases** - NULL values, empty tables, duplicates
5. **Optimize for performance** - Use indexes, efficient joins
6. **Test your queries** - Make sure they work correctly

Remember: **SQL is a skill that improves with practice!** The more you work with real data, the better you'll become. 🚀

Good luck with your interviews! You've got this! 💪