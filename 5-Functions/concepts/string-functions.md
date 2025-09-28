# String Functions

Master SQL string manipulation functions to clean, transform, and analyze text data effectively.

## Overview

String functions are essential tools for working with text data in SQL. They allow you to:
- Clean and standardize data
- Extract parts of strings
- Transform text case and format
- Search and replace content
- Concatenate multiple strings

## Common String Functions

### 1. Length Functions

**LENGTH() / LEN() / CHAR_LENGTH()**
```sql
-- Get string length
SELECT LENGTH('Hello World');  -- Returns: 11
SELECT LEN('Hello World');     -- SQL Server syntax
SELECT CHAR_LENGTH('Hello');   -- PostgreSQL/MySQL syntax
```

### 2. Case Conversion Functions

**UPPER() / LOWER() / INITCAP()**
```sql
-- Convert case
SELECT UPPER('hello world');     -- Returns: HELLO WORLD
SELECT LOWER('HELLO WORLD');     -- Returns: hello world
SELECT INITCAP('hello world');   -- Returns: Hello World (PostgreSQL/Oracle)
```

### 3. Trimming Functions

**TRIM() / LTRIM() / RTRIM()**
```sql
-- Remove whitespace
SELECT TRIM('  Hello World  ');    -- Returns: 'Hello World'
SELECT LTRIM('  Hello World  ');   -- Returns: 'Hello World  '
SELECT RTRIM('  Hello World  ');   -- Returns: '  Hello World'

-- Trim specific characters
SELECT TRIM('x' FROM 'xHello Worldx');  -- Returns: 'Hello World'
```

### 4. Substring Functions

**SUBSTRING() / SUBSTR() / LEFT() / RIGHT()**
```sql
-- Extract substrings
SELECT SUBSTRING('Hello World', 1, 5);    -- Returns: 'Hello'
SELECT SUBSTRING('Hello World', 7);       -- Returns: 'World'
SELECT LEFT('Hello World', 5);            -- Returns: 'Hello'
SELECT RIGHT('Hello World', 5);           -- Returns: 'World'
```

### 5. Position and Search Functions

**POSITION() / CHARINDEX() / INSTR() / LOCATE()**
```sql
-- Find position of substring
SELECT POSITION('World' IN 'Hello World');  -- Returns: 7
SELECT CHARINDEX('World', 'Hello World');   -- SQL Server: Returns 7
SELECT INSTR('Hello World', 'World');       -- Oracle/MySQL: Returns 7
SELECT LOCATE('World', 'Hello World');      -- MySQL: Returns 7
```

### 6. String Replacement Functions

**REPLACE() / TRANSLATE()**
```sql
-- Replace substrings
SELECT REPLACE('Hello World', 'World', 'SQL');  -- Returns: 'Hello SQL'

-- Character-by-character replacement (Oracle/PostgreSQL)
SELECT TRANSLATE('Hello123', '123', 'ABC');     -- Returns: 'HelloABC'
```

### 7. Concatenation Functions

**CONCAT() / CONCAT_WS() / || operator**
```sql
-- Concatenate strings
SELECT CONCAT('Hello', ' ', 'World');           -- Returns: 'Hello World'
SELECT CONCAT_WS(' ', 'Hello', 'Beautiful', 'World');  -- Returns: 'Hello Beautiful World'
SELECT 'Hello' || ' ' || 'World';               -- PostgreSQL/Oracle/SQLite
SELECT 'Hello' + ' ' + 'World';                 -- SQL Server
```

### 8. Padding Functions

**LPAD() / RPAD()**
```sql
-- Pad strings to specific length
SELECT LPAD('123', 5, '0');     -- Returns: '00123'
SELECT RPAD('Hello', 10, '.');  -- Returns: 'Hello.....'
```

### 9. Reverse and Repeat Functions

