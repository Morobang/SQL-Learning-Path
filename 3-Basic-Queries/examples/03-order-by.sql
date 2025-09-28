
-- ORDER BY
-- The ORDER BY clause is used to sort the result set in ascending or descending order.

-- Example: Sort the results by 'LastName' in ascending order (default)
SELECT FirstName, LastName FROM Person.Person ORDER BY LastName;

-- Example: Sort the results by 'LastName' in descending order
SELECT FirstName, LastName FROM Person.Person ORDER BY LastName DESC;

-- Example: Sort by multiple columns ('LastName' and 'FirstName')
SELECT FirstName, LastName FROM Person.Person ORDER BY LastName, FirstName;
    