
-- LIMIT & OFFSET
-- LIMIT restricts the number of rows returned in the result set.
-- OFFSET skips a specified number of rows from the beginning.

-- Example: Return only the first 5 rows from the 'Person' table
SELECT * FROM Person.Person LIMIT 5;

-- Example: Return rows starting from the 6th row (skipping the first 5 rows)
SELECT * FROM Person.Person LIMIT 5 OFFSET 5;

-- Note: In SQL Server, use FETCH FIRST instead of LIMIT:
-- Example for SQL Server: 
-- SELECT * FROM Person.Person ORDER BY LastName 
-- FETCH FIRST 5 ROWS ONLY;
    