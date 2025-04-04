-- 1. ASCII value of 'A'
SELECT ASCII('A');  -- Result: 65

-- 2. Length of 'Hello World'
SELECT LEN('Hello World');  -- Result: 11

-- 3. Reverse string 'OpenAI'
SELECT REVERSE('OpenAI');  -- Result: 'IAnepO'

-- 4. Add 5 spaces before a string
SELECT SPACE(5) + 'Text';  -- Result: '     Text'

-- 5. Remove leading spaces from ' SQL Server'
SELECT LTRIM(' SQL Server');  -- Result: 'SQL Server'

-- 6. Convert 'sql' to uppercase
SELECT UPPER('sql');  -- Result: 'SQL'

-- 7. Extract first 3 characters of 'Database'
SELECT LEFT('Database', 3);  -- Result: 'Dat'

-- 8. Get last 4 characters of 'Technology'
SELECT RIGHT('Technology', 4);  -- Result: 'logy'

-- 9. Substring from position 3 to 6 in 'Programming'
SELECT SUBSTRING('Programming', 3, 4);  -- Result: 'ogra'

-- 10. Concatenate 'SQL' and 'Server'
SELECT CONCAT('SQL', 'Server');  -- Result: 'SQLServer'

-- 11. Replace 'apple' with 'orange' in 'apple pie'
SELECT REPLACE('apple pie', 'apple', 'orange');  -- Result: 'orange pie'

-- 12. Find position of 'learn' in 'Learn SQL with LearnSQL'
SELECT CHARINDEX('learn', 'Learn SQL with LearnSQL');  -- Result: 0 (case-sensitive)
-- Case-insensitive:
SELECT CHARINDEX('learn', LOWER('Learn SQL with LearnSQL'));  -- Result: 18

-- 13. Check if 'Server' contains 'er'
SELECT CHARINDEX('er', 'Server') > 0 AS ContainsER;  -- Result: 1 (True)

-- 14. Split string into words
SELECT value FROM STRING_SPLIT('apple,orange,banana', ',');  -- Result: apple, orange, banana (each in a row)

-- 15. Power(2, 3)
SELECT POWER(2, 3);  -- Result: 8

-- 16. Square root of 16
SELECT SQRT(16);  -- Result: 4

-- 17. Current date and time
SELECT GETDATE();  -- Returns current system datetime

-- 18. Current UTC date and time
SELECT GETUTCDATE();  -- Returns current UTC datetime

-- 19. Get day of the month from '2025-02-03'
SELECT DAY('2025-02-03');  -- Result: 3

-- 20. Add 10 days to '2025-02-03'
SELECT DATEADD(DAY, 10, '2025-02-03');  -- Result: 2025-02-13
