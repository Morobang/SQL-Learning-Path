# 2. SQL Data Types - Understanding Data Storage

Master the fundamental data types in SQL and learn how to choose the right type for your data storage needs.

## 📋 Learning Objectives
By the end of this section, you will be able to:
- Understand different categories of SQL data types
- Choose appropriate numeric types for different scenarios
- Work with various string/text data types effectively
- Handle date and time data correctly
- Understand NULL values and default value concepts
- Apply data type best practices for database design

## 🗂️ Section Contents

### 📖 **[Concepts](./concepts/)** - Learn the Theory
**Start here to understand data type fundamentals**
- [Numeric Types Overview](./concepts/numeric-types.md) - INT, DECIMAL, FLOAT, etc.
- [String Types Overview](./concepts/string-types.md) - VARCHAR, CHAR, TEXT, etc.
- [Date & Time Types Overview](./concepts/date-time-types.md) - DATE, DATETIME, TIMESTAMP
- [NULL and Default Values](./concepts/null-default-values.md) - Handling missing data

### 💻 **[Examples](./examples/)** - See Working Code
**Run these examples to see data types in action**
- [01-numeric-types.sql](./examples/01-numeric-types.sql) - Integer, decimal, and floating-point examples
- [02-string-types.sql](./examples/02-string-types.sql) - Text and character data examples
- [03-date-time-types.sql](./examples/03-date-time-types.sql) - Date and time handling examples
- [04-null-default-values.sql](./examples/04-null-default-values.sql) - NULL handling and defaults

### 🏋️ **[Exercises](./exercises/)** - Practice Your Skills  
**Test your understanding with hands-on problems**
- [Practice Problems](./exercises/README.md) - Data type selection and usage exercises
- [Solutions](./exercises/solutions.sql) - Check your answers

### 📚 **[Resources](./resources/)** - Quick Reference
**Handy references for data types**
- [Data Type Reference](./resources/data-type-reference.md) - Complete data type catalog
- [Database Differences](./resources/database-differences.md) - Vendor-specific variations
- [Best Practices](./resources/best-practices.md) - Choosing the right data types

## 🎯 Learning Path

Follow this recommended sequence:

1. **📖 Read Concepts**: Start with [Numeric Types](./concepts/numeric-types.md)
2. **💻 Run Examples**: Practice with [Numeric Examples](./examples/01-numeric-types.sql)  
3. **🏋️ Do Exercises**: Test yourself with [Practice Problems](./exercises/README.md)
4. **📚 Reference**: Use [Data Type Reference](./resources/data-type-reference.md) as needed

## 🛠️ Prerequisites
- Completed [1-SQL-Basics](../1-SQL-Basics/README.md)
- Understanding of basic SQL syntax
- Database environment set up

## ⏱️ Estimated Time
2-3 hours to complete all materials

## 🎯 Key Data Type Categories

### Numeric Types
- **INT/INTEGER** - Whole numbers (-2,147,483,648 to 2,147,483,647)
- **BIGINT** - Large whole numbers
- **DECIMAL/NUMERIC** - Exact decimal numbers (for money, measurements)
- **FLOAT/REAL** - Approximate decimal numbers (for scientific data)
- **SMALLINT** - Small whole numbers (-32,768 to 32,767)

### String Types
- **VARCHAR(n)** - Variable-length strings up to n characters
- **CHAR(n)** - Fixed-length strings, always n characters
- **TEXT** - Large text data (books, articles, descriptions)
- **NVARCHAR** - Unicode variable-length strings
- **NCHAR** - Unicode fixed-length strings

### Date & Time Types
- **DATE** - Date only (YYYY-MM-DD)
- **TIME** - Time only (HH:MM:SS)
- **DATETIME** - Date and time combined
- **TIMESTAMP** - System timestamp (often with timezone)
- **YEAR** - Year only (MySQL specific)

### Other Important Types
- **BOOLEAN/BIT** - True/false values
- **BINARY** - Binary data
- **UUID/UNIQUEIDENTIFIER** - Globally unique identifiers

## 🚀 Real-World Applications

### E-commerce Database
- **Product IDs**: INT or BIGINT
- **Prices**: DECIMAL(10,2) for exact currency
- **Product Names**: VARCHAR(255)
- **Descriptions**: TEXT
- **Created Date**: DATETIME

### User Management System
- **User IDs**: INT or UUID
- **Usernames**: VARCHAR(50)
- **Emails**: VARCHAR(255)
- **Passwords**: VARCHAR(255) (hashed)
- **Last Login**: TIMESTAMP

### Financial System
- **Account Numbers**: VARCHAR(20) or BIGINT
- **Balances**: DECIMAL(15,2) for precision
- **Transaction Dates**: DATETIME
- **Currency Codes**: CHAR(3) (USD, EUR, etc.)

## ⚠️ Common Mistakes to Avoid

1. **Using FLOAT for money** - Use DECIMAL instead for precision
2. **VARCHAR too small** - Plan for growth, use reasonable limits
3. **Wrong date types** - Choose based on precision needs
4. **Ignoring NULL handling** - Plan for missing data scenarios
5. **Not considering storage size** - Larger types use more space

## 💡 Success Tips

1. **Plan for Growth**: Choose data types that can accommodate future needs
2. **Precision Matters**: Use DECIMAL for financial calculations
3. **Consider Performance**: Smaller data types query faster
4. **Document Choices**: Record why you chose specific data types
5. **Test with Real Data**: Validate your choices with actual data volumes

## 🔄 Navigation
[← Previous: SQL Basics](../1-SQL-Basics/README.md) | [Next: Basic Queries →](../3-Basic-Queries/README.md)

---
[🏠 Back to Main](../README.md)