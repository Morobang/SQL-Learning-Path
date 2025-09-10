-- ============================================================
-- FULL_OUTER_JOIN.SQL
-- Understanding and Using FULL OUTER JOIN Operations
-- Database: AdventureWorks
-- ============================================================

/*
OBJECTIVE:
FULL OUTER JOIN returns all records when there is a match in either the left or right table.
It combines the results of both LEFT and RIGHT outer joins.

USE CASES:
- Finding mismatched data between two tables
- Data reconciliation and comparison
- Identifying gaps in data completeness
- Merging datasets with partial overlaps
- Data quality assessment and validation
*/

USE AdventureWorks;
GO

-- =============================================================================
-- SECTION 1: BASIC FULL OUTER JOIN CONCEPTS
-- =============================================================================

PRINT '=== SECTION 1: BASIC FULL OUTER JOIN CONCEPTS ===';

-- Example 1.1: Simple FULL OUTER JOIN demonstration
SELECT 
    COALESCE(e.BusinessEntityID, edh.BusinessEntityID) AS BusinessEntityID,
    e.JobTitle,
    edh.DepartmentID,
    edh.StartDate
FROM HumanResources.Employee e
FULL OUTER JOIN HumanResources.EmployeeDepartmentHistory edh 
    ON e.BusinessEntityID = edh.BusinessEntityID
WHERE COALESCE(e.BusinessEntityID, edh.BusinessEntityID) BETWEEN 1 AND 10
ORDER BY COALESCE(e.BusinessEntityID, edh.BusinessEntityID);

/*
WHAT HAPPENED?
- Returns all employees AND all department history records
- Shows employees without department history (left side NULLs)
- Shows department history without matching employees (right side NULLs)
*/

-- =============================================================================
-- SECTION 2: FULL OUTER JOIN vs OTHER JOINS
-- =============================================================================

PRINT '=== SECTION 2: FULL OUTER JOIN vs OTHER JOINS ===';

-- Create sample tables for comparison
CREATE TABLE #LeftTable (ID INT, LeftValue VARCHAR(20));
CREATE TABLE #RightTable (ID INT, RightValue VARCHAR(20));

INSERT INTO #LeftTable VALUES (1, 'Left1'), (2, 'Left2'), (3, 'Left3');
INSERT INTO #RightTable VALUES (2, 'Right2'), (3, 'Right3'), (4, 'Right4');

-- INNER JOIN (only matching rows)
SELECT 
    COALESCE(l.ID, r.ID) AS ID,
    l.LeftValue,
    r.RightValue
FROM #LeftTable l
INNER JOIN #RightTable r ON l.ID = r.ID;

-- LEFT JOIN (all left rows + matching right rows)
SELECT 
    l.ID,
    l.LeftValue,
    r.RightValue
FROM #LeftTable l
LEFT JOIN #RightTable r ON l.ID = r.ID;

-- RIGHT JOIN (all right rows + matching left rows)
SELECT 
    r.ID,
    l.LeftValue,
    r.RightValue
FROM #LeftTable l
RIGHT JOIN #RightTable r ON l.ID = r.ID;

-- FULL OUTER JOIN (all rows from both tables)
SELECT 
    COALESCE(l.ID, r.ID) AS ID,
    l.LeftValue,
    r.RightValue
FROM #LeftTable l
FULL OUTER JOIN #RightTable r ON l.ID = r.ID;

/*
COMPARISON RESULTS:
INNER JOIN: IDs 2,3 (only matches)
LEFT JOIN:  IDs 1,2,3 (all left + matches)
RIGHT JOIN: IDs 2,3,4 (all right + matches)  
FULL OUTER: IDs 1,2,3,4 (everything from both tables)
*/

DROP TABLE #LeftTable, #RightTable;

-- =============================================================================
-- SECTION 3: PRACTICAL USE CASES FOR FULL OUTER JOIN
-- =============================================================================

PRINT '=== SECTION 3: PRACTICAL USE CASES FOR FULL OUTER JOIN ===';

