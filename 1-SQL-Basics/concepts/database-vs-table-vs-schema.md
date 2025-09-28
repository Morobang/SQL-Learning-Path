# Database vs Table vs Schema

Understanding the hierarchical structure of database systems and how databases, schemas, and tables relate to each other.

## Database Hierarchy

### The Complete Structure
```
Database Management System (DBMS)
├── Database (or Catalog)
    ├── Schema (or Database in MySQL)
        ├── Tables
        │   ├── Columns
        │   ├── Rows
        │   ├── Constraints
        │   └── Indexes
        ├── Views
        ├── Stored Procedures
        ├── Functions
        └── Triggers
```

## Database Level

### What is a Database?
A **database** is the highest level container that holds all related data and database objects. It's a collection of schemas (or tables directly in some systems).

### Characteristics
- **Isolation**: Each database is separate from others
- **Security**: Access controls at database level
- **Backup Unit**: Usually backed up as a complete unit
- **Connection Target**: You connect to a specific database

### Examples by Database System
```sql
-- MySQL: Create a database
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- PostgreSQL: Create a database
CREATE DATABASE ecommerce_db;
\c ecommerce_db;

-- SQL Server: Create a database
CREATE DATABASE ecommerce_db;
USE ecommerce_db;
```

## Schema Level

### What is a Schema?
A **schema** is a logical container within a database that groups related database objects. Think of it as a namespace or folder system within a database.

### Purpose of Schemas
1. **Organization**: Group related tables and objects
2. **Security**: Control access at schema level
3. **Namespace**: Avoid naming conflicts
4. **Multi-tenancy**: Separate different applications or clients

### Schema Variations by Database System

#### PostgreSQL & SQL Server
- Schemas exist within databases
- Default schema is usually `public` (PostgreSQL) or `dbo` (SQL Server)
- Objects are referenced as `schema.table_name`

```sql
-- PostgreSQL/SQL Server
CREATE SCHEMA sales;
CREATE SCHEMA inventory;

CREATE TABLE sales.orders (id INT, total DECIMAL);
CREATE TABLE inventory.products (id INT, name VARCHAR(100));

-- Query with schema reference
SELECT * FROM sales.orders;
SELECT * FROM inventory.products;
```

#### MySQL
- No separate schema concept
- Database names act as schema names
- Schema and database are synonymous

```sql
-- MySQL
CREATE DATABASE sales_db;
CREATE DATABASE inventory_db;

USE sales_db;
CREATE TABLE orders (id INT, total DECIMAL);

USE inventory_db;
CREATE TABLE products (id INT, name VARCHAR(100));
```

#### Oracle
- Strong schema concept
- Each user typically has their own schema
- Schema name usually matches username

```sql
-- Oracle
CREATE USER sales_user IDENTIFIED BY password;
CREATE USER inventory_user IDENTIFIED BY password;

-- Objects are created in user's schema
-- sales_user.orders, inventory_user.products
```

## Table Level

### What is a Table?
A **table** is the fundamental data storage structure that contains rows and columns of related data.

### Table Components
1. **Columns**: Define data structure and types
2. **Rows**: Contain actual data records
3. **Constraints**: Enforce data integrity rules
4. **Indexes**: Improve query performance

### Table Creation Example
```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Practical Examples

### E-commerce Database Structure

#### High-Level Organization
```
ecommerce_database
├── customer_schema
│   ├── customers
│   ├── addresses
│   └── customer_preferences
├── product_schema
│   ├── products
│   ├── categories
│   └── inventory
├── order_schema
│   ├── orders
│   ├── order_items
│   └── payments
└── admin_schema
    ├── users
    ├── roles
    └── permissions
```

#### Implementation by Database System

**PostgreSQL Implementation:**
```sql
-- Create database
CREATE DATABASE ecommerce;

-- Create schemas
CREATE SCHEMA customers;
CREATE SCHEMA products;
CREATE SCHEMA orders;

-- Create tables in specific schemas
CREATE TABLE customers.customer_profiles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE products.product_catalog (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE orders.order_history (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers.customer_profiles(id),
    product_id INT REFERENCES products.product_catalog(id)
);
```

**MySQL Implementation:**
```sql
-- Create separate databases (acting as schemas)
CREATE DATABASE customers_db;
CREATE DATABASE products_db;
CREATE DATABASE orders_db;

-- Use specific database and create tables
USE customers_db;
CREATE TABLE customer_profiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

USE products_db;
CREATE TABLE product_catalog (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2)
);

USE orders_db;
CREATE TABLE order_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    product_id INT
);
```

## Naming and Organization Strategies

### Schema Naming Conventions
1. **By Function**: `sales`, `inventory`, `hr`, `finance`
2. **By Application**: `app_v1`, `app_v2`, `reporting`
3. **By Environment**: `dev`, `test`, `prod`
4. **By Tenant**: `client_a`, `client_b`, `shared`

### Table Naming Conventions
1. **Descriptive**: `customer_orders` not `co`
2. **Consistent**: Choose plural or singular and stick to it
3. **Meaningful**: `user_sessions` not `temp_table`
4. **No Reserved Words**: Avoid `order`, `user`, `date`

### Best Practices
```sql
-- Good naming
CREATE SCHEMA customer_management;
CREATE TABLE customer_management.customer_profiles (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email_address VARCHAR(100),
    registration_date DATE
);

-- Poor naming
CREATE SCHEMA cm;
CREATE TABLE cm.cp (
    id INT PRIMARY KEY,
    fn VARCHAR(50),
    ln VARCHAR(50),
    em VARCHAR(100),
    dt DATE
);
```

## Cross-Database/Schema Queries

### Referencing Objects Across Boundaries

**Full Qualification Syntax:**
```sql
-- PostgreSQL/SQL Server format
database.schema.table_name

-- MySQL format (no separate schema)
database.table_name

-- Examples
SELECT * FROM ecommerce.customers.profiles;
SELECT * FROM sales_db.orders;
```

**Practical Cross-Schema Query:**
```sql
-- Join tables from different schemas
SELECT 
    c.name,
    o.order_date,
    p.product_name
FROM customers.profiles c
JOIN orders.order_history o ON c.customer_id = o.customer_id
JOIN products.catalog p ON o.product_id = p.product_id
WHERE o.order_date >= '2023-01-01';
```

## Security and Permissions

### Schema-Level Security
```sql
-- Grant permissions to entire schema
GRANT SELECT ON SCHEMA customers TO read_only_user;
GRANT ALL ON SCHEMA orders TO order_manager;

-- Revoke permissions
REVOKE INSERT ON SCHEMA customers FROM temp_user;
```

### Table-Level Security
```sql
-- Grant specific table permissions
GRANT SELECT, INSERT ON customers.profiles TO app_user;
GRANT SELECT ON products.catalog TO public;
```

## Migration and Management

### Schema Migration Strategies
1. **Version Control**: Track schema changes in version control
2. **Migration Scripts**: Automated deployment scripts
3. **Rollback Plans**: Ability to reverse changes
4. **Environment Consistency**: Same structure across dev/test/prod

### Common Management Tasks
```sql
-- List all schemas
SELECT schema_name FROM information_schema.schemata;

-- List tables in a schema
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'customers';

-- Get table structure
DESCRIBE customers.profiles;
-- or
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_schema = 'customers' 
AND table_name = 'profiles';
```

Understanding this hierarchy is crucial for organizing data effectively and maintaining clean, scalable database architectures!