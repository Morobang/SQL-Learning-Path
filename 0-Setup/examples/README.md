# 💻 Setup Examples - Installation Scripts and Commands

This section contains practical scripts and commands to help you set up your SQL development environment.

## 📁 Files in This Directory

### [connection-examples.sql](./connection-examples.sql)
- Test database connections
- Verify installation success
- Basic query examples to confirm setup

### [sample-data.sql](./sample-data.sql)
- Small practice datasets
- Test data for initial queries
- Setup verification data

## 🛠️ Quick Setup Scripts

### MySQL Setup Verification
```sql
-- Test MySQL connection and basic functionality
SELECT VERSION() as mysql_version;
SHOW DATABASES;
CREATE DATABASE test_db;
USE test_db;
CREATE TABLE test_table (id INT, name VARCHAR(50));
INSERT INTO test_table VALUES (1, 'Test');
SELECT * FROM test_table;
DROP DATABASE test_db;
```

### PostgreSQL Setup Verification
```sql
-- Test PostgreSQL connection
SELECT version();
\l
CREATE DATABASE test_db;
\c test_db
CREATE TABLE test_table (id INTEGER, name VARCHAR(50));
INSERT INTO test_table VALUES (1, 'Test');
SELECT * FROM test_table;
DROP DATABASE test_db;
```

### SQL Server Setup Verification
```sql
-- Test SQL Server connection
SELECT @@VERSION as sql_server_version;
SELECT name FROM sys.databases;
CREATE DATABASE test_db;
USE test_db;
CREATE TABLE test_table (id INT, name VARCHAR(50));
INSERT INTO test_table VALUES (1, 'Test');
SELECT * FROM test_table;
DROP DATABASE test_db;
```

## 🔄 Navigation
[← Back to Setup](../README.md) | [Setup Concepts →](../concepts/README.md)