-- Numeric Data Types in SQL
-- Numeric data types are used to store numbers in a SQL database.
-- They can be classified into the following categories:
-- CAST() function in SQL is used to convert a value from one data type to another.
-- CAST(expression AS target_data_type)

-- 1. INT (or INTEGER): 
--    Used for whole numbers (positive, negative, and zero).
--    Range: -2,147,483,648 to 2,147,483,647 (in SQL Server).
-- Example:
	SELECT 12345 AS Example_Int;

-- 2. DECIMAL (or NUMERIC): 
--    Used for exact numeric values with decimal points (precision and scale can be defined).
--    Example: DECIMAL(10, 2) allows 10 digits with 2 digits after the decimal point.
-- Example:
	SELECT CAST(123.45 AS DECIMAL(10, 2)) AS Example_Decimal;

-- 3. FLOAT and REAL: 
--    Used for approximate numeric values (floating point).
--    Example: FLOAT is a synonym for DOUBLE PRECISION.
-- Example:
	SELECT CAST(123.456789 AS FLOAT) AS Example_Float;

-- 4. MONEY: 
--    Used for storing currency values.
-- Example:
	SELECT CAST(12345.67 AS MONEY) AS Example_Money;
    