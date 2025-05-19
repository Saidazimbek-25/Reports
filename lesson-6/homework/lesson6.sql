-- Puzzle 1

SELECT DISTINCT 
    LEAST(col1, col2) AS col1, 
    GREATEST(col1, col2) AS col2
FROM InputTbl;

SELECT DISTINCT 
    CASE WHEN col1 < col2 THEN col1 ELSE col2 END AS col1,
    CASE WHEN col1 < col2 THEN col2 ELSE col1 END AS col2
FROM InputTbl;
-- Puzzle 2
SELECT * 
FROM TestMultipleZero
WHERE A <> 0 OR B <> 0 OR C <> 0 OR D <> 0;
-- Puzzle 3
SELECT * 
FROM section1
WHERE id % 2 = 1;
-- Puzzle 4: Person with the smallest id
SELECT * 
FROM section1
ORDER BY id ASC
LIMIT 1;

-- Puzzle 5: Person with the highest id
SELECT * 
FROM section1
ORDER BY id DESC
LIMIT 1;

-- Puzzle 6: People whose name starts with 'b' (case-insensitive)
SELECT * 
FROM section1
WHERE LOWER(name) LIKE 'b%';

-- Puzzle 7: Return rows where the code contains a literal underscore "_"
SELECT * 
FROM ProductCodes
WHERE Code LIKE '%\_%' ESCAPE '\';
