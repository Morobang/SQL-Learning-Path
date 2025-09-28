-- Database vs Table vs Schema

-- 1. Database:
-- A database is a container that holds all your data. It can have multiple tables.

-- Creating a new database named SampleDB
CREATE DATABASE SampleDB;

-- 2. Table:
-- A table is where the data is stored. A table is made up of rows and columns.

-- Switching to the SampleDB database
USE SampleDB;

-- Creating a table named Users
CREATE TABLE Users (
    UserID INT PRIMARY KEY,         -- Unique identifier for each user
    UserName VARCHAR(100) NOT NULL, -- User's name
    UserEmail VARCHAR(100) UNIQUE    -- User's email, must be unique
);

-- 3. Schema:
-- A schema is a way to logically group related tables. It acts as a container for tables, views, and procedures.

-- Example: The 'AdventureWorks2019' database contains multiple schemas.
-- The 'Person' schema contains tables like 'Person', 'Address', etc.

-- Query to list all tables in the 'dbo' schema
SELECT table_name 
FROM INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'dbo';

-- Example of table structure: The 'Users' table within the 'dbo' schema.
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Users';

-- Summary
-- A database is a collection of related data organized in tables.
-- A table stores the actual data in rows and columns.
-- A schema groups tables logically and can also include views and procedures.