-- Use Case 3.1: Data reconciliation between systems
SELECT 
    COALESCE(p.BusinessEntityID, pp.BusinessEntityID) AS BusinessEntityID,
    p.FirstName + ' ' + p.LastName AS PersonName,
    pp.PhoneNumber,
    CASE 
        WHEN p.BusinessEntityID IS NULL THEN 'Phone number without person'
        WHEN pp.BusinessEntityID IS NULL THEN 'Person without phone number'
        ELSE 'Match found'
    END AS Status
FROM Person.Person p
FULL OUTER JOIN Person.PersonPhone pp 
    ON p.BusinessEntityID = pp.BusinessEntityID
WHERE COALESCE(p.BusinessEntityID, pp.BusinessEntityID) BETWEEN 1 AND 20
ORDER BY COALESCE(p.BusinessEntityID, pp.BusinessEntityID);

-- Use Case 3.2: Inventory vs Sales analysis
SELECT 
    COALESCE(p.ProductID, sod.ProductID) AS ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    SUM(COALESCE(sod.OrderQty, 0)) AS TotalSold,
    p.SafetyStockLevel,
    CASE 
        WHEN p.ProductID IS NULL THEN 'Sales record without product'
        WHEN sod.ProductID IS NULL THEN 'Product never sold'
        ELSE 'Product with sales'
    END AS Status
FROM Production.Product p
FULL OUTER JOIN Sales.SalesOrderDetail sod 
    ON p.ProductID = sod.ProductID
WHERE p.ProductID IS NULL OR p.ProductID BETWEEN 700 AND 800
GROUP BY COALESCE(p.ProductID, sod.ProductID), p.Name, p.ProductNumber, p.SafetyStockLevel
ORDER BY TotalSold DESC;

-- =============================================================================
-- SECTION 4: IDENTIFYING DATA QUALITY ISSUES
-- =============================================================================

PRINT '=== SECTION 4: IDENTIFYING DATA QUALITY ISSUES ===';

-- Example 4.1: Find customers without orders and orders without valid customers
SELECT 
    COALESCE(c.CustomerID, soh.CustomerID) AS CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    COUNT(soh.SalesOrderID) AS OrderCount,
    CASE 
        WHEN c.CustomerID IS NULL THEN 'Order without customer record'
        WHEN soh.CustomerID IS NULL THEN 'Customer without orders'
        ELSE 'Customer with orders'
    END AS Status
FROM Sales.Customer c
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
FULL OUTER JOIN Sales.SalesOrderHeader soh 
    ON c.CustomerID = soh.CustomerID
GROUP BY COALESCE(c.CustomerID, soh.CustomerID), p.FirstName + ' ' + p.LastName
HAVING COUNT(soh.SalesOrderID) = 0 OR c.CustomerID IS NULL
ORDER BY Status, CustomerID;

-- Example 4.2: Product and product model reconciliation
SELECT 
    COALESCE(p.ProductID, pm.ProductModelID) AS ID,
    p.Name AS ProductName,
    pm.Name AS ModelName,
    CASE 
        WHEN p.ProductID IS NULL THEN 'Model without products'
        WHEN pm.ProductModelID IS NULL THEN 'Product without model'
        ELSE 'Product with model'
    END AS RelationshipStatus
FROM Production.Product p
FULL OUTER JOIN Production.ProductModel pm 
    ON p.ProductModelID = pm.ProductModelID
WHERE p.ProductID IS NULL OR pm.ProductModelID IS NULL OR p.ProductID BETWEEN 1 AND 100
ORDER BY RelationshipStatus, ID;

-- =============================================================================
-- SECTION 5: DATA COMPLETENESS ANALYSIS
-- =============================================================================

PRINT '=== SECTION 5: DATA COMPLETENESS ANALYSIS ===';

-- Example 5.1: Analyze sales territory coverage
SELECT 
    COALESCE(st.TerritoryID, soh.TerritoryID) AS TerritoryID,
    st.Name AS TerritoryName,
    st.CountryRegionCode,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    CASE 
        WHEN st.TerritoryID IS NULL THEN 'Sales in undefined territory'
        WHEN soh.TerritoryID IS NULL THEN 'Territory with no sales'
        ELSE 'Territory with sales'
    END AS Status
