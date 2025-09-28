-- ============================================================
-- 02_CORRELATED_SUBQUERIES.SQL
-- Complete Beginner's Guide to Correlated Subqueries
-- Database: AdventureWorks
-- ============================================================

/*
WHAT ARE CORRELATED SUBQUERIES?
A correlated subquery is a subquery that depends on the outer query for its values.
It's like a loop: for each row in the outer query, the inner query runs once.

ANALOGY:
Imagine you're a teacher with a class of students. If I ask:
"Which students scored higher than the average of THEIR OWN class?"
You would need to:
1. Look at one student's score
2. Calculate the average for THEIR specific class
3. Compare their score to that average
4. Repeat for each student

This is exactly what a correlated subquery does!
*/

USE AdventureWorks;
GO

-- =============================================================================
-- SECTION 1: BASIC CORRELATED SUBQUERY CONCEPTS
-- =============================================================================

PRINT '=== SECTION 1: BASIC CORRELATED SUBQUERY CONCEPTS ===';

-- Example 1.1: Products more expensive than their category average
SELECT 
    p1.ProductID,
    p1.Name,
    p1.ListPrice,
    ps.Name AS CategoryName,
    (SELECT AVG(p2.ListPrice) 
     FROM Production.Product p2 
     WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID
     AND p2.ListPrice > 0) AS CategoryAvgPrice
FROM Production.Product p1
JOIN Production.ProductSubcategory ps ON p1.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE p1.ListPrice > 0
AND p1.ListPrice > (
    SELECT AVG(p2.ListPrice)
    FROM Production.Product p2
    WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID  -- This is the correlation!
    AND p2.ListPrice > 0
)
ORDER BY ps.Name, p1.ListPrice DESC;

/*
HOW THIS WORKS:
1. Outer query looks at first product (e.g., Road Bike, $1000, Category 1)
2. Inner query runs: "What's the average price for Category 1 products?" → $833
3. Comparison: Is $1000 > $833? ✓ YES → Include this product
4. Move to next product and repeat
*/

-- =============================================================================
-- SECTION 2: CORRELATED VS NON-CORRELATED SUBQUERIES
-- =============================================================================

PRINT '=== SECTION 2: CORRELATED VS NON-CORRELATED SUBQUERIES ===';

-- 2.1 NON-CORRELATED SUBQUERY (runs once)
-- "Products more expensive than overall average"
SELECT 
    ProductID,
    Name,
    ListPrice
FROM Production.Product
WHERE ListPrice > (
    SELECT AVG(ListPrice) 
    FROM Production.Product 
    WHERE ListPrice > 0
)
AND ListPrice > 0
ORDER BY ListPrice DESC;

-- 2.2 CORRELATED SUBQUERY (runs for each row)  
-- "Products more expensive than their CATEGORY average"
SELECT 
    p1.ProductID,
    p1.Name,
    p1.ListPrice,
    ps.Name AS CategoryName
FROM Production.Product p1
JOIN Production.ProductSubcategory ps ON p1.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE p1.ListPrice > 0
AND p1.ListPrice > (
    SELECT AVG(p2.ListPrice)
    FROM Production.Product p2
    WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID  -- Correlation!
    AND p2.ListPrice > 0
)
ORDER BY ps.Name, p1.ListPrice DESC;

-- =============================================================================
-- SECTION 3: CORRELATED SUBQUERIES WITH DIFFERENT CLAUSES
-- =============================================================================

PRINT '=== SECTION 3: CORRELATED SUBQUERIES WITH DIFFERENT CLAUSES ===';

-- 3.1 IN SELECT CLAUSE
-- Show each product's price difference from category average
SELECT 
    p1.ProductID,
    p1.Name,
    p1.ListPrice,
    ps.Name AS CategoryName,
    p1.ListPrice - (
        SELECT AVG(p2.ListPrice)
        FROM Production.Product p2
        WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID
        AND p2.ListPrice > 0
    ) AS DifferenceFromCategoryAvg
