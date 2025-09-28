# SQL Syntax Rules

Understanding the fundamental rules and conventions that govern SQL query structure and formatting.

## Core Syntax Rules

### 1. Case Sensitivity
- **SQL Keywords**: Case-insensitive (`SELECT` = `select` = `Select`)
- **Database Names**: Depends on database system (MySQL: case-sensitive on Linux, case-insensitive on Windows)
- **Table Names**: Usually case-insensitive but best practice is to be consistent
- **Column Names**: Usually case-insensitive
- **String Values**: Always case-sensitive

```sql
-- These are equivalent
SELECT name FROM customers;
select name from customers;
Select Name From Customers;
```

### 2. Statement Termination
- Each SQL statement should end with a semicolon (`;`)
- Required when executing multiple statements
- Optional for single statements in some systems

```sql
SELECT * FROM customers;
INSERT INTO orders (customer_id, total) VALUES (1, 299.99);
```

### 3. Whitespace and Line Breaks
- SQL ignores extra whitespace and line breaks
- Use them for readability

```sql
-- Compact version
SELECT name,email FROM customers WHERE city='New York';

-- Readable version
SELECT 
    name,
    email
FROM customers
WHERE city = 'New York';
```

### 4. String Literals
- Use single quotes for string values
- Double quotes are for identifiers (column/table names)
- Escape single quotes by doubling them

```sql
SELECT * FROM customers WHERE name = 'John';
SELECT * FROM customers WHERE name = 'O''Reilly';  -- Escaped quote
```

### 5. Comments
- Single line: `-- This is a comment`
- Multi-line: `/* This is a multi-line comment */`

```sql
-- This is a single line comment
SELECT name FROM customers;  -- End of line comment

/*
This is a multi-line comment
that spans multiple lines
*/
SELECT * FROM products;
```

## Naming Conventions

### Best Practices
1. **Use meaningful names**: `customer_name` not `cn`
2. **Be consistent**: Choose snake_case or camelCase and stick to it
3. **Avoid reserved words**: Don't name columns `order`, `date`, `select`, etc.
4. **Use prefixes for clarity**: `tbl_customers`, `idx_customer_email`

### Common Conventions
- **Tables**: Plural nouns (`customers`, `orders`, `products`)
- **Columns**: Singular nouns (`customer_id`, `first_name`, `email`)
- **Primary Keys**: `id` or `table_name_id`
- **Foreign Keys**: `referenced_table_id`

## Query Structure

### Basic SELECT Structure
```sql
SELECT column1, column2
FROM table_name
WHERE condition
GROUP BY column
HAVING group_condition
ORDER BY column
LIMIT number;
```

### Order of Execution
1. `FROM` - Identify source tables
2. `WHERE` - Filter rows
3. `GROUP BY` - Group rows
4. `HAVING` - Filter groups
5. `SELECT` - Choose columns
6. `ORDER BY` - Sort results
7. `LIMIT` - Restrict number of rows

## Data Types in SQL

### Numeric Types
- `INT` - Integer numbers
- `DECIMAL(p,s)` - Exact decimal numbers
- `FLOAT` - Approximate decimal numbers

### String Types
- `VARCHAR(n)` - Variable length strings
- `CHAR(n)` - Fixed length strings
- `TEXT` - Large text data

### Date/Time Types
- `DATE` - Date only (YYYY-MM-DD)
- `TIME` - Time only (HH:MM:SS)
- `DATETIME` - Date and time
- `TIMESTAMP` - Unix timestamp

## Common Syntax Errors

### 1. Missing Quotes
```sql
-- Wrong
SELECT * FROM customers WHERE name = John;

-- Correct
SELECT * FROM customers WHERE name = 'John';
```

### 2. Incorrect Column References
```sql
-- Wrong (column doesn't exist)
SELECT customer_name FROM customers;

-- Correct
SELECT name FROM customers;
```

### 3. Missing Table Alias in Joins
```sql
-- Ambiguous (if both tables have 'id' column)
SELECT id, name FROM customers c JOIN orders o ON customer_id = id;

-- Clear
SELECT c.id, c.name FROM customers c JOIN orders o ON o.customer_id = c.id;
```

### 4. Wrong Operator Usage
```sql
-- Wrong (cannot use = with NULL)
SELECT * FROM customers WHERE email = NULL;

-- Correct
SELECT * FROM customers WHERE email IS NULL;
```

## SQL Standards

### ANSI SQL Standards
- **SQL-86** (SQL1): First standard
- **SQL-89** (SQL1): Minor revision
- **SQL-92** (SQL2): Major expansion
- **SQL:1999** (SQL3): Object-oriented features
- **SQL:2003**: XML features, window functions
- **SQL:2006**: Import/export, data mining
- **SQL:2008**: MERGE statement, INSTEAD OF triggers
- **SQL:2011**: Temporal data
- **SQL:2016**: JSON support, pattern matching

### Database-Specific Variations
- **MySQL**: Uses backticks for identifiers, different date functions
- **PostgreSQL**: More strict about data types, supports arrays
- **SQL Server**: Uses square brackets for identifiers, different syntax for TOP
- **Oracle**: Different pagination (ROWNUM), unique syntax elements

## Performance Considerations

### Query Writing Tips
1. **Be specific**: Select only needed columns
2. **Use WHERE clauses**: Filter data early
3. **Proper indexing**: Understand how indexes work
4. **Avoid functions in WHERE**: Can prevent index usage

```sql
-- Less efficient
SELECT * FROM orders WHERE YEAR(order_date) = 2023;

-- More efficient
SELECT * FROM orders WHERE order_date >= '2023-01-01' AND order_date < '2024-01-01';
```

## Tools and Environment

### SQL Execution Environments
- **Command Line**: mysql, psql, sqlcmd
- **GUI Tools**: MySQL Workbench, pgAdmin, SQL Server Management Studio
- **Online Editors**: DB Fiddle, SQL Fiddle, W3Schools SQL Tryit

### Setting Up Practice Environment
1. Install database system (MySQL, PostgreSQL, SQL Server)
2. Install management tool
3. Create sample database
4. Import sample data
5. Practice with real data

Remember: Good SQL syntax habits formed early will make you a more effective database developer!