FROM Sales.SalesTerritory st
FULL OUTER JOIN Sales.SalesOrderHeader soh 
    ON st.TerritoryID = soh.TerritoryID
GROUP BY COALESCE(st.TerritoryID, soh.TerritoryID), st.Name, st.CountryRegionCode
ORDER BY OrderCount, TerritoryName;

-- Example 5.2: Employee department assignment analysis
SELECT 
    COALESCE(e.BusinessEntityID, edh.BusinessEntityID) AS BusinessEntityID,
    p.FirstName + ' ' + p.LastName AS EmployeeName,
    d.Name AS DepartmentName,
    edh.StartDate,
    edh.EndDate,
    CASE 
        WHEN e.BusinessEntityID IS NULL THEN 'Department history without employee'
        WHEN edh.BusinessEntityID IS NULL THEN 'Employee without department history'
        WHEN edh.EndDate IS NULL THEN 'Current department assignment'
        ELSE 'Historical department assignment'
    END AS Status
FROM HumanResources.Employee e
INNER JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
FULL OUTER JOIN HumanResources.EmployeeDepartmentHistory edh 
    ON e.BusinessEntityID = edh.BusinessEntityID
LEFT JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE COALESCE(e.BusinessEntityID, edh.BusinessEntityID) BETWEEN 1 AND 30
ORDER BY BusinessEntityID, edh.StartDate;

-- =============================================================================
-- SECTION 6: ADVANCED FULL OUTER JOIN PATTERNS
-- =============================================================================

PRINT '=== SECTION 6: ADVANCED FULL OUTER JOIN PATTERNS ===';

-- Pattern 6.1: Comparing two time periods
WITH CurrentYearSales AS (
    SELECT 
        ProductID,
        SUM(LineTotal) AS CurrentYearRevenue,
        SUM(OrderQty) AS CurrentYearQuantity
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    WHERE YEAR(soh.OrderDate) = 2013
    GROUP BY ProductID
),
PreviousYearSales AS (
    SELECT 
        ProductID,
        SUM(LineTotal) AS PreviousYearRevenue,
        SUM(OrderQty) AS PreviousYearQuantity
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    WHERE YEAR(soh.OrderDate) = 2012
    GROUP BY ProductID
)
SELECT 
    COALESCE(cy.ProductID, py.ProductID) AS ProductID,
    p.Name AS ProductName,
    COALESCE(cy.CurrentYearRevenue, 0) AS CurrentYearRevenue,
    COALESCE(py.PreviousYearRevenue, 0) AS PreviousYearRevenue,
    COALESCE(cy.CurrentYearRevenue, 0) - COALESCE(py.PreviousYearRevenue, 0) AS RevenueChange,
    CASE 
        WHEN cy.ProductID IS NULL THEN 'Sales only in previous year'
        WHEN py.ProductID IS NULL THEN 'Sales only in current year'
        ELSE 'Sales in both years'
    END AS SalesStatus
FROM CurrentYearSales cy
FULL OUTER JOIN PreviousYearSales py 
    ON cy.ProductID = py.ProductID
LEFT JOIN Production.Product p ON COALESCE(cy.ProductID, py.ProductID) = p.ProductID
ORDER BY RevenueChange DESC;

-- Pattern 6.2: Data validation across related tables
SELECT 
    COALESCE(pp.BusinessEntityID, bea.BusinessEntityID) AS BusinessEntityID,
    p.FirstName + ' ' + p.LastName AS PersonName,
    pp.PhoneNumber,
    bea.AddressID,
    a.AddressLine1,
    CASE 
        WHEN pp.BusinessEntityID IS NULL THEN 'Address without phone'
        WHEN bea.BusinessEntityID IS NULL THEN 'Phone without address'
        ELSE 'Both phone and address exist'
    END AS DataCompleteness
