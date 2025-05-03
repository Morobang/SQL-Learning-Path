
-- SELECT Basics
-- The SELECT statement is used to query data from a database.
-- It allows us to retrieve one or more columns from one or more tables.

-- Example: Select all columns from the 'Person' table
SELECT * FROM Person.Person;

-- Example: Select specific columns (FirstName, LastName) from the 'Person' table
SELECT FirstName, LastName FROM Person.Person;

-- Example: Select columns with aliases for better readability
SELECT FirstName AS 'First Name', LastName AS 'Last Name' FROM Person.Person;
    