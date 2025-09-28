# Numeric Functions

Master SQL numeric functions to perform mathematical calculations, statistical analysis, and data transformations on numerical data.

## Overview

Numeric functions are essential for:
- Mathematical calculations and transformations
- Statistical analysis and aggregations
- Data validation and formatting
- Financial calculations
- Scientific computations

## Basic Mathematical Functions

### 1. Arithmetic Operations
```sql
-- Basic arithmetic
SELECT 10 + 5;    -- Addition: 15
SELECT 10 - 5;    -- Subtraction: 5
SELECT 10 * 5;    -- Multiplication: 50
SELECT 10 / 5;    -- Division: 2
SELECT 10 % 3;    -- Modulo (remainder): 1
SELECT 10 ^ 2;    -- Exponentiation: 100 (PostgreSQL)
SELECT POWER(10, 2); -- Exponentiation: 100 (standard)
```

### 2. Absolute Value and Sign
```sql
-- Absolute value
SELECT ABS(-15);     -- Returns: 15
SELECT ABS(15);      -- Returns: 15

-- Sign function
SELECT SIGN(-15);    -- Returns: -1
SELECT SIGN(0);      -- Returns: 0
SELECT SIGN(15);     -- Returns: 1
```

### 3. Rounding Functions
```sql
-- Round to nearest integer
SELECT ROUND(15.7);      -- Returns: 16
SELECT ROUND(15.4);      -- Returns: 15

-- Round to specific decimal places
SELECT ROUND(15.789, 2); -- Returns: 15.79
SELECT ROUND(15.789, 1); -- Returns: 15.8
SELECT ROUND(15.789, 0); -- Returns: 16

-- Ceiling (round up)
SELECT CEILING(15.1);    -- Returns: 16
SELECT CEIL(15.1);       -- Alias for CEILING

-- Floor (round down)
SELECT FLOOR(15.9);      -- Returns: 15
```

### 4. Truncation
```sql
-- Truncate decimal places
SELECT TRUNCATE(15.789, 2);  -- MySQL: Returns 15.78
SELECT TRUNC(15.789, 2);     -- Oracle: Returns 15.78

-- Truncate to integer
SELECT TRUNCATE(15.789, 0);  -- Returns: 15
```

## Advanced Mathematical Functions

### 1. Exponential and Logarithmic Functions
```sql
-- Exponential functions
SELECT EXP(1);           -- e^1 ≈ 2.718
SELECT POWER(2, 3);      -- 2^3 = 8
SELECT SQRT(16);         -- Square root: 4

-- Logarithmic functions
SELECT LOG(10);          -- Natural logarithm
SELECT LOG10(100);       -- Base-10 logarithm: 2
SELECT LOG(2, 8);        -- Base-2 logarithm: 3 (MySQL/PostgreSQL)
```

### 2. Trigonometric Functions
```sql
-- Basic trigonometric functions (angles in radians)
SELECT SIN(PI()/2);      -- Sine: 1
SELECT COS(0);           -- Cosine: 1
SELECT TAN(PI()/4);      -- Tangent: 1

-- Inverse trigonometric functions
SELECT ASIN(1);          -- Arcsine: π/2
SELECT ACOS(0);          -- Arccosine: π/2
SELECT ATAN(1);          -- Arctangent: π/4

-- Convert between degrees and radians
SELECT RADIANS(90);      -- Degrees to radians: π/2
SELECT DEGREES(PI()/2);  -- Radians to degrees: 90
```

### 3. Constants
```sql
-- Mathematical constants
SELECT PI();             -- π ≈ 3.14159
SELECT E();              -- e ≈ 2.71828 (MySQL)
```

## Statistical Functions

### 1. Basic Statistical Functions
```sql
-- Using sample data
SELECT 
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    AVG(salary) as avg_salary,
    SUM(salary) as total_salary,
    COUNT(*) as employee_count
FROM employees;
```

### 2. Standard Deviation and Variance
```sql
-- Standard deviation
SELECT 
    STDDEV(salary) as std_dev,           -- Standard deviation
    STDDEV_POP(salary) as pop_std_dev,   -- Population standard deviation
    STDDEV_SAMP(salary) as samp_std_dev  -- Sample standard deviation
FROM employees;

-- Variance
SELECT 
    VARIANCE(salary) as variance,        -- Variance
    VAR_POP(salary) as pop_variance,     -- Population variance
    VAR_SAMP(salary) as samp_variance    -- Sample variance
FROM employees;
```

