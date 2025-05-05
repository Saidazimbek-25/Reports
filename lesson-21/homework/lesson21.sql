-- Query 1: Assign a row number to each sale based on the SaleDate
SELECT 
    SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID,
    ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNumber
FROM ProductSales;

-- Query 2: Rank products based on the total quantity sold (use DENSE_RANK())
SELECT 
    ProductName,
    SUM(Quantity) AS TotalQuantity,
    DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS ProductRank
FROM ProductSales
GROUP BY ProductName;

-- Query 3: Identify the top sale for each customer based on the SaleAmount
WITH TopSales AS (
    SELECT 
        SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS RowNumber
    FROM ProductSales
)
SELECT * FROM TopSales WHERE RowNumber = 1;

-- Query 4: Display each sale's amount along with the next sale amount in the order of SaleDate using the LEAD() function
SELECT 
    SaleID, ProductName, SaleDate, SaleAmount,
    LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM ProductSales;

-- Query 5: Display each sale's amount along with the previous sale amount in the order of SaleDate using the LAG() function
SELECT 
    SaleID, ProductName, SaleDate, SaleAmount,
    LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PreviousSaleAmount
FROM ProductSales;

-- Query 6: Rank each sale amount within each product category
SELECT 
    SaleID, ProductName, SaleDate, SaleAmount,
    RANK() OVER (PARTITION BY ProductName ORDER BY SaleAmount DESC) AS SaleRank
FROM ProductSales;

-- Query 7: Identify sales amounts that are greater than the previous sale's amount
WITH SalesComparison AS (
    SELECT 
        SaleID, ProductName, SaleDate, SaleAmount,
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount
    FROM ProductSales
)
SELECT * FROM SalesComparison WHERE SaleAmount > PreviousSaleAmount;

-- Query 8: Calculate the difference in sale amount from the previous sale for every product
WITH SalesComparison AS (
    SELECT 
        SaleID, ProductName, SaleDate, SaleAmount,
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount
    FROM ProductSales
)
SELECT 
    SaleID, ProductName, SaleDate, SaleAmount,
    SaleAmount - PreviousSaleAmount AS SaleAmountDifference
FROM SalesComparison;

