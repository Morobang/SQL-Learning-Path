-- Get sales data with multiple levels of aggregation
SELECT 
    COALESCE(st.Name, 'All Territories') AS Territory,
    COALESCE(CONVERT(VARCHAR, YEAR(soh.OrderDate)), 'All Years') AS OrderYear,
    COALESCE(pc.Name, 'All Categories') AS Category,
    SUM(soh.TotalDue) AS TotalSales,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY GROUPING SETS (
    (st.Name, YEAR(soh.OrderDate), pc.Name),  -- Detailed level
    (st.Name, YEAR(soh.OrderDate)),           -- Territory and year subtotals
    (st.Name),                                -- Territory subtotals
    (YEAR(soh.OrderDate)),                    -- Year subtotals
    ()                                        -- Grand total
ORDER BY 
    CASE WHEN st.Name IS NULL THEN 1 ELSE 0 END, st.Name,
    CASE WHEN YEAR(soh.OrderDate) IS NULL THEN 1 ELSE 0 END, YEAR(soh.OrderDate),
    CASE WHEN pc.Name IS NULL THEN 1 ELSE 0 END, pc.Name;





-- Analyze sales with all possible dimension combinations
SELECT
    CASE WHEN GROUPING(st.Name) = 1 THEN 'All Territories' ELSE st.Name END AS Territory,
    CASE WHEN GROUPING(pc.Name) = 1 THEN 'All Categories' ELSE pc.Name END AS Category,
    CASE WHEN GROUPING(YEAR(soh.OrderDate)) = 1 THEN 'All Years' ELSE CONVERT(VARCHAR, YEAR(soh.OrderDate)) END AS OrderYear,
    SUM(soh.TotalDue) AS TotalSales,
    GROUPING(st.Name) AS TerritoryGrouping,
    GROUPING(pc.Name) AS CategoryGrouping,
    GROUPING(YEAR(soh.OrderDate)) AS YearGrouping
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY CUBE(st.Name, pc.Name, YEAR(soh.OrderDate))
ORDER BY 
    GROUPING(st.Name), st.Name,
    GROUPING(pc.Name), pc.Name,
    GROUPING(YEAR(soh.OrderDate)), YEAR(soh.OrderDate);



-- Hierarchical sales rollup: Year > Quarter > Month
SELECT
    YEAR(soh.OrderDate) AS OrderYear,
    DATEPART(QUARTER, soh.OrderDate) AS OrderQuarter,
    MONTH(soh.OrderDate) AS OrderMonth,
    SUM(soh.TotalDue) AS TotalSales,
    GROUPING_ID(YEAR(soh.OrderDate), DATEPART(QUARTER, soh.OrderDate), MONTH(soh.OrderDate)) AS GroupingLevel
FROM Sales.SalesOrderHeader soh
GROUP BY ROLLUP(YEAR(soh.OrderDate), DATEPART(QUARTER, soh.OrderDate), MONTH(soh.OrderDate))
ORDER BY 
    YEAR(soh.OrderDate),
    DATEPART(QUARTER, soh.OrderDate),
    MONTH(soh.OrderDate);




-- Pivot sales by product category across years
SELECT CategoryName, [2011], [2012], [2013], [2014]
FROM (
    SELECT 
        pc.Name AS CategoryName,
        YEAR(soh.OrderDate) AS OrderYear,
        soh.TotalDue
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
) AS SourceTable
PIVOT (
    SUM(TotalDue)
    FOR OrderYear IN ([2011], [2012], [2013], [2014])
) AS PivotTable
ORDER BY CategoryName;






-- Compare each product's sales to category average
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    pc.Name AS CategoryName,
    SUM(sod.LineTotal) AS ProductSales,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    AVG(SUM(sod.LineTotal)) OVER (PARTITION BY pc.Name) AS AvgCategorySales,
    SUM(sod.LineTotal) / AVG(SUM(sod.LineTotal)) OVER (PARTITION BY pc.Name) * 100 AS PercentOfCategoryAvg
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY p.ProductID, p.Name, pc.Name
ORDER BY pc.Name, ProductSales DESC;





-- Find products that account for top 80% of sales in their category
WITH CategorySales AS (
    SELECT 
        pc.Name AS CategoryName,
        p.ProductID,
        p.Name AS ProductName,
        SUM(sod.LineTotal) AS ProductSales,
        SUM(SUM(sod.LineTotal)) OVER (PARTITION BY pc.Name) AS CategoryTotal,
        SUM(SUM(sod.LineTotal)) OVER (PARTITION BY pc.Name ORDER BY SUM(sod.LineTotal) DESC 
                                     ROWS UNBOUNDED PRECEDING) AS RunningTotal
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
    GROUP BY pc.Name, p.ProductID, p.Name
)
SELECT 
    CategoryName,
    ProductName,
    ProductSales,
    ProductSales/CategoryTotal*100 AS PercentOfCategory,
    RunningTotal/CategoryTotal*100 AS CumulativePercent
FROM CategorySales
WHERE RunningTotal <= CategoryTotal * 0.8 OR
      (RunningTotal - ProductSales) <= CategoryTotal * 0.8
ORDER BY CategoryName, ProductSales DESC;




-- Dynamic customer segmentation based on purchase behavior
SELECT
    CASE
        WHEN TotalOrders BETWEEN 1 AND 3 THEN 'Occasional (1-3 orders)'
        WHEN TotalOrders BETWEEN 4 AND 10 THEN 'Regular (4-10 orders)'
        WHEN TotalOrders > 10 THEN 'Frequent (10+ orders)'
        ELSE 'Other'
    END AS CustomerSegment,
    COUNT(CustomerID) AS CustomerCount,
    AVG(TotalSpent) AS AvgSpent,
    SUM(TotalSpent) AS SegmentTotal,
    SUM(TotalSpent) / (SELECT SUM(TotalDue) FROM Sales.SalesOrderHeader) * 100 AS PercentOfTotalSales
FROM (
    SELECT
        c.CustomerID,
        COUNT(DISTINCT soh.SalesOrderID) AS TotalOrders,
        SUM(soh.TotalDue) AS TotalSpent
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID
) AS CustomerStats
GROUP BY 
    CASE
        WHEN TotalOrders BETWEEN 1 AND 3 THEN 'Occasional (1-3 orders)'
        WHEN TotalOrders BETWEEN 4 AND 10 THEN 'Regular (4-10 orders)'
        WHEN TotalOrders > 10 THEN 'Frequent (10+ orders)'
        ELSE 'Other'
    END
ORDER BY SegmentTotal DESC;