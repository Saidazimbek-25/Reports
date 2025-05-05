-- 1. Create a numbers table using a recursive query from 1 to 1000.
WITH Numbers AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number + 1 FROM Numbers WHERE Number < 1000
)
SELECT * FROM Numbers;

-- 2. Find the total sales per employee using a derived table.
SELECT e.EmployeeID, e.FirstName, e.LastName, TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) AS TotalSalesPerEmployee ON e.EmployeeID = TotalSalesPerEmployee.EmployeeID;

-- 3. Create a CTE to find the average salary of employees.
WITH AvgSalary AS (
    SELECT AVG(Salary) AS AverageSalary
    FROM Employees
)
SELECT * FROM AvgSalary;

-- 4. Find the highest sales for each product using a derived table.
SELECT p.ProductName, s.MaxSales
FROM Products p
JOIN (
    SELECT ProductID, MAX(SalesAmount) AS MaxSales
    FROM Sales
    GROUP BY ProductID
) AS MaxSalesPerProduct ON p.ProductID = MaxSalesPerProduct.ProductID;

-- 5. Double the number for each record, the max value you get should be less than 1000000.
WITH RecursiveDoubles AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number * 2 FROM RecursiveDoubles WHERE Number * 2 < 1000000
)
SELECT * FROM RecursiveDoubles;

-- 6. Get the names of employees who have made more than 5 sales using a CTE.
WITH SalesCount AS (
    SELECT EmployeeID, COUNT(*) AS SalesMade
    FROM Sales
    GROUP BY EmployeeID
    HAVING COUNT(*) > 5
)
SELECT e.FirstName, e.LastName
FROM Employees e
JOIN SalesCount sc ON e.EmployeeID = sc.EmployeeID;

-- 7. Find all products with sales greater than $500 using a CTE.
WITH ProductsWithSales AS (
    SELECT s.ProductID, SUM(s.SalesAmount) AS TotalSales
    FROM Sales s
    GROUP BY s.ProductID
    HAVING SUM(s.SalesAmount) > 500
)
SELECT p.ProductName, p.Price
FROM Products p
JOIN ProductsWithSales ps ON p.ProductID = ps.ProductID;

-- 8. Find employees with salaries above the average salary using a CTE.
WITH AvgSalary AS (
    SELECT AVG(Salary) AS AverageSalary
    FROM Employees
)
SELECT e.FirstName, e.LastName, e.Salary
FROM Employees e
JOIN AvgSalary AS a ON e.Salary > a.AverageSalary;

-- Medium Tasks

-- 9. Find the top 5 employees by the number of orders made using a derived table.
SELECT TOP 5 e.EmployeeID, e.FirstName, e.LastName, SalesCount
FROM Employees e
JOIN (
    SELECT EmployeeID, COUNT(*) AS SalesCount
    FROM Sales
    GROUP BY EmployeeID
) AS SalesCountPerEmployee ON e.EmployeeID = SalesCountPerEmployee.EmployeeID
ORDER BY SalesCount DESC;

-- 10. Find the sales per product category using a derived table.
SELECT p.CategoryID, SUM(s.SalesAmount) AS TotalSales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.CategoryID;

-- 11. Return the factorial of each value next to it (from Numbers1).
WITH RecursiveFactorial AS (
    SELECT Number, 1 AS Factorial
    FROM Numbers1 WHERE Number = 1
    UNION ALL
    SELECT n.Number, n.Number * rf.Factorial
    FROM Numbers1 n
    JOIN RecursiveFactorial rf ON n.Number = rf.Number + 1
)
SELECT * FROM RecursiveFactorial;

-- 12. Split a string into rows of substrings for each character in the string (from Example).
WITH StringSplit AS (
    SELECT Id, SUBSTRING(String, Number, 1) AS Character
    FROM Example
    JOIN Numbers1 n ON n.Number <= LEN(String)
)
SELECT * FROM StringSplit;

-- 13. Calculate the sales difference between the current month and the previous month using a CTE.
WITH MonthlySales AS (
    SELECT
        EmployeeID,
        SUM(SalesAmount) AS SalesAmount,
        YEAR(SaleDate) AS SalesYear,
        MONTH(SaleDate) AS SalesMonth
    FROM Sales
    GROUP BY EmployeeID, YEAR(SaleDate), MONTH(SaleDate)
)
SELECT 
    m1.EmployeeID,
    m1.SalesYear,
    m1.SalesMonth,
    m1.SalesAmount - ISNULL(m2.SalesAmount, 0) AS SalesDifference
FROM MonthlySales m1
LEFT JOIN MonthlySales m2 ON m1.EmployeeID = m2.EmployeeID AND m1.SalesYear = m2.SalesYear AND m1.SalesMonth = m2.SalesMonth + 1;

-- 14. Find employees with sales over $45,000 in each quarter using a derived table.
SELECT e.EmployeeID, e.FirstName, e.LastName, SUM(s.SalesAmount) AS TotalSales
FROM Employees e
JOIN Sales s ON e.EmployeeID = s.EmployeeID
WHERE YEAR(s.SaleDate) = 2025
GROUP BY e.EmployeeID, e.FirstName, e.LastName, DATEPART(QUARTER, s.SaleDate)
HAVING SUM(s.SalesAmount) > 45000;

-- Difficult Tasks

-- 15. Calculate Fibonacci numbers using recursion.
WITH RecursiveFibonacci AS (
    SELECT 1 AS FibonacciValue, 1 AS FibonacciIndex
    UNION ALL
    SELECT f.FibonacciValue + f2.FibonacciValue, f.FibonacciIndex + 1
    FROM RecursiveFibonacci f
    JOIN RecursiveFibonacci f2 ON f.FibonacciIndex = f2.FibonacciIndex - 1
    WHERE f.FibonacciIndex < 20
)
SELECT * FROM RecursiveFibonacci;

-- 16. Find a string where all characters are the same and the length is greater than 1 (from FindSameCharacters).
SELECT Id, Vals
FROM FindSameCharacters
WHERE LEN(Vals) > 1 AND Vals LIKE REPLICATE(SUBSTRING(Vals, 1, 1), LEN(Vals));

-- 17. Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence (from Example).
WITH RecursiveNumbers AS (
    SELECT 1 AS Number, '1' AS Sequence
    UNION ALL
    SELECT n.Number + 1, Sequence + CAST(n.Number + 1 AS VARCHAR)
    FROM RecursiveNumbers n
    WHERE n.Number < 5
)
SELECT * FROM RecursiveNumbers;

-- 18. Find the employees who have made the most sales in the last 6 months using a derived table.
SELECT e.EmployeeID, e.FirstName, e.LastName, COUNT(s.SalesID) AS TotalSales
FROM Employees e
JOIN Sales s ON e.EmployeeID = s.EmployeeID
WHERE s.SaleDate >= DATEADD(MONTH, -6, GETDATE())
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalSales DESC
LIMIT 1;

-- 19. Remove the duplicate integer values present in the string column. Additionally, remove the single integer character that appears in the string (from RemoveDuplicateIntsFromNames).
WITH RemoveDuplicates AS (
    SELECT PawanName,
           Pawan_slug_name,
           REPLACE(Pawan_slug_name, CAST(PawanName AS VARCHAR), '') AS CleanedName
    FROM RemoveDuplicateIntsFromNames
)
SELECT * FROM RemoveDuplicates;
