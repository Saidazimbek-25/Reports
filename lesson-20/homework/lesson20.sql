-- 1. Find customers who purchased at least one item in March 2024 using EXISTS
SELECT DISTINCT CustomerName
FROM #Sales s
WHERE EXISTS (
    SELECT 1
    FROM #Sales
    WHERE SaleDate BETWEEN '2024-03-01' AND '2024-03-31' AND CustomerName = s.CustomerName
);

-- 2. Find the product with the highest total sales revenue using a subquery
SELECT Product
FROM #Sales
GROUP BY Product
HAVING SUM(Quantity * Price) = (
    SELECT MAX(SUM(Quantity * Price))
    FROM #Sales
    GROUP BY Product
);

-- 3. Find the second highest sale amount using a subquery
SELECT MAX(SaleAmount) AS SecondHighestSale
FROM #Sales
WHERE SaleAmount < (
    SELECT MAX(SaleAmount) FROM #Sales
);

-- 4. Find the total quantity of products sold per month using a subquery
SELECT EXTRACT(MONTH FROM SaleDate) AS Month, SUM(Quantity) AS TotalQuantity
FROM #Sales
GROUP BY EXTRACT(MONTH FROM SaleDate);

-- 5. Find customers who bought the same products as another customer using EXISTS
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.CustomerName != s2.CustomerName
    AND s1.Product = s2.Product
);

-- 6. Return how many fruits each person has in individual fruit level
SELECT Name,
       SUM(CASE WHEN Fruit = 'Apple' THEN 1 ELSE 0 END) AS Apple,
       SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange,
       SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name;

-- 7. Return older people in the family with younger ones
SELECT f1.ParentId AS PID, f1.ChildID AS CHID
FROM Family f1, Family f2
WHERE f1.ParentId = f2.ParentId AND f1.ChildID != f2.ChildID;

-- 8. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas
SELECT o.CustomerID, o.OrderID, o.DeliveryState, o.Amount
FROM #Orders o
WHERE o.CustomerID IN (SELECT CustomerID FROM #Orders WHERE DeliveryState = 'CA')
AND o.DeliveryState = 'TX';

-- 9. Insert the names of residents if they are missing
UPDATE #residents
SET fullname = CASE
    WHEN fullname NOT LIKE '%name%' THEN CONCAT(SUBSTRING(fullname, 1, CHARINDEX('age', fullname)-1), 'name=', SUBSTRING(fullname, CHARINDEX('age', fullname), LEN(fullname)))
    ELSE fullname
END;

-- 10. Write a query to return the route to reach from Tashkent to Khorezm, including the cheapest and the most expensive routes
WITH RouteCosts AS (
    SELECT DepartureCity, ArrivalCity, Cost, 
           ROW_NUMBER() OVER (ORDER BY Cost ASC) AS CheapRoute, 
           ROW_NUMBER() OVER (ORDER BY Cost DESC) AS ExpensiveRoute
    FROM #Routes 
    WHERE DepartureCity = 'Tashkent' AND ArrivalCity = 'Khorezm'
)
SELECT DepartureCity + ' - ' + ArrivalCity AS Route, Cost
FROM RouteCosts
WHERE CheapRoute = 1 OR ExpensiveRoute = 1;

-- 11. Rank products based on their order of insertion
SELECT ID, Vals, ROW_NUMBER() OVER (ORDER BY ID) AS Rank
FROM #RankingPuzzle;

-- 12. Find employees whose sales were higher than the average sales in their department
SELECT EmployeeName
FROM #EmployeeSales e
WHERE SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales
    WHERE Department = e.Department
);

-- 13. Find employees who had the highest sales in any given month using EXISTS
SELECT DISTINCT EmployeeName
FROM #EmployeeSales e
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales
    WHERE SalesAmount = (SELECT MAX(SalesAmount) FROM #EmployeeSales WHERE SalesMonth = e.SalesMonth)
    AND EmployeeName = e.EmployeeName
);

-- 14. Find employees who made sales in every month using NOT EXISTS
SELECT EmployeeName
FROM #EmployeeSales e
WHERE NOT EXISTS (
    SELECT 1
    FROM (SELECT DISTINCT SalesMonth FROM #EmployeeSales) m
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales e2
        WHERE e2.EmployeeName = e.EmployeeName AND e2.SalesMonth = m.SalesMonth
    )
);

-- 15. Retrieve the names of products that are more expensive than the average price of all products
SELECT Name
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

-- 16. Find the products that have a stock count lower than the highest stock count
SELECT Name
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);

-- 17. Get the names of products that belong to the same category as 'Laptop'
SELECT Name
FROM Products
WHERE Category = (SELECT Category FROM Products WHERE Name = 'Laptop');

-- 18. Retrieve products whose price is greater than the lowest price in the Electronics category
SELECT Name
FROM Products
WHERE Price > (SELECT MIN(Price) FROM Products WHERE Category = 'Electronics');

-- 19. Find the products that have a higher price than the average price of their respective category
SELECT Name
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
    WHERE Category = Products.Category
);

-- 20. Find the products that have been ordered at least once
SELECT DISTINCT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID;

-- 21. Retrieve the names of products that have been ordered more than the average quantity ordered
SELECT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
HAVING SUM(o.Quantity) > (SELECT AVG(SUM(o.Quantity)) FROM Orders o GROUP BY o.ProductID);

-- 22. Find the products that have never been ordered
SELECT Name
FROM Products
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM Orders);

-- 23. Retrieve the product with the highest total quantity ordered
SELECT TOP 1 p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
ORDER BY SUM(o.Quantity) DESC;