FROM Person.PersonPhone pp
FULL OUTER JOIN Person.BusinessEntityAddress bea 
    ON pp.BusinessEntityID = bea.BusinessEntityID
LEFT JOIN Person.Person p ON COALESCE(pp.BusinessEntityID, bea.BusinessEntityID) = p.BusinessEntityID
LEFT JOIN Person.Address a ON bea.AddressID = a.AddressID
WHERE COALESCE(pp.BusinessEntityID, bea.BusinessEntityID) BETWEEN 1 AND 50
ORDER BY DataCompleteness, BusinessEntityID;

-- =============================================================================
-- SECTION 7: PERFORMANCE CONSIDERATIONS
-- =============================================================================

PRINT '=== SECTION 7: PERFORMANCE CONSIDERATIONS ===';

/*
PERFORMANCE TIPS FOR FULL OUTER JOIN:

1. INDEXING: Ensure join columns are indexed
2. FILTER EARLY: Use WHERE clauses on source tables, not results
3. LIMIT SCOPE: Use TOP or row limiting in development
4. AGGREGATE SMARTLY: Do aggregations before joining when possible
5. MONITOR: Check execution plans for large joins
*/

-- Example 7.1: Optimized FULL OUTER JOIN with pre-filtering
WITH FilteredProducts AS (
    SELECT ProductID, Name, ProductNumber
    FROM Production.Product
    WHERE ProductID BETWEEN 1 AND 1000
),
FilteredSales AS (
    SELECT ProductID, SUM(LineTotal) AS TotalSales
    FROM Sales.SalesOrderDetail
    WHERE ProductID BETWEEN 1 AND 1000
    GROUP BY ProductID
)
SELECT 
    COALESCE(fp.ProductID, fs.ProductID) AS ProductID,
    fp.Name AS ProductName,
    COALESCE(fs.TotalSales, 0) AS TotalSales,
    CASE 
        WHEN fs.ProductID IS NULL THEN 'No sales'
        ELSE 'Has sales'
    END AS SalesStatus
FROM FilteredProducts fp
FULL OUTER JOIN FilteredSales fs 
    ON fp.ProductID = fs.ProductID
ORDER BY TotalSales DESC;

-- =============================================================================
-- SECTION 8: REAL-WORLD BUSINESS SCENARIOS
-- =============================================================================

PRINT '=== SECTION 8: REAL-WORLD BUSINESS SCENARIOS ===';

-- Scenario 8.1: Customer data integration after merger
SELECT 
    COALESCE(c1.CustomerID, c2.CustomerID) AS CustomerID,
    c1.AccountNumber AS System1_Account,
    c2.AccountNumber AS System2_Account,
    p1.FirstName + ' ' + p1.LastName AS System1_Name,
    p2.FirstName + ' ' + p2.LastName AS System2_Name,
    CASE 
        WHEN c1.CustomerID IS NULL THEN 'Only in System 2'
        WHEN c2.CustomerID IS NULL THEN 'Only in System 1'
        WHEN c1.AccountNumber = c2.AccountNumber THEN 'Perfect match'
        ELSE 'ID match but data differences'
    END AS IntegrationStatus
FROM Sales.Customer c1
FULL OUTER JOIN Sales.Customer c2 
    ON c1.CustomerID = c2.CustomerID
LEFT JOIN Person.Person p1 ON c1.PersonID = p1.BusinessEntityID
LEFT JOIN Person.Person p2 ON c2.PersonID = p2.BusinessEntityID
WHERE COALESCE(c1.CustomerID, c2.CustomerID) BETWEEN 1 AND 100
ORDER BY IntegrationStatus, CustomerID;

-- Scenario 8.2: Product catalog vs inventory analysis
SELECT 
    COALESCE(p.ProductID, pv.ProductID) AS ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    pv.Quantity AS InventoryQuantity,
    p.SafetyStockLevel,
    CASE 
        WHEN pv.ProductID IS NULL THEN 'Product not in inventory'
        WHEN pv.Quantity = 0 THEN 'Out of stock'
        WHEN pv.Quantity < p.SafetyStockLevel THEN 'Below safety stock'
        ELSE 'Adequate inventory'
    END AS InventoryStatus