**REVERSE() / REPEAT() / REPLICATE()**
```sql
-- Reverse string
SELECT REVERSE('Hello');        -- Returns: 'olleH'

-- Repeat string
SELECT REPEAT('Ha', 3);         -- MySQL/PostgreSQL: Returns: 'HaHaHa'
SELECT REPLICATE('Ha', 3);      -- SQL Server: Returns: 'HaHaHa'
```

## Advanced String Operations

### Pattern Matching with LIKE
```sql
-- Wildcard patterns
SELECT * FROM customers WHERE name LIKE 'John%';    -- Starts with 'John'
SELECT * FROM customers WHERE name LIKE '%son';     -- Ends with 'son'
SELECT * FROM customers WHERE name LIKE '%oh%';     -- Contains 'oh'
SELECT * FROM customers WHERE name LIKE 'J_hn';     -- Single character wildcard
```

### Regular Expressions
```sql
-- MySQL/PostgreSQL regex
SELECT * FROM customers WHERE name REGEXP '^[A-M]';     -- Names starting A-M
SELECT * FROM customers WHERE name ~ '^[A-M]';          -- PostgreSQL syntax

-- SQL Server regex (limited)
SELECT * FROM customers WHERE name LIKE '[A-M]%';       -- Names starting A-M
```

### String Splitting (Database-Specific)

**MySQL - SUBSTRING_INDEX()**
```sql
-- Split string by delimiter
SELECT SUBSTRING_INDEX('apple,banana,cherry', ',', 1);  -- Returns: 'apple'
SELECT SUBSTRING_INDEX('apple,banana,cherry', ',', 2);  -- Returns: 'apple,banana'
```

**PostgreSQL - STRING_TO_ARRAY() / SPLIT_PART()**
```sql
-- Split string to array
SELECT STRING_TO_ARRAY('apple,banana,cherry', ',');

-- Get specific part
SELECT SPLIT_PART('apple,banana,cherry', ',', 2);       -- Returns: 'banana'
```

**SQL Server - STRING_SPLIT()**
```sql
-- Split string to table
SELECT value FROM STRING_SPLIT('apple,banana,cherry', ',');
```

## Practical Use Cases

### 1. Data Cleaning
```sql
-- Clean and standardize names
UPDATE customers 
SET name = TRIM(UPPER(name))
WHERE name IS NOT NULL;

-- Remove special characters
UPDATE products 
SET product_code = REPLACE(REPLACE(product_code, '-', ''), ' ', '')
WHERE product_code LIKE '%-%' OR product_code LIKE '% %';
```

### 2. Email Validation
```sql
-- Extract domain from email
SELECT 
    email,
    SUBSTRING(email, POSITION('@' IN email) + 1) as domain
FROM customers
WHERE email LIKE '%@%';

-- Validate email format
SELECT email
FROM customers
WHERE email LIKE '%@%.%' 
AND email NOT LIKE '%@%@%'
AND LENGTH(email) >= 5;
```

### 3. Name Processing
```sql
-- Split full name into first and last
SELECT 
    full_name,
    SUBSTRING(full_name, 1, POSITION(' ' IN full_name) - 1) as first_name,
    SUBSTRING(full_name, POSITION(' ' IN full_name) + 1) as last_name
FROM customers
WHERE full_name LIKE '% %';

-- Create initials
SELECT 
    name,
    CONCAT(LEFT(first_name, 1), '.', LEFT(last_name, 1), '.') as initials
FROM customers;
```

### 4. Phone Number Formatting
```sql
-- Standardize phone numbers
UPDATE customers 
SET phone = CONCAT(
    '(',
    SUBSTRING(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), 1, 3),
    ') ',
    SUBSTRING(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), 4, 3),
    '-',
    SUBSTRING(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), 7, 4)
)
WHERE LENGTH(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', '')) = 10;
```

### 5. URL and Path Processing
```sql
-- Extract filename from path
SELECT 
    file_path,
    REVERSE(SUBSTRING(REVERSE(file_path), 1, POSITION('/' IN REVERSE(file_path)) - 1)) as filename
FROM documents;

-- Extract domain from URL
SELECT 
    url,
    SUBSTRING(url, POSITION('//' IN url) + 2, 
              POSITION('/', SUBSTRING(url, POSITION('//' IN url) + 2)) - 1) as domain
FROM websites;
```

