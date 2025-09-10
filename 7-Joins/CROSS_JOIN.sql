-- ============================================================
-- CROSS_JOIN.SQL
-- Understanding and Using CROSS JOIN Operations
-- Database: AdventureWorks
-- ============================================================

/*
OBJECTIVE:
CROSS JOIN returns the Cartesian product of two tables - every possible 
combination of rows from both tables. Unlike other joins, it doesn't require
a join condition.

USE CASES:
- Generating all possible combinations
- Creating matrices or grids of data
- Data simulation and test data generation
- Calendar and scheduling applications
- Pre-computing all possible scenarios
*/

USE AdventureWorks;
GO

-- =============================================================================
-- SECTION 1: BASIC CROSS JOIN CONCEPTS
-- =============================================================================

PRINT '=== SECTION 1: BASIC CROSS JOIN CONCEPTS ===';

-- Example 1.1: Simple CROSS JOIN between two small tables
SELECT 
    e.BusinessEntityID AS EmployeeID,
    p.Name AS ProductName
FROM 
    (SELECT TOP 5 BusinessEntityID FROM HumanResources.Employee) e
CROSS JOIN 
    (SELECT TOP 3 Name FROM Production.Product WHERE ProductID IS NOT NULL) p
ORDER BY e.BusinessEntityID, p.Name;

/*
WHAT HAPPENED?
5 employees × 3 products = 15 rows
Each employee is paired with every product
*/

-- Example 1.2: CROSS JOIN with actual tables (be careful - can be huge!)
SELECT 
    c.CustomerID,
    p.ProductID
FROM 
    (SELECT TOP 10 CustomerID FROM Sales.Customer) c
CROSS JOIN 
    (SELECT TOP 5 ProductID FROM Production.Product) p
ORDER BY c.CustomerID, p.ProductID;

/*
WARNING: Unfiltered CROSS JOIN on large tables can generate massive results!
Always use TOP or WHERE clauses to limit results during development.
*/

-- =============================================================================
-- SECTION 2: CROSS JOIN vs OTHER JOINS
-- =============================================================================

PRINT '=== SECTION 2: CROSS JOIN vs OTHER JOINS ===';

-- Example 2.1: Compare CROSS JOIN with INNER JOIN
-- CROSS JOIN (no condition - all combinations)
SELECT 
    e.BusinessEntityID,
    d.DepartmentID
FROM 
    (SELECT TOP 3 BusinessEntityID FROM HumanResources.Employee) e
CROSS JOIN 
    (SELECT TOP 2 DepartmentID FROM HumanResources.Department) d;

-- INNER JOIN (with condition - only matching rows)
SELECT 
    e.BusinessEntityID,
    d.DepartmentID
FROM 
    (SELECT TOP 3 BusinessEntityID FROM HumanResources.Employee) e
INNER JOIN 
    HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN 
    (SELECT TOP 2 DepartmentID FROM HumanResources.Department) d ON edh.DepartmentID = d.DepartmentID;

/*
KEY DIFFERENCES:
- CROSS JOIN: All combinations (3 employees × 2 departments = 6 rows)
- INNER JOIN: Only actual relationships (may be 0-6 rows depending on data)
*/

-- =============================================================================
-- SECTION 3: PRACTICAL USE CASES FOR CROSS JOIN
-- =============================================================================

PRINT '=== SECTION 3: PRACTICAL USE CASES FOR CROSS JOIN ===';

-- Use Case 3.1: Generating a date range for reporting
DECLARE @StartDate DATE = '2023-01-01';
DECLARE @EndDate DATE = '2023-01-07';

WITH Numbers AS (
    SELECT TOP (DATEDIFF(DAY, @StartDate, @EndDate) + 1) 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM master..spt_values
)
SELECT 
    DATEADD(DAY, n, @StartDate) AS ReportDate
FROM Numbers
ORDER BY ReportDate;

-- Use Case 3.2: Creating a matrix of all product categories and territories
SELECT 
    pc.Name AS CategoryName,
    st.Name AS TerritoryName,
    0 AS Placeholder  -- Can be used for future metrics
FROM 
    (SELECT DISTINCT Name FROM Production.ProductCategory) pc
CROSS JOIN 
    (SELECT DISTINCT Name FROM Sales.SalesTerritory) st
ORDER BY pc.Name, st.Name;

