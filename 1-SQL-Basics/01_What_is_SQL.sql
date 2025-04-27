
-- What is SQL?
-- SQL stands for Structured Query Language.
-- It is used for managing and querying relational databases.
-- SQL allows you to interact with the data stored in a database using queries.
-- It can perform various operations like retrieving, inserting, updating, and deleting data.

-- Example of SELECT query:
-- This query selects all records from the 'Person' table in the 'AdventureWorks2019' database.
use AdventureWorks2022;
SELECT * FROM Person.Person;

-- Example of SELECT with specific columns:
-- This query retrieves only the 'FirstName' and 'LastName' columns from the 'Person' table.
SELECT FirstName, LastName FROM Person.Person;
    