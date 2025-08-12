/*
The HAVING clause filters groups after aggregation, 
while WHERE filters rows before aggregation.
*/

-- 1. Basic HAVING example
-- Find product categories with more than 20 products
SELECT 
    pc.Name AS CategoryName,
    COUNT(p.ProductID) AS ProductCount
FROM Production.Product p
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
HAVING COUNT(p.ProductID) > 20
ORDER BY ProductCount DESC;

-- 2. HAVING with multiple conditions
-- Find sales territories with total sales between $1M and $5M
SELECT 
    st.Name AS TerritoryName,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
GROUP BY st.Name
HAVING SUM(soh.TotalDue) BETWEEN 1000000 AND 5000000
ORDER BY TotalSales DESC;

-- 3. HAVING with aggregate functions
-- Find customers with average order value over $1000
SELECT 
    c.CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    COUNT(soh.SalesOrderID) AS OrderCount,
    AVG(soh.TotalDue) AS AvgOrderValue
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID, p.FirstName, p.LastName
HAVING AVG(soh.TotalDue) > 1000
ORDER BY AvgOrderValue DESC;

-- 4. HAVING with complex conditions
-- Find products that have been ordered more than 100 times but average less than 5 items per order
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    COUNT(DISTINCT sod.SalesOrderID) AS OrderCount,
    SUM(sod.OrderQty) AS TotalQuantity,
    AVG(sod.OrderQty) AS AvgQuantityPerOrder
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name
HAVING 
    COUNT(DISTINCT sod.SalesOrderID) > 100 
    AND AVG(sod.OrderQty) < 5
ORDER BY OrderCount DESC;

-- 5. Combining WHERE and HAVING
-- Find employees with more than 5 sick leave hours in 2014
SELECT 
    e.BusinessEntityID,
    p.FirstName + ' ' + p.LastName AS EmployeeName,
    SUM(eh.SickLeaveHours) AS TotalSickLeaveHours
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
JOIN HumanResources.EmployeePayHistory eh ON e.BusinessEntityID = eh.BusinessEntityID
WHERE YEAR(eh.RateChangeDate) = 2014
GROUP BY e.BusinessEntityID, p.FirstName, p.LastName
HAVING SUM(eh.SickLeaveHours) > 5
ORDER BY TotalSickLeaveHours DESC;

-- 6. HAVING with string functions
-- Find product colors with more than 10 products where average list price > $50
SELECT 
    p.Color,
    COUNT(p.ProductID) AS ProductCount,
    AVG(p.ListPrice) AS AvgListPrice
FROM Production.Product p
WHERE p.Color IS NOT NULL
GROUP BY p.Color
HAVING 
    COUNT(p.ProductID) > 10 
    AND AVG(p.ListPrice) > 50
ORDER BY ProductCount DESC;

-- 7. HAVING with date functions
-- Find years with more than 2000 orders
SELECT 
    YEAR(OrderDate) AS OrderYear,
    COUNT(SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
HAVING COUNT(SalesOrderID) > 2000
ORDER BY OrderYear;

/*
Key Notes:
1. HAVING is always used after GROUP BY
2. You can reference aggregate functions in HAVING that aren't in SELECT
3. For simple filtering of non-aggregated data, use WHERE instead
4. HAVING conditions can be as complex as needed with AND/OR
*/