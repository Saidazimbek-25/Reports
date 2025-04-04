-- 🟢 Easy-Level Tasks (10)

-- 1. Define and explain DDL and DML. Give two examples of each.
-- DDL (Data Definition Language): CREATE TABLE, ALTER TABLE
-- DML (Data Manipulation Language): INSERT INTO, UPDATE

-- 2. Write a query to create a table Employees with columns: EmpID (INT, PRIMARY KEY), Name (VARCHAR(50)), Salary (DECIMAL(10,2)).
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary DECIMAL(10, 2)
);

-- 3. Insert three records into the Employees table using the INSERT INTO statement.
INSERT INTO Employees (EmpID, Name, Salary)
VALUES
(1, 'John Doe', 5000.00),
(2, 'Jane Smith', 5500.00),
(3, 'Alice Johnson', 6000.00);

-- 4. Write a query to update the Salary of an employee where EmpID = 1.
UPDATE Employees
SET Salary = 5500.00
WHERE EmpID = 1;

-- 5. Delete a record from the Employees table where EmpID = 2.
DELETE FROM Employees
WHERE EmpID = 2;

-- 6. Explain the difference between DELETE, DROP, and TRUNCATE with examples.
-- DELETE: Removes rows from a table based on a condition.
-- DROP: Removes a table or database entirely.
-- TRUNCATE: Removes all rows from a table but keeps its structure intact.

-- 7. Modify the Name column in the Employees table to VARCHAR(100).
ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);

-- 8. Use the ALTER TABLE statement to add a new column Department (VARCHAR(50)) to the Employees table.
ALTER TABLE Employees
ADD Department VARCHAR(50);

-- 9. Use SSMS graphical tools to create a database named CompanyDB. Take a screenshot.
-- (Open SSMS, right-click on Databases > New Database > Name it 'CompanyDB')

-- 10. Describe the purpose of the TRUNCATE TABLE command.
-- TRUNCATE removes all rows from a table quickly and efficiently, retaining the table structure.

-- 🟠 Medium-Level Tasks (10)

-- 1. Create a table Departments with a PRIMARY KEY on DeptID and a FOREIGN KEY referencing Employees.EmpID.
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    EmpID INT,
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

-- 2. Insert five records into the Departments table using INSERT INTO SELECT from another table.
INSERT INTO Departments (DeptID, DepartmentName, EmpID)
SELECT 1, 'HR', EmpID FROM Employees WHERE EmpID = 1
UNION ALL
SELECT 2, 'IT', EmpID FROM Employees WHERE EmpID = 3;

-- 3. Write a query that updates the Department of all employees where Salary > 5000 to 'Management'.
UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000;

-- 4. Write a query to remove all records from the Employees table without removing its structure.
TRUNCATE TABLE Employees;

-- 5. Explain the difference between VARCHAR and NVARCHAR when creating tables.
-- VARCHAR: Stores non-Unicode characters, efficient in terms of storage for ASCII text.
-- NVARCHAR: Stores Unicode characters, suitable for multiple languages but uses more storage.

-- 6. Modify an existing column Salary to change its data type to FLOAT.
ALTER TABLE Employees
ALTER COLUMN Salary FLOAT;

-- 7. Drop the column Department from the Employees table using ALTER TABLE.
ALTER TABLE Employees
DROP COLUMN Department;

-- 8. Use SSMS graphical tools to modify the Employees table by adding a new column JoinDate (DATE). Take a screenshot.
-- (Open SSMS, right-click Employees > Design > Add 'JoinDate' column with type DATE)

-- 9. Create a temporary table and insert two records into it.
CREATE TABLE #TempEmployees (
    EmpID INT,
    Name VARCHAR(50),
    Salary DECIMAL(10, 2)
);

INSERT INTO #TempEmployees (EmpID, Name, Salary)
VALUES (1, 'John Doe', 5000.00), (2, 'Jane Smith', 5500.00);

-- 10. Write a query to remove the Departments table completely from the database.
DROP TABLE Departments;

-- 🔴 Hard-Level Tasks (10)

-- 1. Write a script that creates a Customers table with a CHECK constraint ensuring Age > 18.
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    CHECK (Age > 18)
);
-- 2. Write a query to delete all employees who have not received a salary increase in the last two years.
DELETE FROM Employees
WHERE DATEDIFF(YEAR, LastSalaryIncreaseDate, GETDATE()) > 2;

-- 3. Create a stored procedure that inserts a new employee record into the Employees table.
CREATE PROCEDURE InsertEmployee
    @EmpID INT,
    @Name VARCHAR(50),
    @Salary DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO Employees (EmpID, Name, Salary)
    VALUES (@EmpID, @Name, @Salary);
END;

-- 4. Write a query that creates a backup table Employees_Backup with the same structure as Employees.
SELECT * INTO Employees_Backup FROM Employees WHERE 1 = 0;

-- 5. Write a query to insert multiple rows using MERGE INTO from another table.
MERGE INTO Employees AS target
USING NewEmployees AS source
ON target.EmpID = source.EmpID
WHEN MATCHED THEN
    UPDATE SET target.Name = source.Name, target.Salary = source.Salary
WHEN NOT MATCHED THEN
    INSERT (EmpID, Name, Salary) VALUES (source.EmpID, source.Name, source.Salary);

-- 6. Drop the CompanyDB database and recreate it using a script.
DROP DATABASE CompanyDB;
CREATE DATABASE CompanyDB;

-- 7. Use SSMS graphical tools to rename the Employees table to StaffMembers. Take a screenshot.
-- (Open SSMS, right-click Employees > Rename > Name it 'StaffMembers')

-- 8. Explain the difference between CASCADE DELETE and CASCADE UPDATE with an example.
-- CASCADE DELETE: When a row in the parent table is deleted, the corresponding rows in the child table are also deleted.
-- CASCADE UPDATE: When a row in the parent table is updated, the corresponding rows in the child table are also updated.

-- 9. Write a query to reset the IDENTITY column seed of Employees after deleting all records.
DBCC CHECKIDENT ('Employees', RESEED, 0);

-- 10. Write a query that creates a table with both PRIMARY KEY and UNIQUE constraints on different columns.
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) UNIQUE
);
