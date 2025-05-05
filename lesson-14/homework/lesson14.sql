-- 1. Split the Name column by a comma into two separate columns: Name and Surname
SELECT 
    SUBSTRING_INDEX(Name, ',', 1) AS Name, 
    SUBSTRING_INDEX(Name, ',', -1) AS Surname
FROM TestMultipleColumns;

-- 2. Find strings from a table where the string itself contains the % character
SELECT *
FROM TestPercent
WHERE ColumnName LIKE '%\%%' ESCAPE '\';

-- 3. Split a string based on dot (.)
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(ColumnName, '.', 1), '.', -1) AS Part1,
    SUBSTRING_INDEX(SUBSTRING_INDEX(ColumnName, '.', 2), '.', -1) AS Part2,
    SUBSTRING_INDEX(SUBSTRING_INDEX(ColumnName, '.', 3), '.', -1) AS Part3
FROM Splitter;

-- 4. Replace all integers (digits) in the string with 'X'
SELECT REGEXP_REPLACE(ColumnName, '[0-9]', 'X') AS ModifiedString
FROM YourTable;

-- 5. Return all rows where the value in the Vals column contains more than two dots (.)
SELECT *
FROM testDots
WHERE LENGTH(Vals) - LENGTH(REPLACE(Vals, '.', '')) > 2;

-- 6. Count the spaces present in the string
SELECT LENGTH(ColumnName) - LENGTH(REPLACE(ColumnName, ' ', '')) AS SpaceCount
FROM CountSpaces;

-- 7. Find employees who earn more than their managers
SELECT e.EmployeeID, e.FirstName, e.LastName
FROM Employees e
JOIN Employees m ON e.ManagerID = m.EmployeeID
WHERE e.Salary > m.Salary;

-- 8. Find the employees who have been with the company for more than 10 years but less than 15 years
SELECT 
    EmployeeID, 
    FirstName, 
    LastName, 
    HireDate, 
    TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) AS YearsOfService
FROM Employees
WHERE TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) > 10
  AND TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) < 15;
-- 1. Separate the integer values and the character values into two different columns
SELECT 
    REGEXP_SUBSTR(ColumnName, '[0-9]+') AS Integers, 
    REGEXP_REPLACE(ColumnName, '[0-9]', '') AS Characters
FROM rtcfvty34redt;

-- 2. Find all dates' Ids with higher temperature compared to its previous (yesterday's) dates
SELECT 
    w1.Id, 
    w1.Date, 
    w1.Temperature
FROM weather w1
JOIN weather w2 ON w1.Date = DATE_ADD(w2.Date, INTERVAL 1 DAY)
WHERE w1.Temperature > w2.Temperature;

-- 3. Report the first login date for each player
SELECT PlayerID, MIN(LoginDate) AS FirstLoginDate
FROM Activity
GROUP BY PlayerID;

-- 4. Return the third item from the list
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(ColumnName, ',', 3), ',', -1) AS ThirdItem
FROM fruits;

-- 5. Create a table where each character from the string will be converted into a row
CREATE TEMPORARY TABLE SplitChars (Char CHAR(1));
INSERT INTO SplitChars (Char)
SELECT SUBSTRING('sdgfhsdgfhs@121313131', n, 1)
FROM seq_1_to_18 AS s
WHERE n <= CHAR_LENGTH('sdgfhsdgfhs@121313131');

-- 6. Join two tables p1 and p2 on the id column, replacing p1.code with p2.code when p1.code is 0
SELECT 
    p1.id, 
    COALESCE(NULLIF(p1.code, 0), p2.code) AS code
FROM p1
JOIN p2 ON p1.id = p2.id;

-- 7. Determine the Employment Stage for each employee based on their HIRE_DATE
SELECT 
    EmployeeID, 
    FirstName, 
    LastName, 
    HireDate,
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) < 1 THEN 'New Hire'
        WHEN TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) BETWEEN 1 AND 5 THEN 'Junior'
        WHEN TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) BETWEEN 5 AND 10 THEN 'Mid-Level'
        WHEN TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) BETWEEN 10 AND 20 THEN 'Senior'
        WHEN TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) > 20 THEN 'Veteran'
    END AS EmploymentStage
FROM Employees;

-- 8. Extract the integer value that appears at the start of the string in a column named Vals
SELECT 
    CAST(REGEXP_SUBSTR(Vals, '^[0-9]+') AS UNSIGNED) AS IntegerValue
FROM GetIntegers;
-- 1. Swap the first two letters of the comma separated string
SELECT 
    CONCAT(SUBSTRING(ColumnName, 2, 1), SUBSTRING(ColumnName, 1, 1), SUBSTRING(ColumnName, 3)) AS SwappedString
FROM MultipleVals;

-- 2. Report the device that is first logged in for each player
SELECT 
    PlayerID, 
    Device, 
    MIN(LoginDate) AS FirstLoginDate
FROM Activity
GROUP BY PlayerID;

-- 3. Calculate the week-on-week percentage of sales per area for each financial week
WITH WeeklySales AS (
    SELECT 
        Area,
        WEEK(Date) AS FinancialWeek,
        SUM(SalesAmount) AS WeeklyTotalSales
    FROM sales
    GROUP BY Area, WEEK(Date)
),
AreaSales AS (
    SELECT 
        Area,
        WEEK(Date) AS FinancialWeek,
        SUM(SalesAmount) AS DailySales
    FROM sales
    GROUP BY Area, WEEK(Date), DAY(Date)
)
SELECT 
    a.FinancialWeek,
    a.Area,
    (b.DailySales / a.WeeklyTotalSales) * 100 AS WeekOnWeekPercentage
FROM WeeklySales a
JOIN AreaSales b 
    ON a.Area = b.Area 
    AND a.FinancialWeek = b.FinancialWeek
ORDER BY a.FinancialWeek, a.Area;
