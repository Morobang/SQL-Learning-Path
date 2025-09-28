# 🏋️ Grouping and Aggregation - Practice Exercises

Test your understanding of GROUP BY, HAVING, and aggregate functions with these progressive exercises.

## 📊 Practice Dataset

Before starting, create this sample dataset:

```sql
-- Create sales data for practice
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    salesperson VARCHAR(50),
    region VARCHAR(50),
    product VARCHAR(50),
    amount DECIMAL(10,2),
    sale_date DATE,
    quarter VARCHAR(10)
);

-- Insert sample data
INSERT INTO sales VALUES
(1, 'John Smith', 'North', 'Laptop', 1200.00, '2024-01-15', 'Q1'),
(2, 'Jane Doe', 'South', 'Desktop', 800.00, '2024-01-20', 'Q1'),
(3, 'John Smith', 'North', 'Monitor', 300.00, '2024-02-10', 'Q1'),
(4, 'Mike Johnson', 'East', 'Laptop', 1200.00, '2024-02-15', 'Q1'),
(5, 'Jane Doe', 'South', 'Keyboard', 50.00, '2024-03-01', 'Q1'),
(6, 'John Smith', 'North', 'Mouse', 25.00, '2024-03-10', 'Q1'),
(7, 'Alice Brown', 'West', 'Laptop', 1200.00, '2024-04-01', 'Q2'),
(8, 'Mike Johnson', 'East', 'Desktop', 800.00, '2024-04-15', 'Q2'),
(9, 'Alice Brown', 'West', 'Monitor', 300.00, '2024-05-01', 'Q2'),
(10, 'Jane Doe', 'South', 'Laptop', 1200.00, '2024-05-15', 'Q2');
```

## 🎯 Exercise Set 1: Basic GROUP BY

### Exercise 1.1: Sales by Region
**Problem**: Find the total sales amount for each region.

**Expected Output**: Region name and total sales amount

**Hint**: Use GROUP BY with SUM()

---

### Exercise 1.2: Product Count by Salesperson
**Problem**: Count how many products each salesperson sold.

**Expected Output**: Salesperson name and number of products sold

**Hint**: Use GROUP BY with COUNT()

---

### Exercise 1.3: Average Sale Amount by Product
**Problem**: Calculate the average sale amount for each product type.

**Expected Output**: Product name and average sale amount

**Hint**: Use GROUP BY with AVG()

---

## 🎯 Exercise Set 2: HAVING Clause

### Exercise 2.1: High-Volume Salespeople
**Problem**: Find salespeople who have made more than 2 sales.

**Requirements**: Show salesperson name and number of sales

**Hint**: Use HAVING with COUNT() > 2

---

### Exercise 2.2: Regions with High Total Sales
**Problem**: Find regions where total sales are greater than $1500.

**Requirements**: Show region and total sales amount

**Hint**: Use HAVING with SUM() > 1500

---

### Exercise 2.3: Popular Products
**Problem**: Find products that have been sold more than once with average price above $100.

**Requirements**: Show product name, count of sales, and average price

**Hint**: Combine multiple conditions in HAVING clause

---

## 🎯 Exercise Set 3: Advanced Grouping

### Exercise 3.1: Multi-Level Grouping
**Problem**: Group sales by region and product, showing totals for each combination.

**Expected Output**: Region, product, and total sales for each combination

**Hint**: Use multiple columns in GROUP BY

---

### Exercise 3.2: Quarterly Analysis
**Problem**: Create a report showing sales by quarter and region.

**Requirements**: 
- Show quarter, region, and total sales
- Order by quarter, then region

**Hint**: GROUP BY multiple columns with ORDER BY

---

### Exercise 3.3: Top Performers
**Problem**: Find the top-selling product in each region.

**Requirements**: Show region, product, and total sales for the highest-selling product per region

**Challenge**: This requires advanced techniques (window functions or subqueries)

---

## 🎯 Exercise Set 4: Complex Scenarios

### Exercise 4.1: Sales Performance Dashboard
**Problem**: Create a comprehensive sales report showing:
- Total sales by salesperson
- Average sale amount per transaction
- Number of different products sold
- Best-selling product for each person

**Requirements**: Combine multiple aggregate functions

---

### Exercise 4.2: Regional Comparison
**Problem**: Compare regional performance by showing:
- Total sales per region
- Average sale per transaction per region
- Number of unique salespeople per region
- Best month for each region

**Requirements**: Multiple grouping levels and calculations

---

### Exercise 4.3: Time-Based Analysis
**Problem**: Analyze sales trends by creating:
- Monthly sales totals
- Quarter-over-quarter growth
- Seasonal patterns by product

**Challenge**: May require date functions and advanced grouping

---

## ✅ Self-Assessment Checklist

After completing these exercises, you should be comfortable with:

- [ ] Basic GROUP BY with single columns
- [ ] Using aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- [ ] Filtering groups with HAVING clause
- [ ] Combining WHERE and HAVING appropriately
- [ ] Grouping by multiple columns
- [ ] Ordering grouped results
- [ ] Handling NULL values in groups
- [ ] Complex business reporting scenarios

## 🎯 Difficulty Levels

- **Beginner** (Exercises 1.1-1.3): Basic GROUP BY and aggregates
- **Intermediate** (Exercises 2.1-3.2): HAVING clause and multi-column grouping
- **Advanced** (Exercises 3.3-4.3): Complex business scenarios

## 🔍 Common Patterns to Master

1. **Sales Reporting**: Revenue by time periods, regions, products
2. **Performance Analysis**: Top performers, trends, comparisons
3. **Data Summarization**: Counts, totals, averages by categories
4. **Business Intelligence**: KPIs, dashboards, executive summaries

## 🚀 Next Steps

After mastering these exercises:
1. Check your solutions against [solutions.sql](./solutions.sql)
2. Try creating your own practice datasets
3. Move on to [7-Joins](../../7-Joins/README.md) for combining tables
4. Apply these skills to real business scenarios

---
[← Back to Grouping & Aggregation](../README.md) | [View Solutions →](./solutions.sql)