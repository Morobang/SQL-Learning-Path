-- CRUD Operations
-- CRUD stands for Create, Read, Update, and Delete.
-- These are the four basic operations used to manage data in SQL.

-- 1. CREATE (INSERT) - Insert data into a table
-- This operation adds new records to a table.
-- Example: Insert a new record into the 'Users' table.
INSERT INTO Users (UserID, UserName, UserEmail)
VALUES (1, 'JohnDoe', 'john@example.com'); -- Adding a new user with ID 1

-- 2. READ (SELECT) - Retrieve data from a table
-- This operation fetches data from a table.
-- Example: Select all records from the 'Users' table.
SELECT * FROM Users; -- This retrieves all columns for all records in the Users table

-- 3. UPDATE - Modify data in a table
-- This operation changes existing records in a table.
-- Example: Update the 'UserEmail' of a user where the 'UserID' is 1.
UPDATE Users
SET UserEmail = 'john.doe@example.com' -- Changing the email to john.doe@example.com
WHERE UserID = 1; -- Only updating the record where UserID is 1

-- 4. DELETE - Remove data from a table
-- This operation deletes records from a table.
-- Example: Delete a record where the 'UserID' is 1.
DELETE FROM Users
WHERE UserID = 1; -- Removing the record where UserID is 1

-- Summary of CRUD Operations:
-- - CREATE: Use INSERT to add new data.
-- - READ: Use SELECT to retrieve data.
-- - UPDATE: Use UPDATE to modify existing data.
-- - DELETE: Use DELETE to remove data.