FROM Production.Product p
FULL OUTER JOIN Production.ProductInventory pv 
    ON p.ProductID = pv.ProductID
WHERE p.ProductID IS NOT NULL OR pv.ProductID IS NOT NULL
ORDER BY InventoryStatus, ProductName;

-- =============================================================================
-- SECTION 9: COMMON PITFALLS AND SOLUTIONS
-- =============================================================================

PRINT '=== SECTION 9: COMMON PITFALLS AND SOLUTIONS ===';

-- Pitfall 9.1: Incorrect WHERE clause filtering
-- ❌ WRONG: Filters out NULL records prematurely
SELECT *
FROM TableA a
FULL OUTER JOIN TableB b ON a.ID = b.ID
WHERE a.SomeColumn = 'value';  -- This removes records where TableA is NULL!

-- ✅ CORRECT: Filter in subqueries or use OR conditions
SELECT *
FROM TableA a
FULL OUTER JOIN TableB b ON a.ID = b.ID
WHERE (a.SomeColumn = 'value' OR a.SomeColumn IS NULL);

-- Pitfall 9.2: Handling NULLs in aggregate functions
-- ❌ RISKY: SUM(NULL) returns NULL
SELECT 
    COALESCE(a.ID, b.ID) AS ID,
    SUM(a.Value) AS TotalA,  -- Could be NULL
    SUM(b.Value) AS TotalB   -- Could be NULL
FROM TableA a
FULL OUTER JOIN TableB b ON a.ID = b.ID
GROUP BY COALESCE(a.ID, b.ID);

-- ✅ SAFE: Use COALESCE with aggregates
SELECT 
    COALESCE(a.ID, b.ID) AS ID,
    COALESCE(SUM(a.Value), 0) AS TotalA,  -- Always a number
    COALESCE(SUM(b.Value), 0) AS TotalB   -- Always a number
FROM TableA a
FULL OUTER JOIN TableB b ON a.ID = b.ID
GROUP BY COALESCE(a.ID, b.ID);

-- =============================================================================
-- SECTION 10: EXERCISES FOR PRACTICE
-- =============================================================================

PRINT '=== SECTION 10: EXERCISES FOR PRACTICE ===';

/*
EXERCISE 1: Find all products and their reviews, including:
- Products without reviews
- Reviews without product records (if any)
- Show product name, review count, and status

EXERCISE 2: Compare employee login records with their department history:
- Employees without login records
- Login records without employee data
- Current department for each employee

EXERCISE 3: Analyze sales order vs sales order detail completeness:
- Orders without detail lines
- Detail lines without order headers
- Total amount discrepancies

EXERCISE 4: Create a vendor vs product analysis:
- Vendors without products
- Products without vendors
- Products with multiple vendors

EXERCISE 5: Build a data quality dashboard showing:
- Percentage of complete records across multiple tables
- Missing data relationships
- Data integrity issues
*/

-- =============================================================================
-- SECTION 11: SUMMARY AND KEY TAKEAWAYS
-- =============================================================================

PRINT '=== SECTION 11: SUMMARY AND KEY TAKEAWAYS ===';

/*
KEY POINTS:

1. FULL OUTER JOIN returns all records from both tables
2. NULL values indicate missing matches on either side
3. Essential for data reconciliation and completeness analysis
4. Use COALESCE() to handle NULLs in join columns
5. Be careful with WHERE clauses that might filter out NULL records

WHEN TO USE FULL OUTER JOIN:
- Data validation and quality checks
- Finding missing relationships
- Comparing two datasets with partial overlaps
- Data integration scenarios
- Comprehensive gap analysis

WHEN TO AVOID FULL OUTER JOIN:
- When you only need matching records (use INNER JOIN)
- When you primarily care about one side (use LEFT/RIGHT JOIN)
- With very large tables without proper indexing
*/

PRINT '=== END OF FULL OUTER JOIN LESSON ===';