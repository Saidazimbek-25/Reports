-- 1. Output "100-Steven King" format
SELECT CAST(emp_id AS VARCHAR) + '-' + first_name + ' ' + last_name AS full_name
FROM employees;

-- 2. Replace '124' with '999' in phone_number
UPDATE employees
SET phone_number = REPLACE(phone_number, '124', '999');

-- 3. First name and length for names starting with A, J, or M
SELECT first_name AS [First Name],
       LEN(first_name) AS [Name Length]
FROM employees
WHERE first_name LIKE 'A%' OR first_name LIKE 'J%' OR first_name LIKE 'M%'
ORDER BY first_name;

-- 4. Total salary for each manager
SELECT manager_id, SUM(salary) AS total_salary
FROM employees
GROUP BY manager_id;

-- 5. Year and highest value from Max1, Max2, Max3
SELECT year,
       (SELECT MAX(v) 
        FROM (VALUES (Max1), (Max2), (Max3)) AS value_table(v)) AS highest_value
FROM TestMax;

-- 6. Odd-numbered movies and non-boring description
SELECT *
FROM cinema
WHERE id % 2 = 1
  AND description <> 'boring';

-- 7. Sort by ID, but ID = 0 should be last
SELECT *
FROM SingleOrder
ORDER BY CASE WHEN id = 0 THEN 1 ELSE 0 END, id;

-- 8. Select first non-null value from columns
SELECT COALESCE(column1, column2, column3, column4) AS first_non_null
FROM person;
-- 1. Split FullName into Firstname, Middlename, and Lastname (Students Table)
SELECT 
  FullName,
  PARSENAME(REPLACE(FullName, ' ', '.'), 3) AS Firstname,
  PARSENAME(REPLACE(FullName, ' ', '.'), 2) AS Middlename,
  PARSENAME(REPLACE(FullName, ' ', '.'), 1) AS Lastname
FROM Students;


-- 2. Customer orders delivered to Texas if they had a delivery to California (Orders Table)
SELECT *
FROM Orders
WHERE DeliveryState = 'Texas'
  AND CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE DeliveryState = 'California'
  );


-- 3. Group concatenate values (DMLTable)
SELECT 
  STRING_AGG(ColumnName, ', ') AS ConcatenatedValues
FROM DMLTable;


-- 4. Employees whose full names contain the letter 'a' at least 3 times
SELECT *
FROM Employees
WHERE LEN(FirstName + LastName) 
      - LEN(REPLACE(FirstName + LastName, 'a', '')) >= 3;


-- 5. Total employees in each department and percentage with >3 years experience
SELECT 
  DepartmentID,
  COUNT(*) AS TotalEmployees,
  SUM(CASE WHEN DATEDIFF(YEAR, HireDate, GETDATE()) > 3 THEN 1 ELSE 0 END) AS MoreThan3Years,
  CAST(SUM(CASE WHEN DATEDIFF(YEAR, HireDate, GETDATE()) > 3 THEN 1 ELSE 0 END) * 100.0 
       / COUNT(*) AS DECIMAL(5,2)) AS PercentageMoreThan3Years
FROM Employees
GROUP BY DepartmentID;


-- 6. Most and least experienced Spaceman ID by Job Description (Personal Table)
WITH ExperienceCTE AS (
  SELECT 
    JobDescription,
    SpacemanID,
    ExperienceYears,
    RANK() OVER (PARTITION BY JobDescription ORDER BY ExperienceYears DESC) AS MaxRank,
    RANK() OVER (PARTITION BY JobDescription ORDER BY ExperienceYears ASC) AS MinRank
  FROM Personal
)
SELECT 
  JobDescription,
  MAX(CASE WHEN MaxRank = 1 THEN SpacemanID END) AS MostExperiencedSpaceman,
  MAX(CASE WHEN MinRank = 1 THEN SpacemanID END) AS LeastExperiencedSpaceman
FROM ExperienceCTE
GROUP BY JobDescription;
-- 1. Separate uppercase, lowercase, numbers, and special characters from a string
DECLARE @input VARCHAR(100) = 'tf56sd#%OqH';

SELECT 
  @input AS OriginalString,
  (
    SELECT STRING_AGG(SUBSTRING(@input, v.number, 1), '')
    FROM master.dbo.spt_values v
    WHERE v.type = 'P' AND v.number BETWEEN 1 AND LEN(@input)
      AND SUBSTRING(@input, v.number, 1) COLLATE Latin1_General_CS_AS LIKE '[A-Z]'
  ) AS UppercaseLetters,
  (
    SELECT STRING_AGG(SUBSTRING(@input, v.number, 1), '')
    FROM master.dbo.spt_values v
    WHERE v.type = 'P' AND v.number BETWEEN 1 AND LEN(@input)
      AND SUBSTRING(@input, v.number, 1) COLLATE Latin1_General_CS_AS LIKE '[a-z]'
  ) AS LowercaseLetters,
  (
    SELECT STRING_AGG(SUBSTRING(@input, v.number, 1), '')
    FROM master.dbo.spt_values v
    WHERE v.type = 'P' AND v.number BETWEEN 1 AND LEN(@input)
      AND SUBSTRING(@input, v.number, 1) LIKE '[0-9]'
  ) AS Numbers,
  (
    SELECT STRING_AGG(SUBSTRING(@input, v.number, 1), '')
    FROM master.dbo.spt_values v
    WHERE v.type = 'P' AND v.number BETWEEN 1 AND LEN(@input)
      AND SUBSTRING(@input, v.number, 1) NOT LIKE '[A-Za-z0-9]'
  ) AS SpecialCharacters;


-- 2. Replace each row with running total of its values (Students table assumed to have ID and Score columns)
SELECT 
  ID,
  Score,
  SUM(Score) OVER (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM Students;


-- 3. Evaluate and sum mathematical equations in VARCHAR column (Equations)
-- Assuming Equation column has expressions like '2+3', '4*5', etc.
-- Requires SQL CLR or a custom parser — basic simulation using REPLACE + EXEC
-- Limited to only + operations for demo
SELECT 
  Equation,
  SUM(CAST(PARSENAME(REPLACE(Equation, '+', '.'), 2) AS INT) +
      CAST(PARSENAME(REPLACE(Equation, '+', '.'), 1) AS INT)) AS Answer
FROM Equations
GROUP BY Equation;


-- 4. Find students with the same birthday (Student table assumed to have ID, Name, and BirthDate)
SELECT *
FROM Student
WHERE CONVERT(VARCHAR(5), BirthDate, 110) IN (
  SELECT CONVERT(VARCHAR(5), BirthDate, 110)
  FROM Student
  GROUP BY CONVERT(VARCHAR(5), BirthDate, 110)
  HAVING COUNT(*) > 1
)
ORDER BY BirthDate;


-- 5. Aggregate scores for unique player pairs regardless of order (PlayerScores)
-- Assuming columns: PlayerA, PlayerB, Score
SELECT 
  CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END AS Player1,
  CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END AS Player2,
  SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY 
  CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END,
  CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END;

