-- 1. INNER JOIN with AND in the ON clause
SELECT o.*, c.*
FROM Orders o
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID AND o.OrderDate > '2022-12-31';

-- 2. JOIN using OR in the ON clause (Employees and Departments)
SELECT e.*, d.*
FROM Employees e
JOIN Departments d
    ON e.DepartmentID = d.DepartmentID AND (d.DepartmentName = 'Sales' OR d.DepartmentName = 'Marketing');

-- 3. Join a derived table with Orders
SELECT p.*, o.*
FROM (SELECT * FROM Products WHERE Price > 100) AS p
JOIN Orders o
    ON p.ProductID = o.ProductID;

-- 4. Join Temp table with Orders
SELECT o.*
FROM Temp_Orders t
JOIN Orders o
    ON t.OrderID = o.OrderID;

-- 5. CROSS APPLY (Employees and department's top 5 sales)
SELECT e.*, s.*
FROM Employees e
CROSS APPLY (
    SELECT TOP 5 * 
    FROM Sales s 
    WHERE s.DepartmentID = e.DepartmentID 
    ORDER BY s.SaleAmount DESC
) AS s;

-- 6. JOIN with AND to filter Gold customers with 2023 orders
SELECT c.*, o.*
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID AND o.OrderDate BETWEEN '2023-01-01' AND '2023-12-31' AND c.LoyaltyStatus = 'Gold';

-- 7. Join derived table (order count) with Customers
SELECT c.*, o.OrderCount
FROM Customers c
JOIN (
    SELECT CustomerID, COUNT(*) AS OrderCount
    FROM Orders
    GROUP BY CustomerID
) AS o
    ON c.CustomerID = o.CustomerID;

-- 8. JOIN with OR in ON clause (Products and Suppliers)
SELECT p.*, s.*
FROM Products p
JOIN Suppliers s
    ON p.SupplierID = s.SupplierID AND (s.SupplierName = 'Supplier A' OR s.SupplierName = 'Supplier B');

-- 9. OUTER APPLY to get most recent order per employee
SELECT e.*, o.*
FROM Employees e
OUTER APPLY (
    SELECT TOP 1 * 
    FROM Orders o 
    WHERE o.EmployeeID = e.EmployeeID 
    ORDER BY o.OrderDate DESC
) AS o;

-- 10. CROSS APPLY with table-valued function
SELECT d.*, e.*
FROM Departments d
CROSS APPLY dbo.GetEmployeesByDepartment(d.DepartmentID) AS e;
