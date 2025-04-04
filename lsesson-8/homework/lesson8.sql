-- 1. INNER JOIN Customers and Orders to get CustomerName and OrderDate
SELECT c.CustomerName, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 2. Demonstrate One-to-One relationship between EmployeeDetails and Employees
SELECT e.EmployeeID, e.Name, ed.Address, ed.Phone
FROM Employees e
INNER JOIN EmployeeDetails ed ON e.EmployeeID = ed.EmployeeID;

-- 3. INNER JOIN Products and Categories to show ProductName with CategoryName
SELECT p.ProductName, c.CategoryName
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID;

-- 4. LEFT JOIN Customers and Orders to show all Customers and corresponding OrderDate
SELECT c.CustomerName, o.OrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 5. Many-to-Many relationship between Orders and Products via OrderDetails
SELECT o.OrderID, p.ProductName, od.Quantity
FROM OrderDetails od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID;

-- 6. CROSS JOIN between Products and Categories (all possible combinations)
SELECT p.ProductName, c.CategoryName
FROM Products p
CROSS JOIN Categories c;

-- 7. Demonstrate One-to-Many relationship between Customers and Orders using INNER JOIN
SELECT c.CustomerName, o.OrderID, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 8. Filtered CROSS JOIN to show only Products and Orders where OrderAmount > 500
SELECT p.ProductName, o.OrderID, o.OrderAmount
FROM Products p
CROSS JOIN Orders o
WHERE o.OrderAmount > 500;

-- 9. INNER JOIN Employees and Departments to show employee names and department names
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- 10. Use ON clause with <> operator to return rows where values are not equal
SELECT a.Column1, b.Column2
FROM TableA a
INNER JOIN TableB b ON a.Column1 <> b.Column2;
