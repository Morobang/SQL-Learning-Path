-- Date and Time Data Types in SQL
-- These data types are used for storing date, time, and timestamp data.

-- 1. DATE: 
--    Stores date values (year, month, day).
-- Example:
SELECT CAST('2025-04-28' AS DATE) AS Example_Date;

-- 2. DATETIME:
--    Stores date and time values (year, month, day, hour, minute, second).
-- Example:
SELECT CAST('2025-04-28 14:30:00' AS DATETIME) AS Example_Datetime;

-- 3. TIMESTAMP:
--    Similar to DATETIME, but automatically updated with the current timestamp when a record is modified.
-- Example:
SELECT CURRENT_TIMESTAMP AS Example_Timestamp;

-- 4. TIME:
--    Stores time values (hour, minute, second).
-- Example:
SELECT CAST('14:30:00' AS TIME) AS Example_Time;

-- 5. DATETIME2 (SQL Server only):
--    A more precise version of DATETIME.
-- Example:
SELECT CAST('2025-04-28 14:30:00.1234567' AS DATETIME2) AS Example_Datetime2;
    