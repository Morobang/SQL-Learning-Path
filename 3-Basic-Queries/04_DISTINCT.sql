
-- DISTINCT
-- The DISTINCT keyword is used to return unique (non-duplicate) values from a query.

-- Example: Select distinct 'Gender' values from the 'Person' table
SELECT DISTINCT Gender FROM Person.Person;

-- Example: Select distinct 'FirstName' and 'LastName' combinations
SELECT DISTINCT FirstName, LastName FROM Person.Person;
    