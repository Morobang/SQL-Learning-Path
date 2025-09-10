-- Advanced SQL Grouping Techniques
-- File: Advanced_Grouping.sql
-- Database: AdventureWorks
-- Author: [Your Name]
-- Date: [Current Date]

/*
OBJECTIVE:
This lesson covers advanced SQL grouping techniques that go beyond basic GROUP BY.
We'll explore ROLLUP, CUBE, GROUPING SETS, window functions with grouping, and more.
*/

USE AdventureWorks;
GO

-- =============================================================================
-- SECTION 1: SETUP AND BASIC CONCEPTS REVIEW
-- =============================================================================

PRINT '=== SECTION 1: BASIC CONCEPTS REVIEW ===';

/*
WHY ADVANCED GROUPING?
Basic GROUP BY gives us single-level aggregations, but real-world business questions often require:
- Multiple levels of summarization (hierarchies)
- Multiple perspectives on the same data
- Comparative analysis within groups
- Complex filtering of aggregated data
*/

-- Let's first review basic grouping
SELECT 
    TerritoryID,
    COUNT(*) AS OrderCount,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
ORDER BY TotalSales DESC;

/*
KEY CONCEPT: A basic GROUP BY collapses multiple rows into single summary rows.
Each unique combination of grouped columns produces one summary row.
*/

-- =============================================================================
-- SECTION 2: ROLLUP - HIERARCHICAL SUMMARIZATION
-- =============================================================================

PRINT '=== SECTION 2: ROLLUP - HIERARCHICAL SUMMARIZATION ===';

/*
WHAT IS ROLLUP?
ROLLUP creates hierarchical subtotals from most detailed to grand total.
It's perfect for drill-down reports: Year → Quarter → Month → Total

USE CASES:
- Financial reporting (monthly → quarterly → yearly totals)
- Inventory hierarchy (category → subcategory → product totals)
- Organizational reporting (department → team → individual)
*/

-- Example 2.1: Simple ROLLUP with date hierarchy
SELECT 
    YEAR(OrderDate) AS OrderYear,
    DATEPART(QUARTER, OrderDate) AS OrderQuarter,
    MONTH(OrderDate) AS OrderMonth,
    COUNT(*) AS OrderCount,
    SUM(TotalDue) AS TotalSales,
    -- GROUPING function helps identify summary rows
    GROUPING(YEAR(OrderDate)) AS IsYearTotal,
    GROUPING(DATEPART(QUARTER, OrderDate)) AS IsQuarterTotal,
    GROUPING(MONTH(OrderDate)) AS IsMonthTotal
FROM Sales.SalesOrderHeader
GROUP BY ROLLUP (
    YEAR(OrderDate),
    DATEPART(QUARTER, OrderDate),
    MONTH(OrderDate)
)
ORDER BY OrderYear, OrderQuarter, OrderMonth;

/*
HOW TO READ ROLLUP RESULTS:
- NULL in OrderMonth + IsMonthTotal=1 → Quarter subtotal
- NULL in OrderQuarter + IsQuarterTotal=1 → Year subtotal
- NULL in all columns → Grand total

BUSINESS QUESTION ANSWERED:
"What are our sales by year, with quarterly and monthly breakdowns, plus overall totals?"
*/