## Random Number Functions

### 1. Random Number Generation
```sql
-- Random number between 0 and 1
SELECT RANDOM();         -- PostgreSQL
SELECT RAND();           -- MySQL/SQL Server

-- Random number in range
SELECT FLOOR(RANDOM() * 100) + 1;  -- Random integer 1-100 (PostgreSQL)
SELECT FLOOR(RAND() * 100) + 1;    -- Random integer 1-100 (MySQL)

-- Set random seed for reproducible results
SELECT SRAND(42);        -- SQL Server
SELECT RANDOM();         -- Will produce same sequence
```

## Formatting Functions

### 1. Number Formatting
```sql
-- Format numbers with decimals
SELECT FORMAT(1234.567, 2);         -- Returns: "1,234.57" (MySQL/SQL Server)

-- Format with specific decimal places
SELECT ROUND(1234.567, 2);          -- Returns: 1234.57

-- Convert to specific data types
SELECT CAST(123.456 AS INT);         -- Returns: 123
SELECT CONVERT(INT, 123.456);        -- SQL Server: Returns 123
```

### 2. Number to String Conversion
```sql
-- Convert number to string
SELECT CAST(123 AS VARCHAR(10));     -- Returns: "123"
SELECT CONVERT(VARCHAR(10), 123);    -- SQL Server: Returns "123"
SELECT TO_CHAR(123, '999');          -- Oracle: Returns " 123"
SELECT TO_CHAR(123.45, '999.99');    -- Oracle: Returns " 123.45"
```

## Practical Use Cases

### 1. Financial Calculations
```sql
-- Calculate compound interest
SELECT 
    principal,
    rate,
    years,
    principal * POWER(1 + rate, years) as final_amount
FROM investments;

-- Calculate monthly payment for loan
SELECT 
    loan_amount,
    monthly_rate,
    months,
    (loan_amount * monthly_rate * POWER(1 + monthly_rate, months)) / 
    (POWER(1 + monthly_rate, months) - 1) as monthly_payment
FROM loans;
```

### 2. Percentage Calculations
```sql
-- Calculate percentage change
SELECT 
    old_value,
    new_value,
    ROUND(((new_value - old_value) / old_value) * 100, 2) as percent_change
FROM price_history;

-- Calculate percentage of total
SELECT 
    department,
    salary,
    ROUND((salary / SUM(salary) OVER()) * 100, 2) as percent_of_total
FROM employees;
```

### 3. Data Binning and Categorization
```sql
-- Create age groups
SELECT 
    name,
    age,
    CASE 
        WHEN age < 18 THEN 'Minor'
        WHEN age BETWEEN 18 AND 64 THEN 'Adult'
        ELSE 'Senior'
    END as age_group,
    FLOOR(age / 10) * 10 as age_decade
FROM customers;

-- Create salary brackets
SELECT 
    name,
    salary,
    CASE 
        WHEN salary < 30000 THEN 'Low'
        WHEN salary < 60000 THEN 'Medium'
        WHEN salary < 100000 THEN 'High'
        ELSE 'Very High'
    END as salary_bracket
FROM employees;
```

### 4. Statistical Analysis
```sql
-- Calculate z-scores (standardization)
SELECT 
    employee_id,
    salary,
    (salary - AVG(salary) OVER()) / STDDEV(salary) OVER() as salary_zscore
FROM employees;

-- Calculate percentiles
SELECT 
    employee_id,
    salary,
    PERCENT_RANK() OVER (ORDER BY salary) * 100 as salary_percentile
FROM employees;
```

### 5. Distance Calculations
```sql
-- Calculate Euclidean distance between two points
SELECT 
    point1_x, point1_y,
    point2_x, point2_y,
    SQRT(POWER(point2_x - point1_x, 2) + POWER(point2_y - point1_y, 2)) as distance
FROM coordinates;

-- Haversine formula for geographic distance (simplified)
SELECT 
    lat1, lon1, lat2, lon2,
    6371 * ACOS(
        COS(RADIANS(lat1)) * COS(RADIANS(lat2)) * 
        COS(RADIANS(lon2) - RADIANS(lon1)) + 
        SIN(RADIANS(lat1)) * SIN(RADIANS(lat2))
    ) as distance_km
FROM locations;
```

