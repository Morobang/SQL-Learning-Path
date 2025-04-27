-- SQL Syntax Rules
-- 1. SQL Keywords are NOT case-sensitive
--    SELECT, select, SeLeCt are all treated the same way.

-- 2. SQL statements are usually ended with a semicolon (;)

-- 3. Comments in SQL:
--    Single-line comment starts with '--'
--    Multi-line comment starts with '/*' and ends with '*/'

-- 4. SQL statements are read from top to bottom, left to right.

-- Example of a single-line comment in SQL:
-- This is a single-line comment.
SELECT * FROM Users; -- This selects all records from the Users table.

-- Example of a multi-line comment:
-- This query selects all records from the 'Person' table.
-- It retrieves every column for all the people listed in the database.
SELECT * FROM Users;

-- 5. Aliases
-- You can create temporary names for tables or columns using aliases.
-- Example of using an alias for a column:
SELECT UserName AS Name FROM Users; -- Renaming UserName to Name in the output

-- Example of using an alias for a table:
SELECT u.UserName 
FROM Users AS u; -- Using 'u' as an alias for the Users table

-- 6. String Literals
-- String values must be enclosed in single quotes.
SELECT * FROM Users WHERE UserName = 'JohnDoe'; -- Selecting where UserName is JohnDoe

-- 7. Functions
-- SQL includes built-in functions for various operations.
-- Example of using a string function:
SELECT UPPER(UserName) FROM Users; -- Converts UserName to uppercase

-- Example of using an aggregate function:
SELECT COUNT(*) FROM Users; -- Counts the total number of users

-- 8. Order of Execution
-- Understanding the logical order of SQL operations can help in writing queries:
-- 1. FROM
-- 2. WHERE
-- 3. GROUP BY
-- 4. HAVING
-- 5. SELECT
-- 6. ORDER BY

-- Example demonstrating order of execution:
SELECT UserName, COUNT(*) AS OrderCount
FROM Orders
WHERE OrderDate >= '2023-01-01' -- Filtering records
GROUP BY UserName -- Grouping results by UserName
HAVING COUNT(*) > 5 -- Filtering groups
ORDER BY OrderCount DESC; -- Sorting results

-- 9. Using DISTINCT
-- The DISTINCT keyword is used to return unique values.
SELECT DISTINCT UserEmail FROM Users; -- Selecting unique email addresses

-- Summary
-- This section covers the basic syntax rules of SQL, including keywords, comments, aliases, and more.