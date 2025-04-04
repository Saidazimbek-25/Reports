-- 1. Minimum product price
SELECT MIN(Price) AS Min_Price FROM Products;

-- 2. Maximum salary
SELECT MAX(Salary) AS Max_Salary FROM Employees;

-- 3. Count total customers
SELECT COUNT(*) AS Total_Customers FROM Customers;

-- 4. Count unique categories
SELECT COUNT(DISTINCT Category) AS Unique_Categories FROM Products;

-- 5. Total sales for a specific product
SELECT ProductID, SUM(Sales) AS Total_Sales 
FROM Sales 
WHERE ProductID = '12309' 
GROUP BY ProductID;

-- 6. Average age of employees
SELECT AVG(Age) AS Avg_Age FROM Employees;

-- 7. Employees count per department
SELECT Department, COUNT(*) AS Employee_Count 
FROM Employees 
GROUP BY Department;

-- 8. Min and max product price per category
SELECT Category, MIN(Price) AS Min_Price, MAX(Price) AS Max_Price 
FROM Products 
GROUP BY Category;

-- 9. Total sales per region
SELECT Region, SUM(Sales) AS Total_Sales 
FROM Sales 
GROUP BY Region;

-- 10. Departments with more than 5 employees
SELECT Department, COUNT(*) AS Employee_Count 
FROM Employees 
GROUP BY Department 
HAVING COUNT(*) > 5;