## Database-Specific Functions

### MySQL Numeric Functions
```sql
-- MySQL-specific functions
SELECT GREATEST(10, 20, 30);         -- Returns: 30
SELECT LEAST(10, 20, 30);            -- Returns: 10
SELECT CONV('FF', 16, 10);           -- Base conversion: 255
SELECT BIN(255);                     -- Convert to binary: "11111111"
SELECT HEX(255);                     -- Convert to hex: "FF"
```

### PostgreSQL Numeric Functions
```sql
-- PostgreSQL-specific functions
SELECT WIDTH_BUCKET(75, 0, 100, 10); -- Bucket number: 8
SELECT SCALE(123.456);               -- Decimal places: 3
SELECT NUMERIC_SCALE(123.456);       -- Same as SCALE
SELECT DIV(10, 3);                   -- Integer division: 3
```

### SQL Server Numeric Functions
```sql
-- SQL Server-specific functions
SELECT SQUARE(5);                    -- Square: 25
SELECT ATN2(1, 1);                   -- Arctangent of y/x: π/4
SELECT LOG(10, 2);                   -- Log base 2 of 10
```

### Oracle Numeric Functions
```sql
-- Oracle-specific functions
SELECT BITAND(6, 3);                 -- Bitwise AND: 2
SELECT REMAINDER(11, 4);             -- Different from MOD: 3
SELECT WIDTH_BUCKET(75, 0, 100, 10); -- Histogram bucket: 8
```

## Performance Considerations

### 1. Avoiding Calculations in WHERE Clauses
```sql
-- Inefficient (prevents index usage)
SELECT * FROM products WHERE price * 0.9 > 100;

-- Better (can use index)
SELECT * FROM products WHERE price > 100 / 0.9;
```

### 2. Using Computed Columns
```sql
-- Create computed column for frequently calculated values
ALTER TABLE products 
ADD discounted_price AS (price * 0.9) PERSISTED;  -- SQL Server

-- Or create an index on the expression
CREATE INDEX idx_discounted_price ON products((price * 0.9));  -- PostgreSQL
```

### 3. Precision and Data Types
```sql
-- Choose appropriate data types
DECIMAL(10,2)    -- For financial data requiring exact precision
FLOAT/REAL       -- For scientific calculations where precision is less critical
INTEGER          -- For whole numbers
BIGINT           -- For large whole numbers
```

## Common Pitfalls and Solutions

### 1. Division by Zero
```sql
-- Problem: Division by zero error
SELECT sales / days;  -- Error if days = 0

-- Solution: Use NULLIF or CASE
SELECT sales / NULLIF(days, 0);  -- Returns NULL if days = 0
SELECT CASE WHEN days = 0 THEN NULL ELSE sales / days END;
```

### 2. Precision Loss
```sql
-- Problem: Integer division truncates
SELECT 5 / 2;  -- Returns 2, not 2.5

-- Solution: Cast to decimal
SELECT 5.0 / 2;           -- Returns 2.5
SELECT CAST(5 AS FLOAT) / 2;  -- Returns 2.5
```

### 3. Overflow Issues
```sql
-- Problem: Result exceeds data type range
SELECT POWER(2, 50);  -- May overflow INT

-- Solution: Use appropriate data type
SELECT CAST(POWER(2, 50) AS BIGINT);
```

### 4. Floating Point Precision
```sql
-- Problem: Floating point comparison
SELECT * FROM prices WHERE price = 19.99;  -- May not match due to precision

-- Solution: Use range comparison
SELECT * FROM prices WHERE ABS(price - 19.99) < 0.01;
```

## Best Practices

1. **Choose Appropriate Data Types**: Use DECIMAL for financial data, FLOAT for scientific calculations
2. **Handle NULL Values**: Always consider how NULLs affect calculations
3. **Validate Input**: Check for division by zero and overflow conditions
4. **Use Built-in Functions**: Leverage database-specific optimized functions
5. **Consider Precision**: Understand the precision requirements of your calculations
6. **Index Calculated Columns**: Create indexes on frequently calculated expressions
7. **Document Complex Formulas**: Add comments explaining complex mathematical operations

Numeric functions are powerful tools for data analysis and business calculations, but they require careful consideration of precision, performance, and edge cases!