FROM Production.Product p1
JOIN Production.ProductSubcategory ps ON p1.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE p1.ListPrice > 0
ORDER BY DifferenceFromCategoryAvg DESC;

-- 3.2 IN WHERE CLAUSE (most common)
-- Find the most expensive product in each category
SELECT 
    p1.ProductID,
    p1.Name,
    p1.ListPrice,
    ps.Name AS CategoryName
FROM Production.Product p1
JOIN Production.ProductSubcategory ps ON p1.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE p1.ListPrice > 0
AND p1.ListPrice = (
    SELECT MAX(p2.ListPrice)
    FROM Production.Product p2
    WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID  -- Correlation!
    AND p2.ListPrice > 0
)
ORDER BY p1.ListPrice DESC;

-- 3.3 WITH EXISTS/NOT EXISTS
-- Find categories that have products
SELECT 
    ps.ProductSubcategoryID,
    ps.Name
FROM Production.ProductSubcategory ps
WHERE EXISTS (
    SELECT 1
    FROM Production.Product p
    WHERE p.ProductSubcategoryID = ps.ProductSubcategoryID  -- Correlation!
);

-- Find categories with NO products
SELECT 
    ps.ProductSubcategoryID,
    ps.Name
FROM Production.ProductSubcategory ps
WHERE NOT EXISTS (
    SELECT 1
    FROM Production.Product p
    WHERE p.ProductSubcategoryID = ps.ProductSubcategoryID  -- Correlation!
);

-- =============================================================================
-- SECTION 4: PRACTICAL BUSINESS EXAMPLES
-- =============================================================================

PRINT '=== SECTION 4: PRACTICAL BUSINESS EXAMPLES ===';

-- 4.1 EMPLOYEE SALARY ANALYSIS
-- Employees who earn more than their department average
SELECT 
    e.BusinessEntityID,
    p.FirstName + ' ' + p.LastName AS EmployeeName,
    eph.Rate,
    d.Name AS DepartmentName,
    (SELECT AVG(eph2.Rate)
     FROM HumanResources.EmployeePayHistory eph2
     JOIN HumanResources.Employee e2 ON eph2.BusinessEntityID = e2.BusinessEntityID
     WHERE e2.DepartmentID = e.DepartmentID) AS DeptAvgSalary
FROM HumanResources.Employee e
JOIN HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
JOIN HumanResources.Department d ON e.DepartmentID = d.DepartmentID
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE eph.Rate > (
    SELECT AVG(eph2.Rate)
    FROM HumanResources.EmployeePayHistory eph2
    JOIN HumanResources.Employee e2 ON eph2.BusinessEntityID = e2.BusinessEntityID
    WHERE e2.DepartmentID = e.DepartmentID  -- Correlation!
)
ORDER BY d.Name, eph.Rate DESC;

-- 4.2 SALES ORDER ANALYSIS
-- Customers whose average order value is above their overall average
SELECT 
    soh.CustomerID,
    c.AccountNumber,
    COUNT(soh.SalesOrderID) AS OrderCount,
    AVG(soh.TotalDue) AS AvgOrderValue,
    (SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader) AS OverallAvgOrderValue
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
GROUP BY soh.CustomerID, c.AccountNumber
HAVING AVG(soh.TotalDue) > (
    SELECT AVG(TotalDue) 
    FROM Sales.SalesOrderHeader soh2
    WHERE soh2.CustomerID = soh.CustomerID  -- Correlation!
)
ORDER BY AvgOrderValue DESC;