/*
BUSINESS APPLICATION:
This matrix helps ensure we have reporting for every possible 
category-territory combination, even if no sales exist.
*/

-- Use Case 3.3: Generating test data combinations
SELECT 
    'TestCustomer' + CAST(c.n AS VARCHAR) AS CustomerName,
    'Product' + CAST(p.n AS VARCHAR) AS ProductName,
    (c.n * 10) + p.n AS TestQuantity,
    GETDATE() - (c.n * p.n) AS TestDate
FROM 
    (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) c
CROSS JOIN 
    (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3) p;

-- =============================================================================
-- SECTION 4: CROSS JOIN WITH AGGREGATIONS AND ANALYSIS
-- =============================================================================

PRINT '=== SECTION 4: CROSS JOIN WITH AGGREGATIONS AND ANALYSIS ===';

-- Example 4.1: Analyzing sales coverage (what combinations don't exist?)
WITH AllCombinations AS (
    SELECT 
        pc.Name AS CategoryName,
        st.Name AS TerritoryName
    FROM Production.ProductCategory pc
    CROSS JOIN Sales.SalesTerritory st
),
ActualSales AS (
    SELECT 
        pc.Name AS CategoryName,
        st.Name AS TerritoryName,
        COUNT(*) AS SalesCount
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
    JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
    GROUP BY pc.Name, st.Name
)
SELECT 
    ac.CategoryName,
    ac.TerritoryName,
    COALESCE(asales.SalesCount, 0) AS SalesCount,
    CASE WHEN asales.SalesCount IS NULL THEN 'No Sales' ELSE 'Has Sales' END AS Status
FROM AllCombinations ac
LEFT JOIN ActualSales asales ON ac.CategoryName = asales.CategoryName 
                            AND ac.TerritoryName = asales.TerritoryName
ORDER BY ac.CategoryName, ac.TerritoryName;

/*
BUSINESS INSIGHT:
This reveals market gaps - which product categories haven't been sold 
in which territories, potentially indicating untapped opportunities.
*/

-- =============================================================================
-- SECTION 5: CROSS JOIN FOR CALENDAR AND SCHEDULING
-- =============================================================================

PRINT '=== SECTION 5: CROSS JOIN FOR CALENDAR AND SCHEDULING ===';

-- Example 5.1: Creating a business calendar with time slots
WITH Dates AS (
    SELECT 
        DATEADD(DAY, n-1, '2024-01-01') AS CalendarDate
    FROM 
        (SELECT TOP 365 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n 
         FROM master..spt_values) numbers
),
TimeSlots AS (
    SELECT '08:00' AS StartTime, '09:00' AS EndTime UNION ALL
    SELECT '09:00', '10:00' UNION ALL
    SELECT '10:00', '11:00' UNION ALL
    SELECT '11:00', '12:00' UNION ALL
    SELECT '13:00', '14:00' UNION ALL
    SELECT '14:00', '15:00' UNION ALL
    SELECT '15:00', '16:00' UNION ALL
    SELECT '16:00', '17:00'
),
Employees AS (
    SELECT TOP 5 BusinessEntityID, FirstName, LastName 
    FROM HumanResources.Employee e
    JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
)
SELECT 
    e.BusinessEntityID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    d.CalendarDate,
    t.StartTime,
    t.EndTime,
    'Available' AS Status
FROM Employees e
CROSS JOIN Dates d
CROSS JOIN TimeSlots t
WHERE DATEPART(WEEKDAY, d.CalendarDate) BETWEEN 2 AND 6  -- Weekdays only
  AND d.CalendarDate <= '2024-01-07'  -- First week only for demo
ORDER BY e.BusinessEntityID, d.CalendarDate, t.StartTime;

-- =============================================================================
-- SECTION 6: CROSS JOIN WITH FILTERING AND CONDITIONS
-- =============================================================================

PRINT '=== SECTION 6: CROSS JOIN WITH FILTERING AND CONDITIONS ===';

-- Example 6.1: Using WHERE clause with CROSS JOIN
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    l.LocationID,
    l.Name AS LocationName
FROM 
    (SELECT ProductID, Name FROM Production.Product WHERE Color = 'Red') p
CROSS JOIN 
    (SELECT LocationID, Name FROM Production.Location WHERE Name LIKE 'F%') l
ORDER BY p.ProductID, l.LocationID;

/*
NOTE: Although we're using WHERE with CROSS JOIN, it's still a Cartesian product
of the filtered results. The WHERE clause filters the input tables, not the output combinations.
*/

-- Example 6.2: Conditional logic in SELECT with CROSS JOIN
SELECT 
    c.CustomerID,
    p.ProductID,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM Sales.SalesOrderHeader soh
            JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
            WHERE soh.CustomerID = c.CustomerID AND sod.ProductID = p.ProductID
        ) THEN 'Purchased' 
        ELSE 'Not Purchased' 
    END AS PurchaseStatus
