
---task 1-------------

use AdventureWorksDW2019
SELECT TOP 5 * FROM DimEmployee;

SELECT DISTINCT EnglishProductName FROM DimProduct;

drop table Products;

CREATE SCHEMA Products;
CREATE TABLE Products(
ID INT IDENTITY(1,1),
ProductName VARCHAR(90),
ProductCategory VARCHAR(90),
Price INT NOT NULL,
CustomerName VARCHAR(90) 
);
INSERT INTO Products (ProductName, ProductCategory, Price, CustomerName) VALUES
('Laptop', 'Electronics', 800, 'Jack Jones'),
('Smartphone', 'Electronics', 600, 'Paul Reli'),
('Headphones', 'Electronics', 150, 'Kim Suk Yo'),
('Smartwatch', 'Electronics', 250, 'ILLI FUI'),
('Tablet', 'Electronics', 500, 'Alfredo Itsu'),
('TV', 'Electronics', 1200, 'ANAS RASHID'),
('Bluetooth Speaker', 'Electronics', 200, 'ANAS RASHID'),
('Wireless Mouse', 'Electronics', 50, 'ANAS RASHID'),
('Gaming Console', 'Electronics', 400, 'ANAS RASHID'),
('Monitor', 'Electronics', 300, 'ANAS RASHID'),

('Dining Table', 'Furniture', 700, 'ANAS RASHID'),
('Sofa', 'Furniture', 1200, 'Alfredo Itsu'),
('Office Chair', 'Furniture', 250, 'Alfredo Itsu'),
('Bed Frame', 'Furniture', 900, 'Alfredo Itsu'),
('Wardrobe', 'Furniture', 1100, 'Alfredo Itsu'),
('Bookshelf', 'Furniture', 400, 'Alfredo Itsu'),
('Coffee Table', 'Furniture', 300, 'Alfredo Itsu'),
('TV Stand', 'Furniture', 350, 'Alfredo Itsu'),
('Recliner', 'Furniture', 800, 'Alfredo Itsu'),
('Drawer Chest', 'Furniture', 500, 'Alfredo Itsu'),

('T-shirt', 'Clothing', 30, 'ANASTASIYA FREDI'),
('Jeans', 'Clothing', 60, 'ANNA BELOVA'),
('Jacket', 'Clothing', 120, 'ANNA KATERINA'),
('Sneakers', 'Clothing', 100, 'ANASTASIYA FREDI'),
('Formal Shoes', 'Clothing', 150, 'ANASTASIYA FREDI'),
('Backpack', 'Clothing', 80, 'ANASTASIYA FREDI'),
('Watch', 'Clothing', 250, 'ANASTASIYA FREDI'),
('Sunglasses', 'Clothing', 90, 'ANASTASIYA FREDI'),
('Hat', 'Clothing', 40, 'ANASTASIYA FREDI'),
('Scarf', 'Clothing', 35, 'ANASTASIYA FREDI'),

('Rice Cooker', 'Appliances', 100, 'ANASTASIYA FREDI'),
('Microwave Oven', 'Appliances', 200, 'ANNA KATERINA'),
('Refrigerator', 'Appliances', 1500, 'ANNA KATERINA'),
('Washing Machine', 'Appliances', 1000, 'ANNA KATERINA'),
('Vacuum Cleaner', 'Appliances', 300, 'ANNA KATERINA'),
('Blender', 'Appliances', 80, 'ANNA KATERINA'),
('Electric Kettle', 'Appliances', 60, 'ANNA KATERINA'),
('Air Conditioner', 'Appliances', 2000, 'ANNA KATERINA'),
('Hair Dryer', 'Appliances', 70, 'ANNA KATERINA'),
('Toaster', 'Appliances', 50, 'ANNA KATERINA'),

('Football', 'Sports', 40, 'ANNA BELOVA'),
('Basketball', 'Sports', 50, 'ANNA BELOVA'),
('Tennis Racket', 'Sports', 120, 'ANNA BELOVA'),
('Running Shoes', 'Sports', 140, 'ANNA BELOVA'),
('Yoga Mat', 'Sports', 60, 'ANNA BELOVA'),
('Dumbbells', 'Sports', 100, 'ANNA BELOVA'),
('Skipping Rope', 'Sports', 30, 'ANNA BELOVA'),
('Cycling Helmet', 'Sports', 90, 'ANNA BELOVA'),
('Treadmill', 'Sports', 900, 'ANNA BELOVA'),
('Golf Club', 'Sports', 300, 'ANNA BELOVA');


SELECT * FROM Products;

 
 SELECT * FROM Products WHERE Price>100;
 
 SELECT * FROM Products WHERE Price<100;--just for myself just I tried opposed version
 ---JUST FOR PRACTISE-----
 SELECT COUNT (*)AS SportProductCount 
FROM Products 
WHERE ProductCategory = 'Sports';

SELECT * FROM Products WHERE CustomerName LIKE 'A%';

SELECT * FROM Products ORDER BY Price ASC;

ALTER TABLE DimEmployee ADD SALARY INT;

UPDATE DimEmployee
SET Salary =  
    CASE  
        WHEN Title= 'Marketing Manager' THEN 7000  
        WHEN Title = 'Marketing Assistant' THEN 5000  
        WHEN Title = 'Tool Designer' THEN 4500  
        WHEN Title = 'Human Resources Manager' THEN 5000
        ELSE 3000  -- Default salary for other roles  
    END  
WHERE Salary IS NULL;

ALTER TABLE DimEmployee DROP COLUMN SALARY;
SELECT Title FROM DimEmployee Where Title LIKE'H%';
SELECT *FROM DimEmployee;
SELECT DepartmentName,SALARY FROM DimEmployee WHERE SALARY>=5000;
SELECT DepartmentName,SALARY FROM DimEmployee WHERE SALARY>=5000 AND DepartmentName='Human Resources';

UPDATE DimEmployee  
SET EmailAddress = 'noemail@example.com'  
WHERE EmailAddress IS NULL;

SELECT * FROM Products WHERE Price BETWEEN 50 AND 100;
SELECT DISTINCT ProductName, ProductCategory 
FROM Products
ORDER BY ProductName ASC;
--TASK 2------
SELECT TOP 10 * FROM Products
ORDER BY Price DESC;
SELECT EmployeeKey, COALESCE(FirstName, LastName) AS Name FROM DimEmployee;
SELECT DISTINCT ProductCategory,Price FROM Products;
SELECT * FROM DimEmployee WHERE(Age BETWEEN 30 AND 40) OR DepartmentName='Marketing';
SELECT * FROM DimEmployee ORDER BY SALARY DESC OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;
ALTER TABLE Products  
ADD Stock INT DEFAULT 0;  
UPDATE Products  
SET Stock = CASE  
    WHEN ID = 1 THEN 10  
    WHEN ID = 2 THEN 25  
    WHEN ID = 3 THEN 55  
    WHEN ID = 4 THEN 75  
    WHEN ID = 5 THEN 100  
    -- Continue for all 50 products...
    ELSE 30  -- Default for products not listed  
END;
SELECT*FROM Products WHERE Price<=1000 AND Stock>50;
SELECT*FROM Products WHERE ProductName LIKE'%e%';
SELECT * FROM DimEmployee WHERE DepartmentName IN ('Human Resources', 'IT', 'Finance');
SELECT * FROM DimEmployee WHERE Salary > ANY (SELECT AVG(Salary) FROM DimEmployee);
SELECT * FROM DimCustomer ORDER BY City ASC, PostalCode DESC;

