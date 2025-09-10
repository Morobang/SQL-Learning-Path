-- 01_String_Functions.sql
-- ======================================
-- LESSON: SQL String Functions
-- String functions let you manipulate text values.

-- ======================================
-- Example Table: customers
-- id | first_name | last_name  | email
--  1 | Alice      | Smith      | alice.smith@email.com
--  2 | Bob        | Johnson    | bob.j@email.com
--  3 | Charlie    | Brown      | charlie_b@email.com
--  4 | Diana      | Adams      | diana.adams@email.com

-- ======================================
-- 1. UPPER & LOWER: Change text case
SELECT first_name, 
       UPPER(first_name) AS upper_name,
       LOWER(last_name) AS lower_name
FROM customers;

-- 2. LENGTH (MySQL/SQLite) or LEN (SQL Server):
-- Count number of characters in a string
SELECT first_name, LENGTH(first_name) AS name_length
FROM customers;

-- 3. TRIM, LTRIM, RTRIM: Remove spaces
SELECT TRIM('   hello   ') AS trimmed,
       LTRIM('   hello   ') AS left_trimmed,
       RTRIM('   hello   ') AS right_trimmed;

-- 4. SUBSTRING: Extract part of a string
-- Syntax may vary: SUBSTRING(string, start, length)
SELECT first_name,
       SUBSTRING(first_name, 1, 3) AS first_three_chars
FROM customers;

-- 5. LEFT & RIGHT: Get characters from start or end
SELECT first_name,
       LEFT(first_name, 2) AS first_two_letters,
       RIGHT(last_name, 3) AS last_three_letters
FROM customers;

-- 6. CONCAT: Join strings together
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customers;

-- 7. REPLACE: Replace part of a string
SELECT email,
       REPLACE(email, '.com', '.org') AS updated_email
FROM customers;

-- ======================================
-- COMBINING STRING FUNCTIONS
-- Example: Create username (first 3 letters of first name + last name in lowercase)
SELECT first_name, last_name,
       LOWER(CONCAT(LEFT(first_name, 3), last_name)) AS username
FROM customers;

-- ======================================
-- PRACTICE QUESTIONS
-- 1. Show all customer names in uppercase.
-- 2. Find the length of each last name.
-- 3. Remove spaces from '   SQL Tutorial   '.
-- 4. Get the first 4 letters of each email.
-- 5. Replace '@email.com' with '@mydomain.com' in all emails.
-- 6. Create usernames as last name + first letter of first name.

-- ======================================
-- END OF LESSON