FROM 
    (SELECT TOP 10 CustomerID FROM Sales.Customer) c
CROSS JOIN 
    (SELECT TOP 5 ProductID FROM Production.Product) p
ORDER BY c.CustomerID, p.ProductID;

-- =============================================================================
-- SECTION 7: PERFORMANCE CONSIDERATIONS AND BEST PRACTICES
-- =============================================================================

PRINT '=== SECTION 7: PERFORMANCE CONSIDERATIONS AND BEST PRACTICES ===';

/*
WARNING: CROSS JOIN can be extremely expensive!

A CROSS JOIN between:
- Table A with 1,000 rows
- Table B with 1,000 rows
- Result: 1,000,000 rows!

BEST PRACTICES:
1. Always test with small subsets first (use TOP)
2. Use WHERE clauses to limit input table sizes
3. Consider if you really need ALL combinations
4. Monitor query performance and resource usage
5. Use appropriate indexing on source tables
*/

-- Example 7.1: Safe CROSS JOIN pattern
WITH LimitedProducts AS (
    SELECT TOP 20 ProductID, Name, ListPrice 
    FROM Production.Product 
    WHERE ListPrice > 0
    ORDER BY ListPrice DESC
),
LimitedCustomers AS (
    SELECT TOP 30 CustomerID 
    FROM Sales.Customer 
    ORDER BY CustomerID
)
SELECT 
    c.CustomerID,
    p.ProductID,
    p.Name AS ProductName,
    p.ListPrice
FROM LimitedCustomers c
CROSS JOIN LimitedProducts p
ORDER BY c.CustomerID, p.ListPrice DESC;

-- =============================================================================
-- SECTION 8: ADVANCED PATTERNS AND TECHNIQUES
-- =============================================================================

PRINT '=== SECTION 8: ADVANCED PATTERNS AND TECHNIQUES ===';

-- Pattern 8.1: Generating number sequences
WITH Numbers AS (
    SELECT ones.n + tens.n * 10 + hundreds.n * 100 AS Number
    FROM 
        (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION 
         SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) ones
    CROSS JOIN 
        (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION 
         SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) tens
    CROSS JOIN 
        (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION 
         SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) hundreds
)
SELECT Number
FROM Numbers
WHERE Number BETWEEN 1 AND 500
ORDER BY Number;

-- Pattern 8.2: Creating a data density analysis
WITH AllDateProductCombos AS (
    SELECT 
        soh.OrderDate,
        p.ProductID
    FROM 
        (SELECT DISTINCT CAST(OrderDate AS DATE) AS OrderDate 
         FROM Sales.SalesOrderHeader 
         WHERE OrderDate >= '2013-01-01') soh
    CROSS JOIN 
        (SELECT DISTINCT ProductID 
         FROM Production.Product 
         WHERE ProductID IN (SELECT DISTINCT ProductID FROM Sales.SalesOrderDetail)) p
),
ActualSales AS (
    SELECT 
        CAST(soh.OrderDate AS DATE) AS OrderDate,
        sod.ProductID,
        COUNT(*) AS SalesCount
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    WHERE soh.OrderDate >= '2013-01-01'
    GROUP BY CAST(soh.OrderDate AS DATE), sod.ProductID
)
SELECT 
    adpc.OrderDate,
    adpc.ProductID,
    COALESCE(asales.SalesCount, 0) AS SalesCount,
    CASE WHEN asales.SalesCount IS NULL THEN 0 ELSE 1 END AS HadSales
FROM AllDateProductCombos adpc
LEFT JOIN ActualSales asales ON adpc.OrderDate = asales.OrderDate 
                            AND adpc.ProductID = asales.ProductID
