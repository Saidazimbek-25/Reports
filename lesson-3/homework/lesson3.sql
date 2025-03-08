CREATE TABLE employee_1(
Emp_id INT PRIMARY KEY,
NAME VARCHAR(55),
AGE INT,
Department varchar(55)
)
SELECT * FROM employee_1;
 
 BULK INSERT  employee_1
 FROM 'D:\games'
 WITH( FIELDTERMINATOR=',',
 ROWTERMINATOR='\n',FIRSTROW=2);

Drop table Products;

CREATE TABLE Products(
ProductID INT PRIMARY KEY IDENTITY(1,1),
ProductNAME VARCHAR(50),
Price DECIMAL(10,2)
)
INSERT INTO Products( ProductNAME,Price)
VALUES('TOILET PAPER',12.2),
('WET TOWELS',1.3),
('WASHING POWDER',19.8);
SELECT * FROM Products;

CREATE TABLE Referencee(
EmployeeID INT PRIMARY KEY IDENTITY(1,1),--An IDENTITY column in SQL is used to auto-generate unique numeric values for a column, typically for primary keys. It helps ensure each row gets a unique identifier without manual entry.As we know human entring might cause problem duplication,and it ensures uniqueness
Name VARCHAR(55) NOT NULL,-- Must always have a value
AGE INT NOT NULL,-- Must always have a value
Address VARCHAR (120)	NULL,--Can be NULL
PhoneNumber CHAR(13) NULL,--Can be NULL
--I also used commentary to explain its purpose because explaining is required.
);

SELECT * FROM Referencee


ALTER TABLE Products
ADD  CONSTRAINT UQ_TASK UNIQUE(ProductNAME);

ALTER TABLE Products
DROP CONSTRAINT UQ_TASK;--JUST I TRIED VICE VERSA VERSION I MEAN JUST DELETING THE FUNCTION POPPED IN MY MIND