-- 4.3 PRODUCT INVENTORY ANALYSIS
-- Products with below-average inventory for their category
SELECT 
    p.ProductID,
    p.Name,
    ps.Name AS CategoryName,
    (SELECT SUM(pi.Quantity) 
     FROM Production.ProductInventory pi 
     WHERE pi.ProductID = p.ProductID) AS TotalInventory,
    (SELECT AVG(pi2.Quantity)
     FROM Production.ProductInventory pi2
     JOIN Production.Product p2 ON pi2.ProductID = p2.ProductID
     WHERE p2.ProductSubcategoryID = p.ProductSubcategoryID) AS CategoryAvgInventory
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE (
    SELECT SUM(pi.Quantity)
    FROM Production.ProductInventory pi
    WHERE pi.ProductID = p.ProductID
) < (
    SELECT AVG(pi2.Quantity)
    FROM Production.ProductInventory pi2
    JOIN Production.Product p2 ON pi2.ProductID = p2.ProductID
    WHERE p2.ProductSubcategoryID = p.ProductSubcategoryID  -- Correlation!
)
ORDER BY ps.Name, p.Name;

-- =============================================================================
-- SECTION 5: PERFORMANCE CONSIDERATIONS
-- =============================================================================

PRINT '=== SECTION 5: PERFORMANCE CONSIDERATIONS ===';

/*
WARNING: Correlated subqueries can be SLOW because they run multiple times!

For 1,000 products:
- Regular subquery: Runs 1 time
- Correlated subquery: Runs 1,000 times (once per product)

PERFORMANCE TIPS:
1. Use on smaller datasets
2. Ensure indexed columns are used in correlations
3. Consider alternative approaches (JOINs, window functions)
4. Test with EXPLAIN or execution plans
*/

-- 5.1 SLOWER: Correlated subquery approach
SELECT 
    p1.ProductID,
    p1.Name,
    p1.ListPrice
FROM Production.Product p1
WHERE p1.ListPrice > (
    SELECT AVG(p2.ListPrice)
    FROM Production.Product p2
    WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID
    AND p2.ListPrice > 0
);

-- 5.2 FASTER: JOIN approach (often better performance)
WITH CategoryAverages AS (
    SELECT 
        ProductSubcategoryID,
        AVG(ListPrice) AS AvgPrice
    FROM Production.Product
    WHERE ListPrice > 0
    GROUP BY ProductSubcategoryID
)
SELECT 
    p.ProductID,
    p.Name,
    p.ListPrice,
    ca.AvgPrice
FROM Production.Product p
JOIN CategoryAverages ca ON p.ProductSubcategoryID = ca.ProductSubcategoryID
WHERE p.ListPrice > ca.AvgPrice
ORDER BY p.ProductSubcategoryID, p.ListPrice DESC;

-- =============================================================================
-- SECTION 6: COMMON MISTAKES AND SOLUTIONS
-- =============================================================================

PRINT '=== SECTION 6: COMMON MISTAKES AND SOLUTIONS ===';

-- 6.1 ERROR: Forgetting the correlation
/*
-- WRONG: No connection between inner and outer queries
SELECT ProductID, Name
FROM Production.Product p1
WHERE ListPrice > (
    SELECT AVG(ListPrice)
    FROM Production.Product p2
    -- Missing: WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID
);
*/

-- 6.2 ERROR: Returning multiple values
/*
-- WRONG: = expects single value, but subquery might return multiple
SELECT ProductID, Name
FROM Production.Product p1
WHERE ListPrice = (
    SELECT ListPrice
    FROM Production.Product p2
    WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID
);
*/

-- RIGHT: Use aggregate functions for single value
SELECT ProductID, Name
FROM Production.Product p1
WHERE ListPrice = (
    SELECT MAX(ListPrice)
    FROM Production.Product p2
    WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID
);

-- 6.3 ERROR: Handling NULL values
-- Use COALESCE or ISNULL to handle potential NULLs
SELECT 
    p1.ProductID,
    p1.Name,
    p1.ListPrice,
    COALESCE((
        SELECT AVG(p2.ListPrice)
        FROM Production.Product p2
        WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID
        AND p2.ListPrice > 0
    ), 0) AS CategoryAvgPrice
