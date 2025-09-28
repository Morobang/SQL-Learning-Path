# 6. Grouping and Aggregation - Data Summarization

Master the art of summarizing and analyzing data using GROUP BY, HAVING, and advanced grouping techniques.

## 📋 Learning Objectives
By the end of this section, you will be able to:
- Group data using GROUP BY clause effectively
- Filter grouped data with HAVING clause
- Use aggregate functions (SUM, COUNT, AVG, MIN, MAX)
- Implement advanced grouping techniques (ROLLUP, CUBE, GROUPING SETS)
- Understand the difference between WHERE and HAVING
- Optimize grouping queries for performance

## 🗂️ Section Contents

### 📖 **[Concepts](./concepts/)** - Learn the Theory
**Start here to understand the fundamentals**
- [GROUP BY Basics](./concepts/group-by-basics.md) - Core grouping concepts
- [HAVING Clause](./concepts/having-clause.md) - Filtering grouped data  
- [Advanced Grouping](./concepts/advanced-grouping.md) - ROLLUP, CUBE, GROUPING SETS
- [Aggregate Functions](./concepts/aggregate-functions.md) - SUM, COUNT, AVG, etc.

### 💻 **[Examples](./examples/)** - See Working Code
**Run these examples to see concepts in action**
- [01-group-by-examples.sql](./examples/01-group-by-examples.sql) - Basic grouping examples
- [02-having-examples.sql](./examples/02-having-examples.sql) - HAVING clause demos
- [03-advanced-examples.sql](./examples/03-advanced-examples.sql) - Complex grouping
- [sample-data.sql](./examples/sample-data.sql) - Test data for practice

### 🏋️ **[Exercises](./exercises/)** - Practice Your Skills  
**Test your understanding with hands-on problems**
- [Practice Problems](./exercises/README.md) - Structured exercises by difficulty
- [Solutions](./exercises/solutions.sql) - Check your answers

### 📚 **[Resources](./resources/)** - Quick Reference
**Handy references and tips**
- [Quick Reference](./resources/cheat-sheet.md) - Syntax and functions summary
- [Common Mistakes](./resources/common-mistakes.md) - What to avoid
- [Performance Tips](./resources/performance-tips.md) - Optimization advice

## 🎯 Learning Path

Follow this recommended sequence:

1. **📖 Read Concepts**: Start with [GROUP BY Basics](./concepts/group-by-basics.md)
2. **💻 Run Examples**: Practice with [Basic Examples](./examples/01-group-by-examples.sql)  
3. **🏋️ Do Exercises**: Test yourself with [Practice Problems](./exercises/README.md)
4. **📚 Reference**: Use [Cheat Sheet](./resources/cheat-sheet.md) as needed

## 🛠️ Prerequisites
- Completed [5-Functions](../5-Functions/README.md)
- Understanding of SELECT statements and WHERE clauses
- Familiarity with basic SQL functions

## ⏱️ Estimated Time
4-5 hours to complete all materials

## 🎯 Key Concepts Covered

### GROUP BY Fundamentals
- Grouping rows by column values
- Using multiple columns in GROUP BY
- Relationship between GROUP BY and SELECT columns

### Aggregate Functions
- COUNT() - Counting rows and non-null values
- SUM() - Adding up numeric values
- AVG() - Calculating averages  
- MIN()/MAX() - Finding minimum and maximum values
- DISTINCT with aggregates

### HAVING Clause
- Filtering groups after aggregation
- Difference between WHERE and HAVING
- Using aggregate functions in HAVING
- Complex HAVING conditions

### Advanced Grouping
- ROLLUP - Creating subtotals and grand totals
- CUBE - All possible grouping combinations
- GROUPING SETS - Custom grouping combinations
- NULL handling in grouped results

## 🚀 Real-World Applications

These skills are essential for:
- **Sales Reports**: Revenue by region, product, time period
- **Analytics**: User behavior analysis, conversion metrics
- **Business Intelligence**: KPI dashboards, performance metrics
- **Data Analysis**: Statistical summaries, trend analysis
- **Financial Reporting**: Budget analysis, cost centers

## 💡 Success Tips

1. **Master the basics first**: Understand GROUP BY before advanced features
2. **Practice with real data**: Use meaningful datasets for exercises
3. **Understand aggregation**: Know what each function actually calculates
4. **Test edge cases**: Try queries with NULL values and empty groups
5. **Think about performance**: Consider indexing for large datasets

## 🔄 Navigation
[← Previous: Functions](../5-Functions/README.md) | [Next: Joins →](../7-Joins/README.md)

---
[🏠 Back to Main](../README.md)