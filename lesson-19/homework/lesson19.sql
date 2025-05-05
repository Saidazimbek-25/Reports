-- Part 1: Stored Procedure Tasks

-- Task 1: Stored Procedure to create #EmployeeBonus temp table and calculate bonus
CREATE PROCEDURE CalculateEmployeeBonus
AS
BEGIN
    -- Create a temporary table
    CREATE TABLE #EmployeeBonus (
        EmployeeID INT,
        FullName NVARCHAR(100),
        Department NVARCHAR(50),
        Salary DECIMAL(10, 2),
        BonusAmount DECIMAL(10, 2)
    );

    -- Insert data into the temporary table
    INSERT INTO #EmployeeBonus (EmployeeID, FullName, Department, Salary, BonusAmount)
    SELECT 
        E.EmployeeID,
        E.FirstName + ' ' + E.LastName AS FullName,
        E.Department,
        E.Salary,
        E.Salary * DB.BonusPercentage / 100 AS BonusAmount
    FROM Employees E
    JOIN DepartmentBonus DB ON E.Department = DB.Department;

    -- Select all data from the temp table
    SELECT * FROM #EmployeeBonus;

    -- Drop the temp table
    DROP TABLE #EmployeeBonus;
END;

-- Task 2: Stored Procedure to update salary by department and increase percentage
CREATE PROCEDURE UpdateEmployeeSalaryByDepartment 
    @Department NVARCHAR(50),
    @IncreasePercentage DECIMAL(5,2)
AS
BEGIN
    -- Update salary
    UPDATE E
    SET E.Salary = E.Salary * (1 + @IncreasePercentage / 100)
    FROM Employees E
    WHERE E.Department = @Department;

    -- Return updated employees
    SELECT EmployeeID, FirstName, LastName, Department, Salary 
    FROM Employees 
    WHERE Department = @Department;
END;

-- Part 2: MERGE Tasks

-- Task 3: MERGE operation to update, insert, or delete products
MERGE INTO Products_Current AS Target
USING Products_New AS Source
ON Target.ProductID = Source.ProductID
-- Update ProductName and Price if ProductID matches
WHEN MATCHED THEN
    UPDATE SET Target.ProductName = Source.ProductName, Target.Price = Source.Price
-- Insert new products if ProductID does not exist
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price) 
    VALUES (Source.ProductID, Source.ProductName, Source.Price)
-- Delete products from Products_Current if they are missing in Products_New
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

-- Return the final state of Products_Current
SELECT * FROM Products_Current;

-- Task 4: Reporting the type of each node in a tree
SELECT 
    T.id,
    CASE 
        WHEN T.p_id IS NULL THEN 'Root'  -- Root node
        WHEN NOT EXISTS (SELECT 1 FROM Tree WHERE p_id = T.id) THEN 'Leaf'  -- Leaf node
        ELSE 'Inner'  -- Inner node
    END AS type
FROM Tree T;

-- Task 5: Finding confirmation rate for each user
SELECT 
    S.user_id,
    COALESCE(SUM(CASE WHEN C.action = 'confirmed' THEN 1 ELSE 0 END) * 1.0 / COUNT(C.action), 0) AS confirmation_rate
FROM Signups S
LEFT JOIN Confirmations C ON S.user_id = C.user_id
GROUP BY S.user_id;

-- Task 6: Find employees with the lowest salary using subqueries
SELECT id, name, salary
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

-- Task 7: Stored Procedure to get Product Sales Summary
CREATE PROCEDURE GetProductSalesSummary 
    @ProductID INT
AS
BEGIN
    SELECT 
        P.ProductName,
        COALESCE(SUM(S.Quantity), 0) AS TotalQuantitySold,
        COALESCE(SUM(S.Quantity * P.Price), 0) AS TotalSalesAmount,
        COALESCE(MIN(S.SaleDate), NULL) AS FirstSaleDate,
        COALESCE(MAX(S.SaleDate), NULL) AS LastSaleDate
    FROM Products P
    LEFT JOIN Sales S ON P.ProductID = S.ProductID
    WHERE P.ProductID = @ProductID
    GROUP BY P.ProductName;
END;