FROM Production.Product p1
WHERE p1.ListPrice > 0;

-- =============================================================================
-- SECTION 7: ADVANCED PATTERNS
-- =============================================================================

PRINT '=== SECTION 7: ADVANCED PATTERNS ===';

-- 7.1 MULTIPLE CORRELATIONS
-- Products that are the most expensive in their category AND have inventory
SELECT 
    p1.ProductID,
    p1.Name,
    p1.ListPrice,
    ps.Name AS CategoryName
FROM Production.Product p1
JOIN Production.ProductSubcategory ps ON p1.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE p1.ListPrice > 0
AND p1.ListPrice = (
    SELECT MAX(p2.ListPrice)
    FROM Production.Product p2
    WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID
    AND p2.ListPrice > 0
)
AND EXISTS (
    SELECT 1
    FROM Production.ProductInventory pi
    WHERE pi.ProductID = p1.ProductID
    AND pi.Quantity > 0
);

-- 7.2 CORRELATED SUBQUERY WITH AGGREGATION
-- Customers whose most recent order was above their average order value
SELECT 
    soh.CustomerID,
    c.AccountNumber,
    soh.TotalDue AS MostRecentOrderValue,
    (SELECT AVG(soh2.TotalDue)
     FROM Sales.SalesOrderHeader soh2
     WHERE soh2.CustomerID = soh.CustomerID) AS CustomerAvgOrderValue
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
WHERE soh.OrderDate = (
    SELECT MAX(soh2.OrderDate)
    FROM Sales.SalesOrderHeader soh2
    WHERE soh2.CustomerID = soh.CustomerID
)
AND soh.TotalDue > (
    SELECT AVG(soh2.TotalDue)
    FROM Sales.SalesOrderHeader soh2
    WHERE soh2.CustomerID = soh.CustomerID
)
ORDER BY soh.TotalDue DESC;

-- =============================================================================
-- SECTION 8: EXERCISES FOR PRACTICE
-- =============================================================================

PRINT '=== SECTION 8: EXERCISES FOR PRACTICE ===';

/*
EXERCISE 1: Find employees who have changed departments more than once

EXERCISE 2: Find products that have never been ordered but have inventory

EXERCISE 3: Find the second most expensive product in each category

EXERCISE 4: Find customers who have ordered products from at least 3 different categories

EXERCISE 5: Find employees who earn more than their manager
*/

-- =============================================================================
-- SECTION 9: VISUAL LEARNING AID
-- =============================================================================

PRINT '=== SECTION 9: VISUAL LEARNING AID ===';

/*
HOW TO THINK ABOUT CORRELATED SUBQUERIES:

OUTER QUERY: For each product...
    ↓
INNER QUERY: What's the average price for THIS product's category?
    ↓
COMPARE: Is this product's price > that average?
    ↓
NEXT PRODUCT: Repeat for each product

It's like a loop that runs once for each row in the outer query!
*/

-- =============================================================================
-- SECTION 10: SUMMARY AND BEST PRACTICES
-- =============================================================================

PRINT '=== SECTION 10: SUMMARY AND BEST PRACTICES ===';

/*
WHEN TO USE CORRELATED SUBQUERIES:
1. Row-by-row comparisons
2. Finding extremes within groups (max, min per category)
3. Existence checks (EXISTS/NOT EXISTS)
4. When you need to compare each row to its group

WHEN TO AVOID CORRELATED SUBQUERIES:
1. On very large tables (performance issues)
2. When simpler solutions exist (JOINs, window functions)
3. When the subquery is very complex

BEST PRACTICES:
1. Always test the inner query separately first
2. Use meaningful aliases (p1, p2 instead of a, b)
3. Consider performance implications
4. Add comments explaining what the correlation does
*/

PRINT '=== END OF CORRELATED SUBQUERIES LESSON ===';