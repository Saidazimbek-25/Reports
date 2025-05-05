-- Puzzle 1: Extracting the month (with leading zero) from datetime
SELECT Id, Dt, 
       RIGHT('0' + CAST(MONTH(Dt) AS VARCHAR(2)), 2) AS MonthPrefixedWithZero
FROM Dates;

-- Puzzle 2: Unique Ids and sum of max values of Vals for each Id and rID
SELECT COUNT(DISTINCT Id) AS Distinct_Ids, rID, 
       SUM(MaxVals) AS TotalOfMaxVals
FROM (
    SELECT Id, rID, MAX(Vals) AS MaxVals
    FROM MyTabel
    GROUP BY Id, rID
) AS MaxValsPerGroup
GROUP BY rID;

-- Puzzle 3: Finding records with lengths between 6 and 10 characters
SELECT Id, Vals
FROM TestFixLengths
WHERE LEN(Vals) BETWEEN 6 AND 10;

-- Puzzle 4: Finding the item with maximum value for each ID in a single query
SELECT ID, Item, Vals
FROM (
    SELECT ID, Item, Vals, 
           ROW_NUMBER() OVER (PARTITION BY ID ORDER BY Vals DESC) AS rn
    FROM TestMaximum
) AS RankedItems
WHERE rn = 1;

-- Puzzle 5: Summing the maximum Vals per Id and DetailedNumber
SELECT Id, SUM(MaxVals) AS SumofMax
FROM (
    SELECT Id, DetailedNumber, MAX(Vals) AS MaxVals
    FROM SumOfMax
    GROUP BY Id, DetailedNumber
) AS MaxValsPerDetail
GROUP BY Id;

-- Puzzle 6: Finding the difference between a and b columns and replacing 0 with blank
SELECT Id, a, b, 
       CASE 
           WHEN a - b = 0 THEN NULL 
           ELSE a - b 
       END AS OUTPUT
FROM TheZeroPuzzle;

-- Sales Query 1: Total revenue generated from all sales
SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales;

-- Sales Query 2: Average unit price of products
SELECT AVG(UnitPrice) AS AvgUnitPrice
FROM Sales;

-- Sales Query 3: Count of sales transactions
SELECT COUNT(*) AS SalesTransactionCount
FROM Sales;

-- Sales Query 4: Highest number of units sold in a single transaction
SELECT MAX(QuantitySold) AS MaxUnitsSold
FROM Sales;

-- Sales Query 5: Count of products sold in each category
SELECT Category, SUM(QuantitySold) AS TotalSold
FROM Sales
GROUP BY Category;

-- Sales Query 6: Total revenue for each region
SELECT Region, SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Region;

-- Sales Query 7: Total quantity sold per month
SELECT MONTH(SaleDate) AS Month, SUM(QuantitySold) AS TotalQuantitySold
FROM Sales
GROUP BY MONTH(SaleDate);

-- Sales Query 8: Product with highest total revenue
SELECT TOP 1 Product, SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;

-- Sales Query 9: Running total of revenue ordered by sale date
SELECT SaleDate, SUM(QuantitySold * UnitPrice) OVER (ORDER BY SaleDate) AS RunningTotalRevenue
FROM Sales
ORDER BY SaleDate;

-- Sales Query 10: Contribution of each category to total sales revenue
SELECT Category, 
       SUM(QuantitySold * UnitPrice) * 100.0 / (SELECT SUM(QuantitySold * UnitPrice) FROM Sales) AS RevenuePercentage
FROM Sales
GROUP BY Category;

-- Customers Query 1: Show all sales along with corresponding customer names
SELECT s.SaleID, s.Product, s.Category, s.QuantitySold, s.UnitPrice, s.SaleDate, s.Region, c.CustomerName
FROM Sales s
JOIN Customers c ON c.Region = s.Region;

-- Customers Query 2: List customers who have not made any purchases
SELECT CustomerID, CustomerName, Region
FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Sales);

-- Customers Query 3: Total revenue generated from each customer
SELECT c.CustomerID, c.CustomerName, SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Sales s
JOIN Customers c ON c.Region = s.Region
GROUP BY c.CustomerID, c.CustomerName;

-- Customers Query 4: Customer who contributed the most revenue
SELECT TOP 1 c.CustomerID, c.CustomerName, SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Sales s
JOIN Customers c ON c.Region = s.Region
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalRevenue DESC;

-- Customers Query 5: Total sales per customer per month
SELECT c.CustomerID, c.CustomerName, MONTH(s.SaleDate) AS Month, SUM(s.QuantitySold * s.UnitPrice) AS TotalSales
FROM Sales s
JOIN Customers c ON c.Region = s.Region
GROUP BY c.CustomerID, c.CustomerName, MONTH(s.SaleDate);

-- Products Query 1: List all products that have been sold at least once
SELECT DISTINCT p.ProductName
FROM Products p
JOIN Sales s ON s.Product = p.ProductName;

-- Products Query 2: Find the most expensive product in the Products table
SELECT TOP 1 ProductName, SellingPrice
FROM Products
ORDER BY SellingPrice DESC;

-- Products Query 3: Show each sale with its corresponding cost price from the Products table
SELECT s.SaleID, s.Product, s.QuantitySold, s.UnitPrice, p.CostPrice
FROM Sales s
JOIN Products p ON s.Product = p.ProductName;

-- Products Query 4: Find all products where the selling price is greater than $500
SELECT ProductName
FROM Products
WHERE SellingPrice > 500;
