
-- This query provides sales data at multiple levels of aggregation in a single result set
-- It shows detailed sales by territory/year/category, plus various subtotals and grand total

SELECT 
    COALESCE(st.Name, 'All Territories') AS Territory,  -- Replace NULL with "All Territories" for aggregated rows
    COALESCE(CONVERT(VARCHAR, YEAR(soh.OrderDate)), 'All Years') AS OrderYear,  -- Replace NULL year with "All Years"
    COALESCE(pc.Name, 'All Categories') AS Category,    -- Replace NULL category with "All Categories"
    SUM(soh.TotalDue) AS TotalSales,                    -- Sum of sales for each group
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount      -- Count of distinct orders
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY GROUPING SETS (
    (st.Name, YEAR(soh.OrderDate), pc.Name),  -- Detailed level: Territory + Year + Category
    (st.Name, YEAR(soh.OrderDate)),           -- Subtotal level: Territory + Year
    (st.Name),                                -- Subtotal level: Territory only
    (YEAR(soh.OrderDate)),                    -- Subtotal level: Year only
    ()                                        -- Grand total level (all records)
ORDER BY 
    -- Custom sorting to group aggregated rows together
    CASE WHEN st.Name IS NULL THEN 1 ELSE 0 END, st.Name,
    CASE WHEN YEAR(soh.OrderDate) IS NULL THEN 1 ELSE 0 END, YEAR(soh.OrderDate),
    CASE WHEN pc.Name IS NULL THEN 1 ELSE 0 END, pc.Name;



-- CUBE generates all possible combinations of the grouped dimensions
-- This is useful for comprehensive multi-dimensional analysis

SELECT
    -- Use GROUPING function to identify aggregated rows and display appropriate labels
    CASE WHEN GROUPING(st.Name) = 1 THEN 'All Territories' ELSE st.Name END AS Territory,
    CASE WHEN GROUPING(pc.Name) = 1 THEN 'All Categories' ELSE pc.Name END AS Category,
    CASE WHEN GROUPING(YEAR(soh.OrderDate)) = 1 THEN 'All Years' ELSE CONVERT(VARCHAR, YEAR(soh.OrderDate)) END AS OrderYear,
    SUM(soh.TotalDue) AS TotalSales,
    -- GROUPING functions return 1 when the column is aggregated in that row
    GROUPING(st.Name) AS TerritoryGrouping,    -- 1 when Territory is aggregated
    GROUPING(pc.Name) AS CategoryGrouping,    -- 1 when Category is aggregated
    GROUPING(YEAR(soh.OrderDate)) AS YearGrouping  -- 1 when Year is aggregated
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY CUBE(st.Name, pc.Name, YEAR(soh.OrderDate))  -- CUBE generates all 8 possible combinations (2^3)
ORDER BY 
    -- Order by grouping status first, then by dimension values
    GROUPING(st.Name), st.Name,
    GROUPING(pc.Name), pc.Name,
    GROUPING(YEAR(soh.OrderDate)), YEAR(soh.OrderDate);



-- ROLLUP creates hierarchical subtotals from most detailed to grand total
-- This example shows sales by year > quarter > month with automatic subtotals

SELECT
    YEAR(soh.OrderDate) AS OrderYear,                     -- Year level
    DATEPART(QUARTER, soh.OrderDate) AS OrderQuarter,     -- Quarter level
    MONTH(soh.OrderDate) AS OrderMonth,                   -- Month level
    SUM(soh.TotalDue) AS TotalSales,                      -- Sum of sales for each group
    -- GROUPING_ID provides a bitmask of which columns are aggregated (for programmatic use)
    GROUPING_ID(YEAR(soh.OrderDate), DATEPART(QUARTER, soh.OrderDate), MONTH(soh.OrderDate)) AS GroupingLevel
FROM Sales.SalesOrderHeader soh
GROUP BY ROLLUP(
    YEAR(soh.OrderDate),                     -- Year level (will generate subtotals by year)
    DATEPART(QUARTER, soh.OrderDate),        -- Quarter level (within each year)
    MONTH(soh.OrderDate)                     -- Month level (within each quarter)
)
ORDER BY 
    -- Maintain the hierarchy in the output
    YEAR(soh.OrderDate),
    DATEPART(QUARTER, soh.OrderDate),
    MONTH(soh.OrderDate);




-- PIVOT transforms rows into columns, creating a cross-tab report
-- This query shows sales by product category with years as columns

SELECT CategoryName, [2011], [2012], [2013], [2014]  -- Column headers become years
FROM (
    -- Source data: category names, years, and sales amounts
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
    SUM(TotalDue)  -- Aggregation function for the values
    FOR OrderYear IN ([2011], [2012], [2013], [2014])  -- Values to transform into columns
) AS PivotTable
ORDER BY CategoryName;  -- Sort by category name



-- This query compares each product's sales to its category average
-- Demonstrates combining GROUP BY with window functions

SELECT 
    p.ProductID,
    p.Name AS ProductName,
    pc.Name AS CategoryName,
    SUM(sod.LineTotal) AS ProductSales,  -- Total sales for this product
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,  -- Number of orders containing this product
    
    -- Window function: Calculate average sales for the entire category
    AVG(SUM(sod.LineTotal)) OVER (PARTITION BY pc.Name) AS AvgCategorySales,
    
    -- Calculate this product's sales as percentage of category average
    SUM(sod.LineTotal) / AVG(SUM(sod.LineTotal)) OVER (PARTITION BY pc.Name) * 100 AS PercentOfCategoryAvg
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY p.ProductID, p.Name, pc.Name  -- Standard GROUP BY
ORDER BY pc.Name, ProductSales DESC;   -- Sort by category then by sales descending



-- This query identifies products that account for the top 80% of sales in each category
-- Demonstrates advanced window function techniques

WITH CategorySales AS (
    -- First, calculate product sales within each category
    SELECT 
        pc.Name AS CategoryName,
        p.ProductID,
        p.Name AS ProductName,
        SUM(sod.LineTotal) AS ProductSales,
        -- Total sales for the entire category
        SUM(SUM(sod.LineTotal)) OVER (PARTITION BY pc.Name) AS CategoryTotal,
        -- Running total of sales, ordered from highest to lowest
        SUM(SUM(sod.LineTotal)) OVER (PARTITION BY pc.Name ORDER BY SUM(sod.LineTotal) DESC 
                                     ROWS UNBOUNDED PRECEDING) AS RunningTotal
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
    GROUP BY pc.Name, p.ProductID, p.Name
)
-- Select only products that fall within the top 80% of category sales
SELECT 
    CategoryName,
    ProductName,
    ProductSales,
    -- Product's percentage of total category sales
    ProductSales/CategoryTotal*100 AS PercentOfCategory,
    -- Cumulative percentage up to this product
    RunningTotal/CategoryTotal*100 AS CumulativePercent
FROM CategorySales
-- Include products until we reach 80% of category sales
WHERE RunningTotal <= CategoryTotal * 0.8 OR
      -- Also include the product that pushes us over 80% if needed
      (RunningTotal - ProductSales) <= CategoryTotal * 0.8
ORDER BY CategoryName, ProductSales DESC;



-- This query segments customers based on their order frequency
-- Demonstrates dynamic grouping with CASE expressions

SELECT
    -- Dynamic segmentation based on order count
    CASE
        WHEN TotalOrders BETWEEN 1 AND 3 THEN 'Occasional (1-3 orders)'
        WHEN TotalOrders BETWEEN 4 AND 10 THEN 'Regular (4-10 orders)'
        WHEN TotalOrders > 10 THEN 'Frequent (10+ orders)'
        ELSE 'Other'
    END AS CustomerSegment,
    -- Metrics for each segment
    COUNT(CustomerID) AS CustomerCount,  -- Number of customers in segment
    AVG(TotalSpent) AS AvgSpent,        -- Average spending per customer
    SUM(TotalSpent) AS SegmentTotal,    -- Total revenue from segment
    -- Segment's percentage of total company revenue
    SUM(TotalSpent) / (SELECT SUM(TotalDue) FROM Sales.SalesOrderHeader) * 100 AS PercentOfTotalSales
FROM (
    -- First, calculate order counts and total spending per customer
    SELECT
        c.CustomerID,
        COUNT(DISTINCT soh.SalesOrderID) AS TotalOrders,
        SUM(soh.TotalDue) AS TotalSpent
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID
) AS CustomerStats
-- Group by our dynamic segments
GROUP BY 
    CASE
        WHEN TotalOrders BETWEEN 1 AND 3 THEN 'Occasional (1-3 orders)'
        WHEN TotalOrders BETWEEN 4 AND 10 THEN 'Regular (4-10 orders)'
        WHEN TotalOrders > 10 THEN 'Frequent (10+ orders)'
        ELSE 'Other'
    END
ORDER BY SegmentTotal DESC;  -- Sort by most valuable segments first
