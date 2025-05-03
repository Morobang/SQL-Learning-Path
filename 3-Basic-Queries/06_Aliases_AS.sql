
-- Aliases (AS)
-- Aliases are used to assign temporary names to columns or tables for better readability in the query result.

-- Example: Use an alias for a column
SELECT FirstName AS 'First Name', LastName AS 'Last Name' FROM Person.Person;

-- Example: Use an alias for a table
SELECT p.FirstName, p.LastName FROM Person.Person AS p;

-- Example: Combine aliases for both columns and tables
SELECT p.FirstName AS 'First Name', p.LastName AS 'Last Name' FROM Person.Person AS p;
    