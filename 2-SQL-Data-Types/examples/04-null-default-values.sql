-- NULL and Default Values in SQL
-- NULL represents missing or unknown data in a column.
-- It is not the same as an empty string or zero.

-- Example of NULL:
-- The following query will return NULL for the 'MiddleName' column if it contains no value.
SELECT FirstName, MiddleName, LastName FROM Users; -- Assuming MiddleName can be NULL

-- NULL comparison:
-- To check if a column contains NULL, use IS NULL or IS NOT NULL.
SELECT * FROM Users WHERE MiddleName IS NULL; -- Retrieves users with no MiddleName

-- Default Values:
-- A default value is automatically assigned to a column if no value is provided during an insert.

-- Example: Create a table with a default value for 'Gender' column:
CREATE TABLE ExampleUsers (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(100) NOT NULL,
    UserEmail VARCHAR(100) UNIQUE,
    Gender VARCHAR(10) DEFAULT 'Not Specified' -- Default value for Gender
);

-- Insert into the table without specifying 'Gender'. It will use the default value.
INSERT INTO ExampleUsers (UserID, UserName, UserEmail) 
VALUES (1, 'JohnDoe', 'john@example.com'); -- Gender will default to 'Not Specified'

-- Checking the result:
SELECT * FROM ExampleUsers; -- Retrieves all users, including the default Gender value