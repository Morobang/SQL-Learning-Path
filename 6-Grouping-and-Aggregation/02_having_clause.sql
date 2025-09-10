-- ============================================================
-- HAVING_CLAUSE.SQL
-- Advanced HAVING Clause Techniques and Patterns
-- Database: AdventureWorks
-- ============================================================

/*
OBJECTIVE:
The HAVING clause is used to filter groups created by the GROUP BY clause.
Unlike WHERE which filters rows BEFORE aggregation, HAVING filters AFTER aggregation.

KEY DIFFERENCES:
- WHERE: Filters individual rows before grouping
- HAVING: Filters groups after aggregation
- Execution order: WHERE → GROUP BY → HAVING → SELECT → ORDER BY
*/

USE AdventureWorks;
GO

-- =============================================================================
-- SECTION 1: BASIC HAVING CLAUSE USAGE
-- =============================================================================

PRINT '=== SECTION 1: BASIC HAVING CLAUSE USAGE ===';

-- Example 1.1: Simple HAVING with single condition
SELECT 
    TerritoryID,
    COUNT(*) AS OrderCount,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
HAVING COUNT(*) > 1000  -- Only territories with more than 1000 orders
ORDER BY TotalSales DESC;

/*
WHY USE HAVING HERE?
We can't use WHERE COUNT(*) > 1000 because COUNT() is an aggregate function
that's calculated AFTER rows are grouped. HAVING works on the grouped results.
*/

