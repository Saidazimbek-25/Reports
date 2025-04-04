-- Task 1: INNER JOIN
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- Task 2: LEFT JOIN
SELECT s.StudentName, c.ClassName
FROM Students s
LEFT JOIN Classes c ON s.ClassID = c.ClassID;

-- Task 3: RIGHT JOIN
SELECT c.CustomerName, o.OrderID, o.OrderDate
FROM Orders o
RIGHT JOIN Customers c ON o.CustomerID = c.CustomerID;

-- Task 4: FULL OUTER JOIN
SELECT p.ProductName, s.Quantity
FROM Products p
FULL OUTER JOIN Sales s ON p.ProductID = s.ProductID;

-- Task 5: SELF JOIN
SELECT e.Name AS EmployeeName, m.Name AS ManagerName
FROM Employees e
LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID;

-- Task 6: CROSS JOIN
SELECT c.ColorName, s.SizeName
FROM Colors c
CROSS JOIN Sizes s;

-- Task 7: JOIN with WHERE clause
SELECT m.Title, m.ReleaseYear, a.Name AS ActorName
FROM Movies m
JOIN Actors a ON m.MovieID = a.MovieID
WHERE m.ReleaseYear > 2015;

-- Task 8: MULTIPLE JOINS
SELECT o.OrderDate, c.CustomerName, od.ProductID
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID;

-- Task 9: JOIN with Aggregation
SELECT p.ProductName, SUM(s.Quantity * p.Price) AS TotalRevenue
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.ProductName;
