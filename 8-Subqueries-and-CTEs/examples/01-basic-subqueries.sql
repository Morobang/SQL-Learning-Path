-- ============================================================
-- 01_SUBQUERIES.SQL
-- Complete Beginner's Guide to SQL Subqueries
-- Database: AdventureWorks (or any similar database)
-- ============================================================

/*
WHAT ARE SUBQUERIES?
A subquery is a SQL query nested inside another query.
Think of it as asking a question to answer another question.
*/

USE AdventureWorks;
GO

-- =============================================================================
-- SECTION 1: BASIC SUBQUERY CONCEPTS
-- =============================================================================

PRINT '=== SECTION 1: BASIC SUBQUERY CONCEPTS ===';

-- Example 1.1: Scalar Subquery (returns single value)
-- Find products that are more expensive than the average product
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
ORDER BY ListPrice DESC;

/*
HOW THIS WORKS:
1. The inner query runs first: SELECT AVG(ListPrice) FROM Production.Product
2. It calculates the average list price (let's say $100)
3. The outer query becomes: WHERE ListPrice > 100
4. Returns products more expensive than average
*/

-- =============================================================================
-- SECTION 2: TYPES OF SUBQUERIES
-- =============================================================================

PRINT '=== SECTION 2: TYPES OF SUBQUERIES ===';

-- 2.1 SINGLE-VALUE SUBQUERY (SCALAR)
-- Find employees who earn more than the average salary
SELECT 
    BusinessEntityID,
    JobTitle,
    Rate
FROM HumanResources.EmployeePayHistory
WHERE Rate > (
    SELECT AVG(Rate) 
    FROM HumanResources.EmployeePayHistory
)
ORDER BY Rate DESC;

-- 2.2 MULTIPLE-VALUE SUBQUERY (COLUMN)
-- Find products in specific categories
SELECT 
    ProductID,
    Name,
    ProductNumber
FROM Production.Product
WHERE ProductSubcategoryID IN (
    SELECT ProductSubcategoryID 
    FROM Production.ProductSubcategory 
    WHERE Name LIKE '%Bike%'
);

-- 2.3 CORRELATED SUBQUERY
-- Find products that are more expensive than their category average
SELECT 
    p1.ProductID,
    p1.Name,
    p1.ListPrice,
    (
        SELECT AVG(p2.ListPrice)
        FROM Production.Product p2
        WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID
        AND p2.ListPrice > 0
    ) AS CategoryAvgPrice
FROM Production.Product p1
WHERE p1.ListPrice > 0
ORDER BY p1.ProductSubcategoryID, p1.ListPrice DESC;

-- =============================================================================
-- SECTION 3: SUBQUERIES IN DIFFERENT CLAUSES
-- =============================================================================

PRINT '=== SECTION 3: SUBQUERIES IN DIFFERENT CLAUSES ===';

-- 3.1 SUBQUERY IN SELECT CLAUSE
-- Show each product's price and how it compares to category average
SELECT 
    ProductID,
    Name,
    ListPrice,
    ListPrice - (
        SELECT AVG(ListPrice)
        FROM Production.Product p2
        WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID
        AND p2.ListPrice > 0
    ) AS PriceDifferenceFromCategoryAvg
FROM Production.Product p1
WHERE ListPrice > 0
ORDER BY PriceDifferenceFromCategoryAvg DESC;

-- 3.2 SUBQUERY IN FROM CLAUSE (DERIVED TABLE)
-- Find average price of expensive products
SELECT 
    AVG(ExpensiveProducts.ListPrice) AS AvgExpensivePrice
FROM (
    SELECT ListPrice
    FROM Production.Product
    WHERE ListPrice > 1000
) AS ExpensiveProducts;

-- 3.3 SUBQUERY IN WHERE CLAUSE
-- Find customers who have placed orders
SELECT 
    CustomerID,
    AccountNumber
FROM Sales.Customer
WHERE CustomerID IN (
    SELECT DISTINCT CustomerID 
    FROM Sales.SalesOrderHeader
);

-- 3.4 SUBQUERY IN HAVING CLAUSE
-- Find product categories with average price above company average
SELECT 
    ps.Name AS CategoryName,
    AVG(p.ListPrice) AS AvgPrice
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE p.ListPrice > 0
GROUP BY ps.Name
HAVING AVG(p.ListPrice) > (
    SELECT AVG(ListPrice) 
    FROM Production.Product 
    WHERE ListPrice > 0
)
ORDER BY AvgPrice DESC;

-- =============================================================================
-- SECTION 4: SUBQUERY OPERATORS
-- =============================================================================

PRINT '=== SECTION 4: SUBQUERY OPERATORS ===';

-- 4.1 IN OPERATOR
-- Find products that have been ordered
SELECT 
    ProductID,
    Name
