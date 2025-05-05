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
