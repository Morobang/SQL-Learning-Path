# 3. Basic Queries - Essential SQL Query Skills

Master the fundamental SQL querying techniques that form the backbone of all database interactions.

## 📋 Learning Objectives
By the end of this section, you will be able to:
- Write effective SELECT statements to retrieve data
- Filter data using WHERE clauses with various conditions
- Sort query results using ORDER BY
- Remove duplicate values with DISTINCT
- Control result set size with LIMIT and OFFSET
- Use column and table aliases for cleaner code

## 📚 Topics Covered

### [01 - SELECT Basics](./01_SELECT_Basics.sql)
- Basic SELECT syntax
- Selecting all columns with *
- Selecting specific columns
- Column ordering and selection

### [02 - WHERE Clause](./02_WHERE_Clause.sql)  
- Filtering data with conditions
- Comparison operators (=, !=, <, >, <=, >=)
- Combining multiple conditions
- Working with different data types

### [03 - ORDER BY](./03_ORDER_BY.sql)
- Sorting results in ascending order
- Sorting results in descending order  
- Multi-column sorting
- Sorting by column position vs name

### [04 - DISTINCT](./04_DISTINCT.sql)
- Removing duplicate rows
- DISTINCT with single columns
- DISTINCT with multiple columns
- Performance considerations

### [05 - LIMIT AND OFFSET](./05_LIMIT_AND_OFFSET.sql)
- Controlling result set size
- Pagination techniques
- Database-specific syntax differences
- Performance optimization tips

### [06 - Aliases (AS)](./06_Aliases_AS.sql)
- Column aliases for readability
- Table aliases for shorter references
- Using aliases in complex queries
- Alias naming best practices

## 🎯 Prerequisites
- Completed [2-SQL-Data-Types](../2-SQL-Data-Types/README.md)
- Basic understanding of database tables
- SQL development environment set up

## ⏱️ Estimated Time
3-4 hours to complete all topics

## 🛠️ Practice Dataset

We recommend using the following sample data for practice:

```sql
-- Employees table for practice
CREATE TABLE Employees (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE,
    City VARCHAR(50)
);

-- Sample data
INSERT INTO Employees VALUES
(1, 'John', 'Smith', 'IT', 75000, '2022-01-15', 'New York'),
(2, 'Jane', 'Doe', 'HR', 65000, '2021-03-22', 'Los Angeles'),
(3, 'Bob', 'Johnson', 'IT', 80000, '2020-07-10', 'Chicago'),
(4, 'Alice', 'Brown', 'Finance', 70000, '2023-02-01', 'New York'),
(5, 'Charlie', 'Wilson', 'IT', 75000, '2022-11-05', 'Boston');
```

## 🛠️ Practice Exercises

### Beginner Level
1. Select all employees from the IT department
2. Find employees earning more than $70,000
3. List unique cities where employees work
4. Sort employees by hire date (newest first)
5. Show top 3 highest paid employees

### Intermediate Level  
1. Find employees hired in 2022, sorted by salary
2. List IT employees earning between $70,000 and $80,000
3. Show employee names as "Full Name" (FirstName + LastName)
4. Find the 2nd and 3rd highest paid employees using OFFSET
5. Create meaningful aliases for all columns in a complex query

## 💡 Key Concepts Mastered

After completing this section, you'll understand:

- **Data Retrieval**: How to extract exactly the data you need
- **Filtering**: Applying conditions to narrow down results  
- **Sorting**: Organizing data in meaningful ways
- **Deduplication**: Removing unwanted duplicate records
- **Pagination**: Handling large result sets efficiently
- **Code Clarity**: Using aliases to make queries readable

## 🚀 Real-World Applications

These basic query skills are used daily for:
- **Business Reports**: Sales summaries, employee lists
- **Data Analysis**: Finding trends and patterns
- **Web Applications**: User profiles, product catalogs
- **Data Migration**: Moving data between systems
- **Quality Assurance**: Validating data integrity

## 🔄 What's Next?

After mastering basic queries, you'll be ready for:
- **[4-Filtering-and-Conditions](../4-Filtering-and-Conditions/README.md)**: Advanced filtering techniques
- **[5-Functions](../5-Functions/README.md)**: String, numeric, and date functions
- **[6-Grouping-and-Aggregation](../6-Grouping-and-Aggregation/README.md)**: Summarizing data with GROUP BY

## 🔄 Navigation
[← Previous: Data Types](../2-SQL-Data-Types/README.md) | [Next: Filtering & Conditions →](../4-Filtering-and-Conditions/README.md)

---
[🏠 Back to Main](../README.md)