## Database-Specific Variations

### MySQL String Functions
```sql
-- MySQL-specific functions
SELECT SOUNDEX('Smith');                    -- Phonetic algorithm
SELECT MATCH(title) AGAINST('database');   -- Full-text search
SELECT INSERT('Hello World', 7, 5, 'SQL'); -- Insert/replace substring
```

### PostgreSQL String Functions
```sql
-- PostgreSQL-specific functions
SELECT ASCII('A');                          -- ASCII value
SELECT CHR(65);                            -- Character from ASCII
SELECT QUOTE_LITERAL('O''Reilly');         -- Escape for SQL literal
SELECT QUOTE_IDENT('table name');          -- Escape identifier
```

### SQL Server String Functions
```sql
-- SQL Server-specific functions
SELECT QUOTENAME('table name');             -- Quote identifier
SELECT PATINDEX('%[0-9]%', 'abc123def');   -- Pattern index
SELECT STUFF('Hello World', 7, 5, 'SQL');  -- Replace substring
```

### Oracle String Functions
```sql
-- Oracle-specific functions
SELECT INITCAP('hello world');              -- Initial caps
SELECT TRANSLATE('Hello123', '123', 'ABC'); -- Character translation
SELECT REGEXP_REPLACE('Hello World', 'l+', 'L'); -- Regex replace
```

## Performance Considerations

### Indexing String Columns
```sql
-- Create indexes for string searches
CREATE INDEX idx_customer_name ON customers(name);
CREATE INDEX idx_email_domain ON customers(SUBSTRING(email, POSITION('@' IN email) + 1));

-- Functional indexes (PostgreSQL/Oracle)
CREATE INDEX idx_upper_name ON customers(UPPER(name));
```

### Avoiding Function Usage in WHERE Clauses
```sql
-- Inefficient (prevents index usage)
SELECT * FROM customers WHERE UPPER(name) = 'JOHN DOE';

-- Better (can use index)
SELECT * FROM customers WHERE name = 'John Doe' OR name = 'JOHN DOE';

-- Best (store data in consistent format)
-- Standardize data during INSERT/UPDATE
```

## Common Pitfalls and Solutions

### 1. NULL Handling
```sql
-- Problem: CONCAT with NULL returns NULL
SELECT CONCAT(first_name, ' ', last_name);  -- Returns NULL if either is NULL

-- Solution: Use COALESCE or ISNULL
SELECT CONCAT(COALESCE(first_name, ''), ' ', COALESCE(last_name, ''));
SELECT CONCAT(ISNULL(first_name, ''), ' ', ISNULL(last_name, ''));  -- SQL Server
```

### 2. Character Encoding Issues
```sql
-- Be aware of character sets
SELECT LENGTH('café');    -- May return 4 or 5 depending on encoding
SELECT CHAR_LENGTH('café'); -- Character count (4)
SELECT OCTET_LENGTH('café'); -- Byte count (5 in UTF-8)
```

### 3. Case Sensitivity
```sql
-- Case-sensitive comparison (depends on collation)
SELECT * FROM customers WHERE name = 'john doe';

-- Case-insensitive comparison
SELECT * FROM customers WHERE UPPER(name) = UPPER('john doe');
SELECT * FROM customers WHERE name COLLATE SQL_Latin1_General_CP1_CI_AS = 'john doe';
```

## Best Practices

1. **Consistent Data Entry**: Standardize data during input rather than constantly transforming
2. **Use Appropriate Data Types**: Consider using ENUM or CHECK constraints for limited text values
3. **Index Strategy**: Create functional indexes for commonly searched transformations
4. **Validate Input**: Use string functions to validate data format before storage
5. **Document Assumptions**: Clearly document expected string formats and transformations

String functions are powerful tools for data manipulation, but use them wisely to maintain good performance and data quality!