-- Query 9: Compare the current sale amount with the next sale amount in terms of percentage change
WITH SalesComparison AS (
    SELECT 
        SaleID, ProductName, SaleDate, SaleAmount,
        LEAD(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS NextSaleAmount
    FROM ProductSales
)
SELECT 
    SaleID, ProductName, SaleDate, SaleAmount,
    (NextSaleAmount - SaleAmount) / SaleAmount * 100 AS PercentageChange
FROM SalesComparison;

-- Query 10: Calculate the ratio of the current sale amount to the previous sale amount within the same product
WITH SalesComparison AS (
    SELECT 
        SaleID, ProductName, SaleDate, SaleAmount,
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount
    FROM ProductSales
)
SELECT 
    SaleID, ProductName, SaleDate, SaleAmount,
    SaleAmount / PreviousSaleAmount AS SaleAmountRatio
FROM SalesComparison;

-- Query 11: Calculate the difference in sale amount from the very first sale of that product
WITH FirstSale AS (
    SELECT 
        ProductName, MIN(SaleDate) AS FirstSaleDate
    FROM ProductSales
    GROUP BY ProductName
)
SELECT 
    ps.SaleID, ps.ProductName, ps.SaleDate, ps.SaleAmount,
    ps.SaleAmount - fs.FirstSaleAmount AS DifferenceFromFirstSale
FROM ProductSales ps
JOIN FirstSale fs
    ON ps.ProductName = fs.ProductName
    AND ps.SaleDate = fs.FirstSaleDate;

-- Query 12: Find sales that have been increasing continuously for a product
WITH SalesComparison AS (
    SELECT 
        SaleID, ProductName, SaleDate, SaleAmount,
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount
    FROM ProductSales
)
SELECT 
    SaleID, ProductName, SaleDate, SaleAmount
FROM SalesComparison
WHERE SaleAmount > PreviousSaleAmount;

-- Query 13: Calculate a "closing balance" for sales amounts which adds the current sale amount to a running total of previous sales
SELECT 
    SaleID, ProductName, SaleDate, SaleAmount,
    SUM(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS ClosingBalance
FROM ProductSales;

-- Query 14: Calculate the moving average of sales amounts over the last 3 sales
SELECT 
    SaleID, ProductName, SaleDate, SaleAmount,
    AVG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAverage
FROM ProductSales;

-- Query 15: Show the difference between each sale amount and the average sale amount
WITH AvgSale AS (
    SELECT AVG(SaleAmount) AS AvgSaleAmount FROM ProductSales
)
SELECT 
    ps.SaleID, ps.ProductName, ps.SaleDate, ps.SaleAmount,
    ps.SaleAmount - as.AvgSaleAmount AS DifferenceFromAverage
FROM ProductSales ps
CROSS JOIN AvgSale as;

-- Employees Table Queries

-- Query 1: Find Employees Who Have the Same Salary Rank
WITH EmployeeSalaryRank AS (
    SELECT 
        EmployeeID, Name, Department, Salary,
        DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM Employees1
)
SELECT e1.EmployeeID, e1.Name, e1.Salary
FROM EmployeeSalaryRank e1
JOIN EmployeeSalaryRank e2
    ON e1.SalaryRank = e2.SalaryRank AND e1.EmployeeID != e2.EmployeeID;

-- Query 2: Identify the Top 2 Highest Salaries in Each Department
SELECT 
    Department, Name, Salary
FROM (
    SELECT 
        Department, Name, Salary,
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
    FROM Employees1
) AS DepartmentSalaries
WHERE SalaryRank <= 2;

-- Query 3: Find the Lowest-Paid Employee in Each Department
SELECT 
    Department, Name, Salary
FROM (
    SELECT 
        Department, Name, Salary,
        RANK() OVER (PARTITION BY Department ORDER BY Salary ASC) AS SalaryRank
    FROM Employees1
) AS DepartmentSalaries
WHERE SalaryRank = 1;

-- Query 4: Calculate the Running Total of Salaries in Each Department
SELECT 
    EmployeeID, Name, Department, Salary,
    SUM(Salary) OVER (PARTITION BY Department ORDER BY HireDate) AS RunningTotalSalary
FROM Employees1;

-- Query 5: Find the Total Salary of Each Department Without GROUP BY
SELECT 
    Department, SUM(Salary) AS TotalSalary
FROM Employees1
WINDOW w AS (PARTITION BY Department)
SELECT Department, SUM(Salary) OVER w AS TotalSalary FROM Employees1;

-- Query 6: Calculate the Average Salary in Each Department Without GROUP BY
SELECT 
    Department, AVG(Salary) AS AverageSalary
FROM Employees1
WINDOW w AS (PARTITION BY Department)
SELECT Department, AVG(Salary) OVER w AS AverageSalary FROM Employees1;

-- Query 7: Find the Difference Between an Employee’s Salary and Their Department’s Average
WITH DepartmentAvg AS (
    SELECT Department, AVG(Salary) AS AvgSalary
    FROM Employees1
    GROUP BY Department
)
SELECT 
    e.EmployeeID, e.Name, e.Salary, da.AvgSalary,
    e.Salary - da.AvgSalary AS SalaryDifference
FROM Employees1 e
JOIN DepartmentAvg da ON e.Department = da.Department;

-- Query 8: Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
SELECT 
    EmployeeID, Name, Department, Salary,
    AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvgSalary
FROM Employees1;

-- Query 9: Find the Sum of Salaries for the Last 3 Hired Employees
SELECT 
    SUM(Salary) AS TotalSalaryForLast3
FROM (
    SELECT Salary
    FROM Employees1
    ORDER BY HireDate DESC
    LIMIT 3
) AS Last3Employees;