-- Example 1.2: Multiple conditions in HAVING
SELECT 
    ProductID,
    COUNT(*) AS TimesOrdered,
    SUM(OrderQty) AS TotalQuantity,
    SUM(LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING 
    COUNT(*) > 50 AND          -- Ordered more than 50 times
    SUM(OrderQty) > 1000 AND   -- Total quantity over 1000
    SUM(LineTotal) > 10000     -- Total revenue over $10,000
ORDER BY TotalRevenue DESC;

-- =============================================================================
-- SECTION 2: COMPARING WHERE vs HAVING
-- =============================================================================

PRINT '=== SECTION 2: WHERE vs HAVING - KEY DIFFERENCES ===';

-- Example 2.1: WHERE filters rows BEFORE aggregation
SELECT 
    TerritoryID,
    COUNT(*) AS OrderCount,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2013-01-01'  -- Filter individual orders from 2013 onwards
GROUP BY TerritoryID
ORDER BY TotalSales DESC;

-- Example 2.2: HAVING filters groups AFTER aggregation  
SELECT 
    TerritoryID,
    COUNT(*) AS OrderCount,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
HAVING SUM(TotalDue) > 10000000  -- Filter territories with sales over $10M
ORDER BY TotalSales DESC;

-- Example 2.3: COMBINING WHERE and HAVING (Most common pattern)
SELECT 
    TerritoryID,
    COUNT(*) AS OrderCount,
    SUM(TotalDue) AS TotalSales,
    AVG(TotalDue) AS AverageOrderValue
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2013-01-01'          -- First filter: only 2013+ orders
GROUP BY TerritoryID
HAVING AVG(TotalDue) > 2000 AND          -- Second filter: average order > $2000
       COUNT(*) > 500                    -- And more than 500 orders
ORDER BY AverageOrderValue DESC;

/*
EXECUTION ORDER:
1. FROM - Get the table data
2. WHERE - Filter individual rows (OrderDate >= '2013-01-01')
3. GROUP BY - Group remaining rows by TerritoryID
4. HAVING - Filter groups (AVG(TotalDue) > 2000 AND COUNT(*) > 500)
5. SELECT - Calculate final aggregates and columns
6. ORDER BY - Sort the results
*/

-- =============================================================================
-- SECTION 3: COMPLEX HAVING CONDITIONS
-- =============================================================================

PRINT '=== SECTION 3: COMPLEX HAVING CONDITIONS ===';

-- Example 3.1: Mathematical operations in HAVING
SELECT 
    ProductID,
    COUNT(*) AS OrderCount,
    SUM(OrderQty) AS TotalQuantity,
    SUM(LineTotal) AS TotalRevenue,
    AVG(UnitPrice) AS AveragePrice
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING 
    SUM(LineTotal) / NULLIF(SUM(OrderQty), 0) > 500 AND  -- Revenue per unit > $500
    COUNT(*) BETWEEN 10 AND 100 AND                      -- Between 10-100 orders
    AVG(UnitPrice) > (SELECT AVG(UnitPrice) FROM Sales.SalesOrderDetail)  -- Above average price
ORDER BY TotalRevenue DESC;

/*
IMPORTANT: Use NULLIF to avoid division by zero errors
NULLIF(SUM(OrderQty), 0) returns NULL if sum is zero, preventing errors
*/

-- Example 3.2: HAVING with subqueries and correlated conditions
SELECT 
    pc.Name AS Category,
    COUNT(DISTINCT soh.CustomerID) AS UniqueCustomers,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
HAVING 
    -- Compare category performance to overall average
    SUM(soh.TotalDue) > (SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader) * 100 AND
    -- Ensure reasonable number of customers
    COUNT(DISTINCT soh.CustomerID) > (SELECT COUNT(*) * 0.01 FROM Sales.Customer)
ORDER BY TotalSales DESC;

-- =============================================================================
-- SECTION 4: HAVING WITH ADVANCED GROUPING
-- =============================================================================

PRINT '=== SECTION 4: HAVING WITH ROLLUP, CUBE, and GROUPING SETS ===';

-- Example 4.1: HAVING with ROLLUP
SELECT 
    YEAR(OrderDate) AS OrderYear,
    DATEPART(QUARTER, OrderDate) AS OrderQuarter,
    COUNT(*) AS OrderCount,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY ROLLUP (YEAR(OrderDate), DATEPART(QUARTER, OrderDate))
HAVING 
    -- Filter out summary rows with very low sales
    (GROUPING(YEAR(OrderDate)) = 0 AND GROUPING(DATEPART(QUARTER, OrderDate)) = 0 AND SUM(TotalDue) > 1000000) OR
    -- Keep quarter summaries
    (GROUPING(YEAR(OrderDate)) = 0 AND GROUPING(DATEPART(QUARTER, OrderDate)) = 1) OR
    -- Keep year summaries  
    (GROUPING(YEAR(OrderDate)) = 1 AND GROUPING(DATEPART(QUARTER, OrderDate)) = 1)
ORDER BY OrderYear, OrderQuarter;

-- Example 4.2: HAVING with GROUPING SETS
SELECT 
    TerritoryID,
    YEAR(OrderDate) AS OrderYear,
    OnlineOrderFlag,
    COUNT(*) AS OrderCount,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY GROUPING SETS (
    (TerritoryID, YEAR(OrderDate), OnlineOrderFlag),
    (TerritoryID, YEAR(OrderDate)),
    (TerritoryID),
    ()
)
HAVING 
    -- Different filters for different grouping levels
    (GROUPING_ID(TerritoryID, YEAR(OrderDate), OnlineOrderFlag) = 0 AND COUNT(*) > 100) OR
    (GROUPING_ID(TerritoryID, YEAR(OrderDate), OnlineOrderFlag) = 1 AND SUM(TotalDue) > 1000000) OR
    (GROUPING_ID(TerritoryID, YEAR(OrderDate), OnlineOrderFlag) = 3 AND SUM(TotalDue) > 5000000) OR
    (GROUPING_ID(TerritoryID, YEAR(OrderDate), OnlineOrderFlag) = 7)  -- Always include grand total
ORDER BY TerritoryID, OrderYear, OnlineOrderFlag;

-- =============================================================================
-- SECTION 5: PRACTICAL BUSINESS USE CASES
-- =============================================================================

PRINT '=== SECTION 5: PRACTICAL BUSINESS USE CASES ===';

-- Use Case 5.1: Identifying High-Value Customer Segments
SELECT 
    soh.CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    SUM(soh.TotalDue) AS LifetimeValue,
    MAX(soh.OrderDate) AS LastOrderDate
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY soh.CustomerID, p.FirstName, p.LastName
HAVING 
    SUM(soh.TotalDue) > 10000 AND          -- Spent over $10,000
    COUNT(DISTINCT soh.SalesOrderID) > 5 AND -- More than 5 orders
    DATEDIFF(MONTH, MAX(soh.OrderDate), GETDATE()) < 6  -- Ordered in last 6 months
ORDER BY LifetimeValue DESC;

-- Use Case 5.2: Product Performance Analysis
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    pc.Name AS Category,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    SUM(sod.OrderQty) AS TotalQuantity,
    SUM(sod.LineTotal) AS TotalRevenue,
    SUM(sod.LineTotal) / NULLIF(SUM(sod.OrderQty), 0) AS AverageSellingPrice
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE soh.OrderDate >= '2013-01-01'
GROUP BY p.ProductID, p.Name, pc.Name
HAVING 
    SUM(sod.LineTotal) > 5000 AND                          -- Significant revenue
    COUNT(DISTINCT soh.SalesOrderID) > 10 AND              -- Popular product
    SUM(sod.LineTotal) / NULLIF(SUM(sod.OrderQty), 0) > p.ListPrice * 0.8  -- Good selling price
ORDER BY TotalRevenue DESC;

-- Use Case 5.3: Sales Territory Performance Dashboard
SELECT 
    st.TerritoryID,
    st.Name AS TerritoryName,
    COUNT(DISTINCT soh.SalesOrderID) AS TotalOrders,
    COUNT(DISTINCT soh.CustomerID) AS UniqueCustomers,
    SUM(soh.TotalDue) AS TotalSales,
    AVG(soh.TotalDue) AS AverageOrderValue,
    SUM(soh.TotalDue) / NULLIF(COUNT(DISTINCT soh.CustomerID), 0) AS RevenuePerCustomer
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
WHERE soh.OrderDate >= '2013-01-01'
GROUP BY st.TerritoryID, st.Name
HAVING 
    SUM(soh.TotalDue) > 1000000 AND                      -- Territories with $1M+ sales
    COUNT(DISTINCT soh.CustomerID) > 100 AND             -- At least 100 customers
    AVG(soh.TotalDue) BETWEEN 1000 AND 10000 AND         -- Reasonable order size
    RevenuePerCustomer > 5000                            -- High customer value
ORDER BY RevenuePerCustomer DESC;

-- =============================================================================
-- SECTION 6: ADVANCED PATTERNS AND TECHNIQUES
-- =============================================================================

PRINT '=== SECTION 6: ADVANCED PATTERNS AND TECHNIQUES ===';

-- Pattern 6.1: Ratio and Percentage Conditions
SELECT 
    pc.Name AS Category,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    SUM(soh.TotalDue) AS TotalSales,
    SUM(CASE WHEN soh.OnlineOrderFlag = 1 THEN soh.TotalDue ELSE 0 END) AS OnlineSales,
    SUM(CASE WHEN soh.OnlineOrderFlag = 0 THEN soh.TotalDue ELSE 0 END) AS StoreSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
HAVING 
    -- Online sales represent more than 30% of total sales
    SUM(CASE WHEN soh.OnlineOrderFlag = 1 THEN soh.TotalDue ELSE 0 END) / NULLIF(SUM(soh.TotalDue), 0) > 0.3 AND
    -- Store sales are still significant (over $500K)
    SUM(CASE WHEN soh.OnlineOrderFlag = 0 THEN soh.TotalDue ELSE 0 END) > 500000
ORDER BY TotalSales DESC;

-- Pattern 6.2: Comparative Analysis with HAVING
SELECT 
    YEAR(soh.OrderDate) AS OrderYear,
    DATEPART(QUARTER, soh.OrderDate) AS OrderQuarter,
    COUNT(*) AS OrderCount,
    SUM(soh.TotalDue) AS QuarterlySales,
    LAG(SUM(soh.TotalDue)) OVER (ORDER BY YEAR(soh.OrderDate), DATEPART(QUARTER, soh.OrderDate)) AS PreviousQuarterSales
FROM Sales.SalesOrderHeader soh
GROUP BY YEAR(soh.OrderDate), DATEPART(QUARTER, soh.OrderDate)
HAVING 
    -- Growth analysis: current quarter better than previous
    SUM(soh.TotalDue) > COALESCE(LAG(SUM(soh.TotalDue)) OVER (ORDER BY YEAR(soh.OrderDate), DATEPART(QUARTER, soh.OrderDate)), 0) * 1.1 OR
    -- Or consistently high performance
    AVG(soh.TotalDue) > 2000
ORDER BY OrderYear, OrderQuarter;

-- =============================================================================
-- SECTION 7: COMMON PITFALLS AND BEST PRACTICES
-- =============================================================================

PRINT '=== SECTION 7: COMMON PITFALLS AND BEST PRACTICES ===';

-- Pitfall 7.1: Misplacing conditions that should be in WHERE
-- ❌ INCORRECT: Using HAVING for row-level filtering
SELECT TerritoryID, COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
HAVING OrderDate >= '2013-01-01';  -- This will cause an error!

-- ✅ CORRECT: Use WHERE for row-level filtering
SELECT TerritoryID, COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2013-01-01'    -- Filter rows first
GROUP BY TerritoryID;

-- Pitfall 7.2: Division by zero in HAVING
-- ❌ RISKY: Potential division by zero
SELECT ProductID, SUM(OrderQty) AS TotalQty, SUM(LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(LineTotal) / SUM(OrderQty) > 100;  -- Could divide by zero

-- ✅ SAFE: Use NULLIF to prevent errors
SELECT ProductID, SUM(OrderQty) AS TotalQty, SUM(LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(LineTotal) / NULLIF(SUM(OrderQty), 0) > 100;  -- Safe from division by zero

-- Best Practice 7.3: Use aliases carefully in HAVING
-- ❌ CONFUSING: Mixing column names and aliases
SELECT TerritoryID, COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
HAVING COUNT(*) > 100 AND TerritoryID IN (1, 2, 3);  -- Mixing styles

-- ✅ CLEAR: Consistent approach
SELECT TerritoryID, COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
HAVING COUNT(*) > 100 AND TerritoryID IN (1, 2, 3);  -- Actually fine, but be consistent

-- =============================================================================
-- SECTION 8: PERFORMANCE CONSIDERATIONS
-- =============================================================================

PRINT '=== SECTION 8: PERFORMANCE CONSIDERATIONS ===';

/*
PERFORMANCE TIPS FOR HAVING CLAUSE:

1. FILTER EARLY: Use WHERE to reduce rows before grouping
2. AVOID COMPLEX CALCULATIONS: Move complex math to SELECT or CTEs
3. INDEX STRATEGY: Ensure grouped columns are indexed
4. TEST DIFFERENT APPROACHES: Compare execution plans
*/

-- Example 8.1: Efficient HAVING with pre-filtering
WITH FilteredOrders AS (
    SELECT TerritoryID, TotalDue
    FROM Sales.SalesOrderHeader
    WHERE OrderDate >= '2013-01-01'  -- Filter early in CTE
)
SELECT 
    TerritoryID,
    COUNT(*) AS OrderCount,
    SUM(TotalDue) AS TotalSales
FROM FilteredOrders
GROUP BY TerritoryID
HAVING SUM(TotalDue) > 1000000      -- Then apply group filtering
ORDER BY TotalSales DESC;

-- =============================================================================
-- SECTION 9: EXERCISES FOR PRACTICE
-- =============================================================================

PRINT '=== SECTION 9: EXERCISES FOR PRACTICE ===';

/*
EXERCISE 1: Find product categories where:
- Average order value is above $1500
- More than 50 unique customers have purchased
- Total revenue exceeds $1,000,000

EXERCISE 2: Identify sales territories that:
- Have seen growth (current year sales > previous year sales)
- Average order value increased by more than 10%
- Have at least 500 orders in the current year

EXERCISE 3: Find products that:
- Are priced above the category average
- Have been ordered by more than 25 different customers
- Have a sell-through rate (units sold vs units available) > 50%
*/

-- =============================================================================
-- SECTION 10: SUMMARY AND KEY TAKEAWAYS
-- =============================================================================

PRINT '=== SECTION 10: SUMMARY AND KEY TAKEAWAYS ===';

/*
KEY POINTS:

1. HAVING filters groups, WHERE filters rows
2. Execution order: WHERE → GROUP BY → HAVING → SELECT → ORDER BY
3. Use NULLIF to avoid division by zero in HAVING conditions
4. Combine WHERE and HAVING for optimal performance
5. HAVING can reference aggregate functions, column values, and subqueries
6. Use GROUPING() functions when working with ROLLUP/CUBE/GROUPING SETS

WHEN TO USE HAVING:
- Filtering based on aggregate results (COUNT, SUM, AVG, etc.)
- Setting thresholds for group-level metrics
- Comparative analysis between groups
- Quality control for aggregated data

WHEN TO USE WHERE:
- Filtering individual rows before aggregation
- Removing irrelevant data early for performance
- Row-level security or data partitioning
*/

PRINT '=== END OF HAVING CLAUSE LESSON ===';