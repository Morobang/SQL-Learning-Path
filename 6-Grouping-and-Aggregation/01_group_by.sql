-- 1. Basic GROUP BY with COUNT
-- Count the number of employees in each department
SELECT 
    d.Name AS DepartmentName,
    COUNT(e.BusinessEntityID) AS EmployeeCount
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL -- Current department assignment
GROUP BY d.Name
ORDER BY EmployeeCount DESC;

-- 2. GROUP BY with multiple columns and aggregate functions
-- Get total sales by territory and year
SELECT 
    st.Name AS TerritoryName,
    YEAR(soh.OrderDate) AS OrderYear,
    COUNT(soh.SalesOrderID) AS TotalOrders,
    SUM(soh.TotalDue) AS TotalSales,
    AVG(soh.TotalDue) AS AverageOrderValue
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
GROUP BY st.Name, YEAR(soh.OrderDate)
ORDER BY TerritoryName, OrderYear;

-- 3. GROUP BY with HAVING clause
-- Find product categories with average list price over $100
SELECT 
    pc.Name AS CategoryName,
    AVG(p.ListPrice) AS AvgListPrice,
    COUNT(p.ProductID) AS ProductCount
FROM Production.Product p
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE p.ListPrice > 0 -- Exclude products with no list price
GROUP BY pc.Name
HAVING AVG(p.ListPrice) > 100
ORDER BY AvgListPrice DESC;

-- 4. GROUP BY with WHERE and HAVING
-- Find customers with more than 5 orders in 2013
SELECT 
    c.CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    COUNT(soh.SalesOrderID) AS OrderCount,
    SUM(soh.TotalDue) AS TotalSpent
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
WHERE YEAR(soh.OrderDate) = 2013
GROUP BY c.CustomerID, p.FirstName, p.LastName
HAVING COUNT(soh.SalesOrderID) > 5
ORDER BY TotalSpent DESC;

-- 5. GROUP BY with ROLLUP (for subtotals)
-- Get sales by territory and year with rollup for grand totals
SELECT 
    CASE 
        WHEN GROUPING(st.Name) = 1 THEN 'All Territories' 
        ELSE st.Name 
    END AS TerritoryName,
    CASE 
        WHEN GROUPING(YEAR(soh.OrderDate)) = 1 THEN 'All Years' 
        ELSE CAST(YEAR(soh.OrderDate) AS VARCHAR) 
    END AS OrderYear,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
GROUP BY ROLLUP(st.Name, YEAR(soh.OrderDate))
ORDER BY st.Name, YEAR(soh.OrderDate);

-- 6. GROUP BY with CASE expression
-- Categorize products by price range and count them
SELECT 
    CASE 
        WHEN ListPrice = 0 THEN 'Not for sale'
        WHEN ListPrice < 100 THEN 'Under $100'
        WHEN ListPrice < 500 THEN '$100-$500'
        WHEN ListPrice < 1000 THEN '$500-$1000'
        ELSE 'Over $1000'
    END AS PriceRange,
    COUNT(ProductID) AS ProductCount,
    MIN(ListPrice) AS MinPrice,
    MAX(ListPrice) AS MaxPrice,
    AVG(ListPrice) AS AvgPrice
FROM Production.Product
GROUP BY 
    CASE 
        WHEN ListPrice = 0 THEN 'Not for sale'
        WHEN ListPrice < 100 THEN 'Under $100'
        WHEN ListPrice < 500 THEN '$100-$500'
        WHEN ListPrice < 1000 THEN '$500-$1000'
        ELSE 'Over $1000'
    END
ORDER BY MinPrice;

-- 7. GROUP BY with JOINs to multiple tables
-- Get sales by product category and country
SELECT 
    pc.Name AS CategoryName,
    cr.Name AS CountryName,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    SUM(sod.OrderQty) AS TotalQuantity,
    SUM(sod.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
JOIN Person.CountryRegion cr ON st.CountryRegionCode = cr.CountryRegionCode
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name, cr.Name
ORDER BY pc.Name, TotalRevenue DESC;