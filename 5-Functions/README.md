# 5. Functions - SQL Built-in Functions and Operations

Master SQL's powerful built-in functions for string manipulation, numeric calculations, date operations, and data aggregation.

## 📋 Learning Objectives
By the end of this section, you will be able to:
- Use string functions for text manipulation and formatting
- Apply numeric functions for mathematical calculations
- Work with date/time functions for temporal data analysis
- Implement aggregate functions for data summarization
- Combine multiple functions in complex expressions
- Choose the right function for specific data processing needs

## 🗂️ Section Contents

### 📖 **[Concepts](./concepts/)** - Learn the Theory
**Start here to understand function categories and usage**
- [String Functions Overview](./concepts/string-functions.md) - Text manipulation concepts
- [Numeric Functions Overview](./concepts/numeric-functions.md) - Mathematical operations
- [Date Functions Overview](./concepts/date-functions.md) - Temporal data handling
- [Aggregate Functions Overview](./concepts/aggregate-functions.md) - Data summarization

### 💻 **[Examples](./examples/)** - See Working Code
**Run these examples to see functions in action**
- [01-string-functions.sql](./examples/01-string-functions.sql) - Text manipulation examples
- [02-numeric-functions.sql](./examples/02-numeric-functions.sql) - Mathematical calculations
- [03-date-functions.sql](./examples/03-date-functions.sql) - Date/time operations
- [04-aggregate-functions.sql](./examples/04-aggregate-functions.sql) - Data summarization

### 🏋️ **[Exercises](./exercises/)** - Practice Your Skills  
**Test your understanding with hands-on problems**
- [Practice Problems](./exercises/README.md) - Progressive function exercises
- [Solutions](./exercises/solutions.sql) - Check your answers

### 📚 **[Resources](./resources/)** - Quick Reference
**Handy function references and cheat sheets**
- [Function Reference](./resources/function-reference.md) - Complete function catalog
- [Common Patterns](./resources/common-patterns.md) - Frequently used combinations
- [Database Differences](./resources/database-differences.md) - Vendor-specific variations

## 🎯 Learning Path

Follow this recommended sequence:

1. **📖 Read Concepts**: Start with [String Functions](./concepts/string-functions.md)
2. **💻 Run Examples**: Practice with [String Examples](./examples/01-string-functions.sql)  
3. **🏋️ Do Exercises**: Test yourself with [Practice Problems](./exercises/README.md)
4. **📚 Reference**: Use [Function Reference](./resources/function-reference.md) as needed

## 🛠️ Prerequisites
- Completed [4-Filtering-and-Conditions](../4-Filtering-and-Conditions/README.md)
- Understanding of SELECT statements and WHERE clauses
- Familiarity with different data types

## ⏱️ Estimated Time
4-5 hours to complete all materials

## 🎯 Key Function Categories

### String Functions
- **UPPER()/LOWER()** - Change text case
- **SUBSTRING()** - Extract parts of strings
- **LENGTH()/LEN()** - Get string length
- **CONCAT()** - Combine strings
- **TRIM()** - Remove whitespace
- **REPLACE()** - Replace text patterns

### Numeric Functions
- **ROUND()** - Round to specified decimals
- **CEILING()/FLOOR()** - Round up/down to integers
- **ABS()** - Absolute value
- **POWER()** - Exponentiation
- **SQRT()** - Square root
- **RAND()** - Random numbers

### Date Functions
- **GETDATE()/NOW()** - Current date/time
- **DATEADD()** - Add time intervals
- **DATEDIFF()** - Calculate time differences
- **YEAR()/MONTH()/DAY()** - Extract date parts
- **FORMAT()** - Format dates for display

### Aggregate Functions
- **COUNT()** - Count rows or values
- **SUM()** - Add up numeric values
- **AVG()** - Calculate averages
- **MIN()/MAX()** - Find minimum/maximum values
- **GROUP_CONCAT()** - Concatenate grouped values

## 🚀 Real-World Applications

These functions are essential for:
- **Data Cleaning**: Standardizing text, fixing formatting issues
- **Reporting**: Formatting output for business reports
- **Analytics**: Calculating metrics and KPIs
- **Data Transformation**: Converting data between formats
- **User Interface**: Displaying data in user-friendly formats

## ⚠️ Database Differences

While SQL is standardized, function syntax can vary:

| Function | SQL Server | MySQL | PostgreSQL | Oracle |
|----------|------------|-------|------------|--------|
| String Length | `LEN()` | `LENGTH()` | `LENGTH()` | `LENGTH()` |
| Current Date | `GETDATE()` | `NOW()` | `NOW()` | `SYSDATE` |
| Substring | `SUBSTRING()` | `SUBSTRING()` | `SUBSTRING()` | `SUBSTR()` |
| Concatenation | `+` or `CONCAT()` | `CONCAT()` | `\|\|` or `CONCAT()` | `\|\|` |

## 💡 Success Tips

1. **Practice with Real Data**: Use actual datasets to understand function impact
2. **Combine Functions**: Learn to chain functions for complex operations
3. **Handle NULLs**: Understand how functions behave with NULL values
4. **Check Documentation**: Function behavior can vary between database versions
5. **Performance Awareness**: Some functions can impact query performance

## 🔄 Navigation
[← Previous: Filtering & Conditions](../4-Filtering-and-Conditions/README.md) | [Next: Grouping & Aggregation →](../6-Grouping-and-Aggregation/README.md)

---
[🏠 Back to Main](../README.md)