-- Example 2.2: ROLLUP with product hierarchy
SELECT 
    pc.Name AS Category,
    psc.Name AS Subcategory,
    p.Name AS Product,
    COUNT(*) AS TimesOrdered,
    SUM(sod.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY ROLLUP (pc.Name, psc.Name, p.Name)
HAVING COUNT(*) > 10 -- Filter out rarely ordered products
ORDER BY pc.Name, psc.Name, p.Name;

-- =============================================================================
-- SECTION 3: CUBE - MULTI-DIMENSIONAL ANALYSIS
-- =============================================================================

PRINT '=== SECTION 3: CUBE - MULTI-DIMENSIONAL ANALYSIS ===';

/*
WHAT IS CUBE?
CUBE generates all possible combinations of the grouped columns.
It's like a data cube where you can slice along any dimension.

USE CASES:
- Cross-tabular reports
- Multi-dimensional analysis
- Exploring all possible perspectives on data
- Business intelligence dashboards
*/

-- Example 3.1: CUBE with territory, year, and online flag
SELECT 
    COALESCE(CAST(st.Name AS VARCHAR(50)), 'All Territories') AS Territory,
    COALESCE(CAST(YEAR(soh.OrderDate) AS VARCHAR(4)), 'All Years') AS OrderYear,
    COALESCE(CASE WHEN soh.OnlineOrderFlag = 1 THEN 'Online' ELSE 'Store' END, 'All Channels') AS SalesChannel,
    COUNT(*) AS OrderCount,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
GROUP BY CUBE (st.Name, YEAR(soh.OrderDate), soh.OnlineOrderFlag)
ORDER BY st.Name, OrderYear, SalesChannel;

/*
CUBE VS ROLLUP:
- ROLLUP: Hierarchical (A → B → C → Total)
- CUBE: All combinations (A, B, C, A+B, A+C, B+C, A+B+C, Total)

BUSINESS QUESTIONS ANSWERED:
1. How do online vs store sales compare across territories?
2. What's the yearly trend for each sales channel?
3. Which territory-year-channel combinations are most profitable?
*/

-- =============================================================================
-- SECTION 4: GROUPING SETS - FLEXIBLE SUMMARIZATION
-- =============================================================================

PRINT '=== SECTION 4: GROUPING SETS - FLEXIBLE SUMMARIZATION ===';

/*
WHAT ARE GROUPING SETS?
GROUPING SETS let you specify exactly which groupings you want.
It's the most flexible option when you don't need all combinations.

USE CASES:
- Custom reports with specific summary levels
- Combining different grouping criteria in one query
- Performance optimization (only compute needed groupings)
*/

-- Example 4.1: Custom grouping sets
SELECT 
    COALESCE(pc.Name, 'All Categories') AS Category,
    COALESCE(CAST(YEAR(soh.OrderDate) AS VARCHAR(4)), 'All Years') AS OrderYear,
    COALESCE(CAST(st.Name AS VARCHAR(50)), 'All Territories') AS Territory,
    COUNT(*) AS OrderCount,
    SUM(soh.TotalDue) AS TotalSales,
    -- Using GROUPING_ID for compact grouping identification
    GROUPING_ID(pc.Name, YEAR(soh.OrderDate), st.Name) AS GroupingCode
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
GROUP BY GROUPING SETS (
    (pc.Name, YEAR(soh.OrderDate), st.Name),  -- Most detailed level
    (pc.Name, YEAR(soh.OrderDate)),           -- Category by Year
    (pc.Name, st.Name),                       -- Category by Territory
    (YEAR(soh.OrderDate), st.Name),           -- Year by Territory
    (pc.Name),                                -- Category total
    (YEAR(soh.OrderDate)),                    -- Year total
    (st.Name),                                -- Territory total
    ()                                        -- Grand total
)
ORDER BY pc.Name, OrderYear, Territory;

/*
GROUPING SETS ADVANTAGES:
1. Flexibility: Choose exactly which groupings you need
2. Performance: Only compute specified combinations
3. Readability: Explicit about intended summarization

INTERPRETING GROUPING_ID:
The GroupingCode is a bitmask that shows which columns are grouped.
0 = column included in grouping, 1 = column aggregated (summary level)
*/

-- =============================================================================
-- SECTION 5: WINDOW FUNCTIONS WITH GROUPING
-- =============================================================================

PRINT '=== SECTION 5: WINDOW FUNCTIONS WITH GROUPING ===';

/*
COMBINING GROUP BY AND WINDOW FUNCTIONS:
Window functions operate on groups but don't collapse rows like GROUP BY.
This lets you see both detail and summary information together.

USE CASES:
- Ranking items within categories
- Calculating percentages of totals
- Moving averages and running totals within groups
- Comparative analysis (vs group average, etc.)
*/

-- Example 5.1: Ranking products within categories
SELECT 
    pc.Name AS Category,
    p.Name AS Product,
    SUM(sod.LineTotal) AS TotalSales,
    -- Ranking within each category
    RANK() OVER (PARTITION BY pc.Name ORDER BY SUM(sod.LineTotal) DESC) AS SalesRank,
    -- Percentage of category total
    SUM(sod.LineTotal) * 100.0 / SUM(SUM(sod.LineTotal)) OVER (PARTITION BY pc.Name) AS PercentOfCategory,
    -- Difference from category average
    SUM(sod.LineTotal) - AVG(SUM(sod.LineTotal)) OVER (PARTITION BY pc.Name) AS AboveBelowAverage
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name, p.Name
HAVING SUM(sod.LineTotal) > 1000
ORDER BY pc.Name, SalesRank;

/*
KEY DIFFERENCE: GROUP BY vs WINDOW FUNCTIONS
- GROUP BY: Collapses multiple rows → fewer rows, summary data only
- WINDOW: Keeps all rows → same row count, adds summary columns

BUSINESS INSIGHTS:
1. Identify top-performing products in each category
2. Find products that significantly over/under-perform category averages
3. Analyze sales concentration within categories
*/

-- =============================================================================
-- SECTION 6: ADVANCED HAVING CLAUSE TECHNIQUES
-- =============================================================================

PRINT '=== SECTION 6: ADVANCED HAVING CLAUSE TECHNIQUES ===';

/*
BEYOND BASIC HAVING:
The HAVING clause can include complex conditions involving:
- Multiple aggregate functions
- Subqueries
- Mathematical operations on aggregates
- Conditional logic
*/

-- Example 6.1: Complex HAVING conditions
SELECT 
    pc.Name AS Category,
    YEAR(soh.OrderDate) AS OrderYear,
    COUNT(DISTINCT soh.CustomerID) AS UniqueCustomers,
    SUM(soh.TotalDue) AS TotalSales,
    AVG(soh.TotalDue) AS AverageOrderValue,
    -- Customer value calculation
    SUM(soh.TotalDue) / NULLIF(COUNT(DISTINCT soh.CustomerID), 0) AS RevenuePerCustomer
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name, YEAR(soh.OrderDate)
HAVING 
    -- Multiple conditions with AND/OR
    COUNT(DISTINCT soh.CustomerID) > 50 AND
    SUM(soh.TotalDue) > 100000 AND
    AVG(soh.TotalDue) BETWEEN 500 AND 5000 AND
    -- Using calculated value in HAVING
    (SUM(soh.TotalDue) / NULLIF(COUNT(DISTINCT soh.CustomerID), 0)) > 1000
ORDER BY RevenuePerCustomer DESC;

/*
HAVING CLAUSE BEST PRACTICES:
1. Use for filtering aggregated data (WHERE filters before aggregation)
2. Can reference aggregate functions and aliases from SELECT
3. Use NULLIF to handle division by zero
4. Complex conditions should be well-documented
*/

-- =============================================================================
-- SECTION 7: REAL-WORLD BUSINESS SCENARIOS
-- =============================================================================

PRINT '=== SECTION 7: REAL-WORLD BUSINESS SCENARIOS ===';

-- Scenario 7.1: Executive Sales Dashboard
SELECT 
    COALESCE(CAST(YEAR(OrderDate) AS VARCHAR(4)), 'All Years') AS Year,
    COALESCE(CAST(DATEPART(QUARTER, OrderDate) AS VARCHAR(1)), 'All Quarters') AS Quarter,
    COALESCE(st.Name, 'All Territories') AS Territory,
    COUNT(*) AS OrderCount,
    SUM(TotalDue) AS TotalRevenue,
    AVG(TotalDue) AS AverageOrderValue,
    COUNT(DISTINCT CustomerID) AS UniqueCustomers
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
GROUP BY GROUPING SETS (
    (YEAR(OrderDate), DATEPART(QUARTER, OrderDate), st.Name),
    (YEAR(OrderDate), DATEPART(QUARTER, OrderDate)),
    (YEAR(OrderDate), st.Name),
    (YEAR(OrderDate)),
    (st.Name),
    ()
)
ORDER BY YEAR(OrderDate), DATEPART(QUARTER, OrderDate), st.Name;

-- Scenario 7.2: Product Performance Analysis
SELECT 
    pc.Name AS Category,
    p.Name AS Product,
    COUNT(*) AS OrderCount,
    SUM(sod.LineTotal) AS TotalRevenue,
    SUM(sod.OrderQty) AS TotalQuantity,
    -- Advanced metrics
    SUM(sod.LineTotal) / NULLIF(SUM(sod.OrderQty), 0) AS AveragePrice,
    RANK() OVER (PARTITION BY pc.Name ORDER BY SUM(sod.LineTotal) DESC) AS RevenueRank,
    PERCENT_RANK() OVER (PARTITION BY pc.Name ORDER BY SUM(sod.LineTotal)) AS RevenuePercentile
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name, p.Name
HAVING SUM(sod.LineTotal) > 5000
ORDER BY pc.Name, RevenueRank;

-- =============================================================================
-- SECTION 8: PERFORMANCE CONSIDERATIONS
-- =============================================================================

PRINT '=== SECTION 8: PERFORMANCE CONSIDERATIONS ===';

/*
PERFORMANCE TIPS FOR ADVANCED GROUPING:

1. INDEXING: Ensure columns used in GROUP BY and JOINs are indexed
2. FILTER EARLY: Use WHERE to reduce data before grouping
3. BE SELECTIVE: Use GROUPING SETS instead of CUBE when possible
4. AGGREGATE SELECTIVELY: Only include needed columns in groupings
5. TEST SCALE: Large datasets may require different approaches

WARNING: CUBE can generate exponential numbers of rows!
For n grouping columns, CUBE produces 2^n combinations.
*/

-- Example: Show the explosive growth of CUBE
DECLARE @ColumnCount INT = 4;
DECLARE @Combinations BIGINT = POWER(2, @ColumnCount);
PRINT 'With ' + CAST(@ColumnCount AS VARCHAR) + ' columns, CUBE generates ' + 
      CAST(@Combinations AS VARCHAR) + ' different groupings!';

-- =============================================================================
-- SECTION 9: EXERCISES FOR PRACTICE
-- =============================================================================

PRINT '=== SECTION 9: EXERCISES FOR PRACTICE ===';

/*
EXERCISE 1: Create a sales report that shows:
- Monthly sales for each territory
- Quarterly subtotals for each territory  
- Yearly totals for each territory
- Grand total

EXERCISE 2: Analyze customer buying patterns:
- For each product category, show number of customers
- Rank customers by their total spending within each category
- Show what percentage each customer contributes to category total

EXERCISE 3: Create an inventory analysis:
- Stock levels by product and subcategory
- Subcategory subtotals
- Category totals
- Identify products with stock below average for their subcategory
*/

-- =============================================================================
-- SECTION 10: SUMMARY AND BEST PRACTICES
-- =============================================================================

PRINT '=== SECTION 10: SUMMARY AND BEST PRACTICES ===';

/*
CHOOSING THE RIGHT TECHNIQUE:

1. BASIC GROUP BY: Single-level summarization
2. ROLLUP: Hierarchical reporting (drill-down)
3. CUBE: Multi-dimensional analysis (all perspectives)
4. GROUPING SETS: Custom, specific summarization needs
5. WINDOW FUNCTIONS: Comparative analysis within groups

BEST PRACTICES:
- Always document what each grouping level represents
- Use COALESCE/ISNULL to make summary rows readable
- Test with small data first when using CUBE
- Consider performance implications for large datasets
- Use GROUPING() or GROUPING_ID() to identify summary rows
*/

PRINT '=== END OF ADVANCED GROUPING LESSON ===';