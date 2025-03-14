
USE AdventureWorksDW2019;

SELECT*FROM DimProduct;--TO SEE THE RESULT

SELECT EnglishProductName AS Name FROM DimProduct;--change table name by using alias

SELECT*FROM DimCustomer AS CLIEANT;---NAMING CUSTOMER TABLE AS CLIENT TABLE 

SELECT EnglishProductName AS ALL_PRODUCTS FROM DimProduct
UNION-------------TO MERGE TABLES
SELECT ProductName FROM Products ;

SELECT EnglishProductName FROM DimProduct
INTERSECT
SELECT ProductName FROM Products;


-- Combine data from both tables while keeping duplicates
SELECT * FROM Products
UNION ALL
SELECT * FROM Orders;



EXEC sp_rename 'DimCustomer.FullName', 'CustomerName', 'COLUMN';---LEARNED NEW FUNCTION ON SQL AND PRACTICED IT

-- Select unique customer names and their respective countries
SELECT DISTINCT CustomerName, Country 
FROM DimCustomer;

-- Create a new column that categorizes prices into 'High' or 'Low'
SELECT ProductName,Price,
 CASE
      WHEN Price>=100 THEN 'HIGH'
	  ELSE 'LOW'
	   END AS PriceCategory
FROM Products;

---- FILTERING EMPLOYEES ACCORDING TO DEPARTMENT AND GROUPING THEM BY COUNTRY
SELECT EmployeeName,Department,Country,
FROM 
WHERE Department IN ('IT', 'HR')  
GROUP BY Country;

-- Count the number of products in each category
SELECT ID,COUNT(ID) AS ProductCount
FROM Products
GROUP BY ID;

-- Create a column that indicates if stock is high or low
SELECT ProductName, Stock, 
       IIF(Stock > 100, 'Yes', 'No') AS HighStock
FROM Products;

-- Join Orders and Customers tables and rename CustomerName as ClientName
SELECT O.OrderID, C.CustomerName AS ClientName
FROM Orders AS O
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID;

-- Combine product names from both tables, removing duplicates
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM OutOfStock;


-- Select products that exist in Products but NOT in DiscontinuedProducts
SELECT ProductName FROM Products
EXCEPT
SELECT ProductName FROM DiscontinuedProducts;

-- Categorize customers based on the number of orders they placed
SELECT CustomerID,
       CASE 
           WHEN COUNT(OrderID) > 5 THEN 'Eligible'
           ELSE 'Not Eligible'
       END AS CustomerStatus
FROM Orders
GROUP BY CustomerID;

-- Categorize products as 'Expensive' or 'Affordable' based on price
SELECT ProductName, Price,
       IIF(Price > 100, 'Expensive', 'Affordable') AS PriceCategory
FROM Products;

-- Count total orders for each customer
SELECT CustomerID, COUNT(OrderID) AS OrderCount
FROM Orders
GROUP BY CustomerID;

-- Select employees who are either younger than 25 or have a high salary
SELECT * FROM Employees
WHERE Age < 25 OR Salary > 6000;

-- Find total sales per region
SELECT Region, SUM(SalesAmount) AS TotalSales
FROM Sales
GROUP BY Region;

-- Left join Customers and Orders, renaming OrderDate
SELECT C.CustomerName, O.OrderDate AS PurchaseDate
FROM Customers AS C
LEFT JOIN Orders AS O ON C.CustomerID = O.CustomerID;

-- Increase salary by 10% for employees in HR
UPDATE Employees
SET Salary = Salary * 1.10
WHERE Department = 'HR';

SELECT 
    ProductID, 
    SUM(SalesAmount) AS TotalSales, 
    SUM(ReturnAmount) AS TotalReturns
FROM (
    SELECT ProductID, SalesAmount, 0 AS ReturnAmount FROM Sales
    UNION ALL
    SELECT ProductID, 0 AS SalesAmount, ReturnAmount FROM Returns
) AS CombinedData
GROUP BY ProductID;


-- Use INTERSECT to show products that are common between Products and DiscontinuedProducts tables.
SELECT ProductName FROM Products
INTERSECT
SELECT ProductName FROM DiscontinuedProducts;

SELECT 
    ProductID, 
    TotalSales,
    CASE 
        WHEN TotalSales > 10000 THEN 'Top Tier'
        WHEN TotalSales BETWEEN 5000 AND 10000 THEN 'Mid Tier'
        ELSE 'Low Tier'
    END AS SalesCategory
	FROM SALES

	-- Find customers who have placed orders but do not have a corresponding record in the Invoices table
SELECT CustomerID 
FROM Orders
EXCEPT
SELECT CustomerID 
FROM Invoices;

-- Group sales data by CustomerID, ProductID, and Region, and calculate total sales for each group
SELECT 
    CustomerID, 
    ProductID, 
    Region, 
    SUM(SalesAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID, ProductID, Region;

-- Apply discount based on the Quantity purchased
SELECT 
    OrderID, 
    CustomerID, 
    ProductID, 
    Quantity,
    CASE 
        WHEN Quantity >= 100 THEN 20  -- 20% discount for 100 or more items
        WHEN Quantity BETWEEN 50 AND 99 THEN 10  -- 10% discount for 50 to 99 items
        WHEN Quantity BETWEEN 10 AND 49 THEN 5  -- 5% discount for 10 to 49 items
        ELSE 0  -- No discount for less than 10 items
    END AS Discount
FROM Orders;

-- Return all products from Products and DiscontinuedProducts tables with stock status
SELECT 
    p.ProductID, 
    p.ProductName, 
    'In Stock' AS StockStatus
FROM Products p
INNER JOIN Inventory i ON p.ProductID = i.ProductID

UNION

SELECT 
    dp.ProductID, 
    dp.ProductName, 
    'Discontinued' AS StockStatus
FROM DiscontinuedProducts dp
INNER JOIN Inventory i ON dp.ProductID = i.ProductID;


-- Use EXCEPT to find customers in Customers table who are not in the VIP_Customers table based on CustomerID
SELECT CustomerID FROM Customers
EXCEPT
SELECT CustomerID FROM VIP_Customers;

SELECT 
    ProductID, 
    ProductName, 
    Stock, 
    IIF(Stock > 0, 'Available', 'Out of Stock') AS StockStatus
FROM Products;
