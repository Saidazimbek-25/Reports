-- 1. INNER JOIN Employees and Departments, filtering employees with salary > 5000
SELECT e.Name AS EmployeeName, e.Salary, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 5000;

-- 2. INNER JOIN Customers and Orders, filtering orders placed in 2023
SELECT c.CustomerName, o.OrderID, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2023;

-- 3. LEFT OUTER JOIN Employees and Departments (show all employees including those without a department)
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- 4. RIGHT OUTER JOIN Products and Suppliers (show all suppliers including those without products)
SELECT s.SupplierName, p.ProductName
FROM Products p
RIGHT JOIN Suppliers s ON p.SupplierID = s.SupplierID;

-- 5. FULL OUTER JOIN Orders and Payments (show all orders and corresponding payments, including unmatched ones)
SELECT o.OrderID, p.PaymentID, o.OrderDate, p.PaymentAmount
FROM Orders o
FULL OUTER JOIN Payments p ON o.OrderID = p.OrderID;

-- 6. SELF JOIN on Employees to display employees and their respective managers
SELECT e1.Name AS EmployeeName, e2.Name AS ManagerName
FROM Employees e1
LEFT JOIN Employees e2 ON e1.ManagerID = e2.EmployeeID;

-- 7. Logical order of SQL execution: JOIN Products and Sales, filter sales > 100
SELECT p.ProductName, s.TotalSales
FROM Products p
INNER JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.TotalSales > 100;

-- 8. INNER JOIN Students and Courses, filtering students enrolled in 'Math 101'
SELECT s.StudentName, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName = 'Math 101';

-- 9. INNER JOIN Customers and Orders, filtering customers with more than 3 orders
SELECT c.CustomerName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName
HAVING COUNT(o.OrderID) > 3;

-- 10. LEFT OUTER JOIN Employees and Departments, filtering employees in the 'HR' department
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'HR';