ORDER BY adpc.OrderDate, adpc.ProductID;

-- =============================================================================
-- SECTION 9: REAL-WORLD BUSINESS APPLICATIONS
-- =============================================================================

PRINT '=== SECTION 9: REAL-WORLD BUSINESS APPLICATIONS ===';

-- Application 9.1: Price matrix for all products and customers
WITH ProductPrices AS (
    SELECT 
        p.ProductID,
        p.Name AS ProductName,
        p.ListPrice,
        pc.Name AS CategoryName
    FROM Production.Product p
    JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
    WHERE p.ListPrice > 0
),
CustomerGroups AS (
    SELECT 
        soh.CustomerID,
        CASE 
            WHEN SUM(soh.TotalDue) > 10000 THEN 'Premium'
            WHEN SUM(soh.TotalDue) > 5000 THEN 'Standard'
            ELSE 'Basic'
        END AS CustomerTier
    FROM Sales.SalesOrderHeader soh
    GROUP BY soh.CustomerID
)
SELECT 
    cg.CustomerTier,
    pp.CategoryName,
    pp.ProductName,
    pp.ListPrice,
    CASE 
        WHEN cg.CustomerTier = 'Premium' THEN pp.ListPrice * 0.9  -- 10% discount
        WHEN cg.CustomerTier = 'Standard' THEN pp.ListPrice * 0.95 -- 5% discount
        ELSE pp.ListPrice
    END AS DiscountedPrice
FROM CustomerGroups cg
CROSS JOIN ProductPrices pp
ORDER BY cg.CustomerTier, pp.CategoryName, pp.ProductName;

-- Application 9.2: Sales target allocation across territories and products
WITH Territories AS (
    SELECT TerritoryID, Name 
    FROM Sales.SalesTerritory 
    WHERE CountryRegionCode = 'US'
),
Products AS (
    SELECT ProductID, Name 
    FROM Production.Product 
    WHERE ProductLine = 'R'  -- Road bikes
),
MonthlyTargets AS (
    SELECT '2024-01-01' AS MonthStart, 100000 AS SalesTarget UNION ALL
    SELECT '2024-02-01', 120000 UNION ALL
    SELECT '2024-03-01', 150000
)
SELECT 
    t.Name AS Territory,
    p.Name AS Product,
    mt.MonthStart,
    mt.SalesTarget / (COUNT(*) OVER (PARTITION BY mt.MonthStart)) AS AllocatedTarget
FROM Territories t
CROSS JOIN Products p
CROSS JOIN MonthlyTargets mt
ORDER BY mt.MonthStart, t.Name, p.Name;

-- =============================================================================
-- SECTION 10: EXERCISES AND CHALLENGES
-- =============================================================================

PRINT '=== SECTION 10: EXERCISES AND CHALLENGES ===';

/*
EXERCISE 1: Create a calendar for the next year showing all working days
(Monday-Friday) and all working hours (9 AM - 5 PM in hourly slots)

EXERCISE 2: Generate a matrix showing which employees have worked in which
departments (even if they never actually worked there - show all combinations)

EXERCISE 3: Create a price sensitivity analysis that shows how many customers
would fall into different discount brackets for each product category

EXERCISE 4: Build a scheduling system that shows all possible time slots
for conference rooms and employees for the next week

EXERCISE 5: Create a data completeness report showing which combinations
of product attributes have no products associated with them
*/

-- =============================================================================
-- SECTION 11: SUMMARY AND KEY TAKEAWAYS
-- =============================================================================

PRINT '=== SECTION 11: SUMMARY AND KEY TAKEAWAYS ===';

/*
KEY POINTS:

1. CROSS JOIN creates Cartesian products - all possible combinations
2. No join condition is required or allowed
3. Extremely powerful but can be dangerous with large tables
4. Essential for: data generation, matrix operations, completeness analysis
5. Always use TOP or WHERE to limit results during development

WHEN TO USE CROSS JOIN:
- Generating test data
- Creating calendar and schedule grids
- Analyzing data completeness (what combinations are missing)
- Pre-computing all possible scenarios
- Building matrices for reporting

WHEN TO AVOID CROSS JOIN:
- With large tables (unless absolutely necessary)
- When you're not sure about the table sizes
- When a conditional join would be more appropriate
*/

PRINT '=== END OF CROSS JOIN LESSON ===';