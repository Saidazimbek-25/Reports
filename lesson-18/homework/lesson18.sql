-- 1. Create a temporary table named MonthlySales to store the total quantity sold and total revenue for each product in the current month.
-- Return: ProductID, TotalQuantity, TotalRevenue
CREATE TABLE #MonthlySales AS
SELECT 
    S.ProductID,
    SUM(S.Quantity) AS TotalQuantity,
    SUM(S.Quantity * P.Price) AS TotalRevenue
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
WHERE YEAR(S.SaleDate) = YEAR(GETDATE()) AND MONTH(S.SaleDate) = MONTH(GETDATE())
GROUP BY S.ProductID;

-- 2. Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity across all time.
CREATE VIEW vw_ProductSalesSummary AS
SELECT 
    P.ProductID,
    P.ProductName,
    P.Category,
    SUM(S.Quantity) AS TotalQuantitySold
FROM Products P
LEFT JOIN Sales S ON P.ProductID = S.ProductID
GROUP BY P.ProductID, P.ProductName, P.Category;

-- 3. Create a function named fn_GetTotalRevenueForProduct(@ProductID INT) Return: total revenue for the given product ID
CREATE FUNCTION dbo.fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(10, 2);
    SELECT @TotalRevenue = SUM(S.Quantity * P.Price)
    FROM Sales S
    JOIN Products P ON S.ProductID = P.ProductID
    WHERE S.ProductID = @ProductID;
    RETURN @TotalRevenue;
END;

-- 4. Create a function fn_GetSalesByCategory(@Category VARCHAR(50)) Return: ProductName, TotalQuantity, TotalRevenue for all products in that category.
CREATE FUNCTION dbo.fn_GetSalesByCategory (@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN 
SELECT 
    P.ProductName,
    SUM(S.Quantity) AS TotalQuantity,
    SUM(S.Quantity * P.Price) AS TotalRevenue
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
WHERE P.Category = @Category
GROUP BY P.ProductName;

-- 5. Create a function that checks if a number is prime.
CREATE FUNCTION dbo.fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @Result VARCHAR(3) = 'Yes';
    IF @Number <= 1 
        SET @Result = 'No';
    ELSE
    BEGIN
        DECLARE @i INT = 2;
        WHILE @i <= SQRT(@Number)
        BEGIN
            IF @Number % @i = 0
            BEGIN
                SET @Result = 'No';
                BREAK;
            END
            SET @i = @i + 1;
        END
    END
    RETURN @Result;
END;

-- 6. Create a table-valued function to return numbers between two integers.
CREATE FUNCTION dbo.fn_GetNumbersBetween (@Start INT, @End INT)
RETURNS TABLE
AS
RETURN 
SELECT @Start AS Number
UNION ALL
SELECT Number + 1
FROM dbo.fn_GetNumbersBetween(@Start + 1, @End)
WHERE @Start < @End;

-- 7. Write a SQL query to return the Nth highest distinct salary from the Employee table.
CREATE FUNCTION dbo.getNthHighestSalary(@N INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @Salary DECIMAL(10, 2);
    WITH DistinctSalaries AS (
        SELECT DISTINCT Salary
        FROM Employee
        ORDER BY Salary DESC
    )
    SELECT @Salary = Salary
    FROM (SELECT ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum, Salary FROM DistinctSalaries) AS RankedSalaries
    WHERE RowNum = @N;
    RETURN @Salary;
END;

-- 8. Write a SQL query to find the person who has the most friends.
SELECT 
    RequesterId AS id, 
    COUNT(DISTINCT AccepterId) AS num
FROM RequestAccepted
GROUP BY RequesterId
HAVING COUNT(DISTINCT AccepterId) = (
    SELECT MAX(friend_count) 
    FROM (
        SELECT COUNT(DISTINCT AccepterId) AS friend_count 
        FROM RequestAccepted
        GROUP BY RequesterId
    ) AS max_friends
)
UNION
SELECT 
    AccepterId AS id, 
    COUNT(DISTINCT RequesterId) AS num
FROM RequestAccepted
GROUP BY AccepterId
HAVING COUNT(DISTINCT RequesterId) = (
    SELECT MAX(friend_count) 
    FROM (
        SELECT COUNT(DISTINCT RequesterId) AS friend_count 
        FROM RequestAccepted
        GROUP BY AccepterId
    ) AS max_friends
);

-- 9. Create a View for Customer Order Summary.
CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
    C.customer_id, 
    C.name, 
    COUNT(O.order_id) AS total_orders, 
    SUM(O.amount) AS total_amount, 
    MAX(O.order_date) AS last_order_date
FROM Customers C
JOIN Orders O ON C.customer_id = O.customer_id
GROUP BY C.customer_id, C.name;

-- 10. Write an SQL statement to fill in the missing gaps.
WITH CTE AS (
    SELECT RowNumber, Workflow, 
           LEAD(Workflow) OVER (ORDER BY RowNumber) AS next_workflow
    FROM Gaps
)
UPDATE G
SET Workflow = COALESCE(Workflow, next_workflow)
FROM Gaps G
JOIN CTE C ON G.RowNumber = C.RowNumber;