FROM Production.Product
WHERE ProductID IN (
    SELECT DISTINCT ProductID 
    FROM Sales.SalesOrderDetail
);

-- 4.2 NOT IN OPERATOR
-- Find products that have NEVER been ordered
SELECT 
    ProductID,
    Name
FROM Production.Product
WHERE ProductID NOT IN (
    SELECT DISTINCT ProductID 
    FROM Sales.SalesOrderDetail
    WHERE ProductID IS NOT NULL
);

-- 4.3 EXISTS OPERATOR (more efficient than IN for large datasets)
-- Find customers who have placed orders
SELECT 
    c.CustomerID,
    c.AccountNumber
FROM Sales.Customer c
WHERE EXISTS (
    SELECT 1 
    FROM Sales.SalesOrderHeader soh 
    WHERE soh.CustomerID = c.CustomerID
);

-- 4.4 NOT EXISTS OPERATOR
-- Find customers who have NEVER placed orders
SELECT 
    c.CustomerID,
    c.AccountNumber
FROM Sales.Customer c
WHERE NOT EXISTS (
    SELECT 1 
    FROM Sales.SalesOrderHeader soh 
    WHERE soh.CustomerID = c.CustomerID
);

-- 4.5 ANY/SOME OPERATOR
-- Find products more expensive than ANY product in 'Bikes' category
SELECT 
    ProductID,
    Name,
    ListPrice
FROM Production.Product
WHERE ListPrice > ANY (
    SELECT ListPrice
    FROM Production.Product p
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    WHERE ps.Name LIKE '%Bike%' AND ListPrice > 0
)
AND ListPrice > 0
ORDER BY ListPrice;

-- 4.6 ALL OPERATOR
-- Find products more expensive than ALL products in 'Bikes' category
SELECT 
    ProductID,
    Name,
    ListPrice
FROM Production.Product
WHERE ListPrice > ALL (
    SELECT ListPrice
    FROM Production.Product p
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    WHERE ps.Name LIKE '%Bike%' AND ListPrice > 0
)
AND ListPrice > 0
ORDER BY ListPrice;

-- =============================================================================
-- SECTION 5: CORRELATED VS NON-CORRELATED SUBQUERIES
-- =============================================================================

PRINT '=== SECTION 5: CORRELATED VS NON-CORRELATED SUBQUERIES ===';

-- 5.1 NON-CORRELATED SUBQUERY (runs once)
-- Find products above average price
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
AND ListPrice > 0;

-- 5.2 CORRELATED SUBQUERY (runs for each row)
-- Find products that are the most expensive in their category
SELECT 
    p1.ProductID,
    p1.Name,
    p1.ListPrice,
    ps.Name AS CategoryName
FROM Production.Product p1
JOIN Production.ProductSubcategory ps ON p1.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE p1.ListPrice = (
    SELECT MAX(p2.ListPrice)
    FROM Production.Product p2
    WHERE p2.ProductSubcategoryID = p1.ProductSubcategoryID
    AND p2.ListPrice > 0
)
AND p1.ListPrice > 0
ORDER BY p1.ListPrice DESC;

-- =============================================================================
-- SECTION 6: PRACTICAL BUSINESS EXAMPLES
-- =============================================================================

PRINT '=== SECTION 6: PRACTICAL BUSINESS EXAMPLES ===';

-- 6.1 EMPLOYEE ANALYSIS
-- Find employees who earn more than their department average
SELECT 
    e.BusinessEntityID,
    p.FirstName + ' ' + p.LastName AS EmployeeName,
    eph.Rate,
    d.Name AS DepartmentName,
    (SELECT AVG(eph2.Rate) 
     FROM HumanResources.EmployeePayHistory eph2
     JOIN HumanResources.Employee e2 ON eph2.BusinessEntityID = e2.BusinessEntityID
     WHERE e2.DepartmentID = e.DepartmentID) AS DeptAvgRate
FROM HumanResources.Employee e
JOIN HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
JOIN HumanResources.Department d ON e.DepartmentID = d.DepartmentID
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE eph.Rate > (
    SELECT AVG(eph2.Rate) 
    FROM HumanResources.EmployeePayHistory eph2
    JOIN HumanResources.Employee e2 ON eph2.BusinessEntityID = e2.BusinessEntityID
    WHERE e2.DepartmentID = e.DepartmentID
)
ORDER BY d.Name, eph.Rate DESC;

-- 6.2 SALES ANALYSIS
-- Find customers whose average order value is above overall average
SELECT 
    soh.CustomerID,
    c.AccountNumber,
    AVG(soh.TotalDue) AS AvgOrderValue,
    (SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader) AS OverallAvgOrderValue
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
GROUP BY soh.CustomerID, c.AccountNumber
HAVING AVG(soh.TotalDue) > (SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader)
ORDER BY AvgOrderValue DESC;

