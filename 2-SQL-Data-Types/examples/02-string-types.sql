-- String Data Types in SQL
-- String data types are used to store textual data.

-- 1. CHAR: 
--    A fixed-length string (padded with spaces to match the specified length).
-- Example:
SELECT CAST('Hello' AS CHAR(10)) AS Example_Char;

-- 2. VARCHAR (or VARCHAR2 in Oracle): 
--    A variable-length string (does not pad spaces).
-- Example:
SELECT CAST('Hello' AS VARCHAR(10)) AS Example_Varchar;

-- 3. TEXT (or CLOB): 
--    Used for large strings (text data).
-- Example:
SELECT CAST('This is a large text' AS TEXT) AS Example_Text;

