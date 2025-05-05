-- 1. Report of all distributors and their sales by region, including zero-sales
DROP TABLE IF EXISTS #RegionSales;
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);

INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

SELECT Region, Distributor, 
       COALESCE(Sales, 0) AS Sales
FROM (SELECT DISTINCT Region FROM #RegionSales) AS Regions
CROSS JOIN (SELECT DISTINCT Distributor FROM #RegionSales) AS Distributors
LEFT JOIN #RegionSales rs 
  ON rs.Region = Regions.Region AND rs.Distributor = Distributors.Distributor
ORDER BY Region, Distributor;

-- 2. Find managers with at least five direct reports
CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

SELECT name
FROM Employee
WHERE id IN (
    SELECT managerId
    FROM Employee
    GROUP BY managerId
    HAVING COUNT(*) >= 5
);

-- 3. Get the names of products with at least 100 units ordered in February 2020
CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

SELECT p.product_name, SUM(o.unit) AS unit
FROM Products p
JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;

-- 4. Return the vendor from which each customer has placed the most orders
CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);

INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

SELECT CustomerID, 
       (SELECT TOP 1 Vendor 
        FROM Orders o
        WHERE o.CustomerID = Orders.CustomerID
        GROUP BY Vendor
        ORDER BY SUM(o.[Count]) DESC) AS Vendor
FROM Orders
GROUP BY CustomerID;

-- 5. Check if a number is prime
DECLARE @Check_Prime INT = 91;

IF @Check_Prime <= 1
  PRINT 'This number is not prime';
ELSE
BEGIN
  DECLARE @i INT = 2;
  DECLARE @IsPrime BIT = 1;
  
  WHILE @i <= @Check_Prime / 2
  BEGIN
    IF @Check_Prime % @i = 0
    BEGIN
      SET @IsPrime = 0;
      BREAK;
    END
    SET @i = @i + 1;
  END
  
  IF @IsPrime = 1
    PRINT 'This number is prime';
  ELSE
    PRINT 'This number is not prime';
END;

-- 6. Get the number of locations, the location with the most signals sent, and the total number of signals for each device
CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

WITH LocationCount AS (
  SELECT Device_id, Locations, COUNT(*) AS Signals
  FROM Device
  GROUP BY Device_id, Locations
)
SELECT Device_id, 
       COUNT(DISTINCT Locations) AS no_of_location, 
       TOP 1 Locations AS max_signal_location,
       MAX(Signals) AS no_of_signals
FROM LocationCount
GROUP BY Device_id;

-- 7. Employees earning more than the average salary in their department
CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

WITH DeptAvg AS (
  SELECT DeptID, AVG(Salary) AS AvgSalary
  FROM Employee
  GROUP BY DeptID
)
SELECT e.EmpID, e.EmpName, e.Salary
FROM Employee e
JOIN DeptAvg da ON e.DeptID = da.DeptID
WHERE e.Salary > da.AvgSalary;

-- 8. Calculate the total winnings for today's lottery drawing
CREATE TABLE WinningNumbers (Number INT);
CREATE TABLE Tickets (TicketID VARCHAR(100), Number INT);

INSERT INTO WinningNumbers VALUES
(25), (45), (78);

INSERT INTO Tickets VALUES
('A23423', 25), ('A23423', 45), ('A23423', 78),
('B35643', 25), ('B35643', 45), ('B35643', 98),
('C98787', 67), ('C98787', 86), ('C98787', 91);

WITH TicketWin AS (
  SELECT TicketID, COUNT(*) AS WinningCount
  FROM Tickets t
  JOIN WinningNumbers wn ON t.Number = wn.Number
  GROUP BY TicketID
)
SELECT SUM(CASE WHEN WinningCount = 3 THEN 100 WHEN WinningCount > 0 THEN 10 ELSE 0 END) AS TotalWinnings
FROM TicketWin;

-- 9. Find the total number of users and total amount spent using mobile, desktop, and both
CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);

SELECT Spend_date, Platform, 
       SUM(Amount) AS Total_Amount, 
       COUNT(DISTINCT User_id) AS Total_users
FROM (
  SELECT Spend_date, 'Mobile' AS Platform, Amount, User_id FROM Spending WHERE Platform = 'Mobile'
  UNION
  SELECT Spend_date, 'Desktop' AS Platform, Amount, User_id FROM Spending WHERE Platform = 'Desktop'
  UNION
  SELECT Spend_date, 'Both' AS Platform, SUM(Amount) AS Amount, COUNT(DISTINCT User_id) FROM Spending
  WHERE Platform IN ('Mobile', 'Desktop')
  GROUP BY Spend_date
) AS Summary
GROUP BY Spend_date, Platform;

-- 10. De-group the following data
CREATE TABLE Grouped (
  Product VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

WITH Numbers AS (
  SELECT Product, generate_series(1, Quantity) AS Series
  FROM Grouped
)
SELECT Product, 1 AS Quantity
FROM Numbers;