-- 6.3 INVENTORY ANALYSIS
-- Find products with below-average inventory but above-average sales
SELECT 
    p.ProductID,
    p.Name,
    (SELECT SUM(Quantity) FROM Production.ProductInventory WHERE ProductID = p.ProductID) AS TotalInventory,
    (SELECT SUM(OrderQty) FROM Sales.SalesOrderDetail WHERE ProductID = p.ProductID) AS TotalSold
FROM Production.Product p
WHERE 
    (SELECT SUM(Quantity) FROM Production.ProductInventory WHERE ProductID = p.ProductID) < 
    (SELECT AVG(InventoryCount) FROM (
        SELECT SUM(Quantity) AS InventoryCount 
        FROM Production.ProductInventory 
        GROUP BY ProductID
    ) AS AvgInventory)
AND
    (SELECT SUM(OrderQty) FROM Sales.SalesOrderDetail WHERE ProductID = p.ProductID) >
    (SELECT AVG(SalesCount) FROM (
        SELECT SUM(OrderQty) AS SalesCount 
        FROM Sales.SalesOrderDetail 
        GROUP BY ProductID
    ) AS AvgSales);

-- =============================================================================
-- SECTION 7: PERFORMANCE CONSIDERATIONS
-- =============================================================================

PRINT '=== SECTION 7: PERFORMANCE CONSIDERATIONS ===';

/*
PERFORMANCE TIPS:
1. Use EXISTS instead of IN when possible
2. Avoid correlated subqueries on large tables
3. Test subqueries separately first
4. Consider using JOINs instead of subqueries
*/

-- 7.1 IN vs EXISTS comparison
-- SLOWER with IN:
SELECT *
FROM Production.Product p
WHERE p.ProductID IN (
    SELECT ProductID 
    FROM Sales.SalesOrderDetail
);

-- FASTER with EXISTS:
SELECT *
FROM Production.Product p
WHERE EXISTS (
    SELECT 1 
    FROM Sales.SalesOrderDetail sod 
    WHERE sod.ProductID = p.ProductID
);

-- =============================================================================
-- SECTION 8: COMMON MISTAKES AND SOLUTIONS
-- =============================================================================

PRINT '=== SECTION 8: COMMON MISTAKES AND SOLUTIONS ===';

-- 8.1 ERROR: Subquery returned more than 1 value
/*
-- THIS WILL FAIL:
SELECT ProductID, Name
FROM Production.Product
WHERE ListPrice = (
    SELECT ListPrice 
    FROM Production.Product 
    WHERE Color = 'Red'
);
*/

-- SOLUTION: Use IN instead of = for multiple values
SELECT ProductID, Name
FROM Production.Product
WHERE ListPrice IN (
    SELECT ListPrice 
    FROM Production.Product 
    WHERE Color = 'Red'
    AND ListPrice > 0
);

-- 8.2 ERROR: Handling NULL values with NOT IN
/*
-- THIS MAY RETURN UNEXPECTED RESULTS:
SELECT ProductID, Name
FROM Production.Product
WHERE ProductID NOT IN (
    SELECT ProductID 
    FROM Sales.SalesOrderDetail 
    WHERE ProductID IS NULL
);
*/

-- SOLUTION: Filter out NULLs or use NOT EXISTS
SELECT ProductID, Name
FROM Production.Product
WHERE NOT EXISTS (
    SELECT 1 
    FROM Sales.SalesOrderDetail sod 
    WHERE sod.ProductID = Product.ProductID
);

-- =============================================================================
-- SECTION 9: EXERCISES FOR PRACTICE
-- =============================================================================

PRINT '=== SECTION 9: EXERCISES FOR PRACTICE ===';

/*
EXERCISE 1: Find all products that have never been sold

EXERCISE 2: Find employees who have changed departments more than once

EXERCISE 3: Find customers who have ordered products from at least 3 different categories

EXERCISE 4: Find products that are more expensive than the most expensive product in 'Clothing' category

EXERCISE 5: Find the second highest priced product in each category
*/

-- =============================================================================
-- SECTION 10: SUMMARY AND BEST PRACTICES
-- =============================================================================

PRINT '=== SECTION 10: SUMMARY AND BEST PRACTICES ===';

/*
BEST PRACTICES:
1. Use subqueries for simple, single-purpose operations
2. Prefer EXISTS over IN for existence checks
3. Test subqueries independently first
4. Consider performance implications
5. Use comments to explain complex subqueries

WHEN TO USE SUBQUERIES:
- When you need a single value for comparison
- For existence checks (EXISTS/NOT EXISTS)
- When the subquery is simple and readable
- For row-by-row comparisons

WHEN TO USE OTHER TECHNIQUES:
- For complex multi-table operations (use JOINs)
- When you need to reuse the result (use CTEs)
- For better performance (consider temporary tables)
*/

PRINT '=== END OF SUBQUERIES LESSON ===';