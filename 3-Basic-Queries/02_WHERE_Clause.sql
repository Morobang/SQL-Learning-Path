
-- WHERE Clause
-- The WHERE clause is used to filter records based on a specified condition.
-- It restricts the rows returned by the SELECT query.

-- Example: Select records where the 'FirstName' is 'John'
SELECT * FROM Person.Person WHERE FirstName = 'John';

-- Example: Use operators like <, >, <=, >=, != to filter data
SELECT * FROM Person.Person WHERE BirthDate > '1990-01-01';

-- Example: Use logical operators like AND, OR, NOT to combine conditions
SELECT * FROM Person.Person 
WHERE FirstName = 'John' AND LastName = 'Doe';

-- Example: Use BETWEEN for range conditions
SELECT * FROM Person.Person WHERE BirthDate BETWEEN '1980-01-01' AND '2000-01-01';
    