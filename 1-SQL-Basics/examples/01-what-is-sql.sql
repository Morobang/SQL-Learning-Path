
/*
===============================================
    01 - WHAT IS SQL?
    A comprehensive introduction to SQL
===============================================
*/

-- ============================================
-- 1. DEFINITION AND PURPOSE
-- ============================================

-- SQL stands for Structured Query Language
-- It is a standardized programming language designed for managing 
-- and manipulating relational databases

-- Key purposes of SQL:
-- ✓ Retrieve data from databases (Querying)
-- ✓ Insert new data into databases
-- ✓ Update existing data in databases  
-- ✓ Delete data from databases
-- ✓ Create new databases and tables
-- ✓ Set permissions on tables and procedures
-- ✓ Create views, procedures, and functions

-- ============================================
-- 2. SQL HISTORY AND EVOLUTION
-- ============================================

-- 1970s: Dr. Edgar F. Codd develops relational model
-- 1974: The term "Structured Query Language" is coined
-- 1979: First commercial SQL product (Oracle V2)
-- 1982: IBM releases SQL/DS
-- 1986: SQL becomes ANSI standard
-- 1987: SQL becomes ISO standard
-- 1989: SQL-89 (SQL1) - Major revision
-- 1999: SQL:1999 (SQL3) - Object-relational features
-- 2003: SQL:2003 - XML features
-- 2006: SQL:2006 - Ways to import, store, and query XML data
-- 2008: SQL:2008 - MERGE statement, INSTEAD OF triggers
-- 2011: SQL:2011 - Temporal data
-- 2016: SQL:2016 - JSON support

-- ============================================
-- 3. SQL DIALECTS AND VENDORS
-- ============================================

-- Major SQL Database Systems:
-- • MySQL - Most popular open-source database
-- • PostgreSQL - Advanced open-source database
-- • Microsoft SQL Server - Enterprise Windows-based
-- • Oracle Database - Enterprise-grade database
-- • SQLite - Lightweight, embedded database
-- • MariaDB - MySQL fork with additional features

-- Note: While SQL is standardized, each database system
-- has its own extensions and slight variations

-- ============================================
-- 4. BASIC SQL CATEGORIES
-- ============================================

-- DDL (Data Definition Language):
-- CREATE, ALTER, DROP, TRUNCATE
-- Used to define and modify database structure

-- DML (Data Manipulation Language):
-- SELECT, INSERT, UPDATE, DELETE
-- Used to manipulate data within tables

-- DCL (Data Control Language):
-- GRANT, REVOKE
-- Used to control access to data

-- TCL (Transaction Control Language):
-- COMMIT, ROLLBACK, SAVEPOINT
-- Used to manage database transactions

-- ============================================
-- 5. YOUR FIRST SQL QUERIES
-- ============================================

-- Before running queries, make sure you're using the right database
-- Uncomment the line below if using AdventureWorks database
-- USE AdventureWorks2022;

-- Example 1: Select all data from a table
-- The asterisk (*) means "all columns"
SELECT * FROM Person.Person;

-- Example 2: Select specific columns
-- This is more efficient and readable
SELECT FirstName, LastName FROM Person.Person;

-- Example 3: Select with row limit
-- LIMIT the results to avoid overwhelming output
SELECT TOP 10 FirstName, LastName FROM Person.Person;

-- Example 4: Select with alias for better readability
-- AS keyword creates column aliases
SELECT 
    FirstName AS 'First Name',
    LastName AS 'Last Name',
    PersonType AS 'Type'
FROM Person.Person;

-- ============================================
-- 6. WHY LEARN SQL?
-- ============================================

-- Career Benefits:
-- • High demand across all industries
-- • Average salary $70,000 - $120,000+
-- • Essential skill for data analysis
-- • Required for most database roles
-- • Foundation for data science and BI

-- Technical Benefits:
-- • Works with all major databases
-- • Integrates with programming languages
-- • Powerful data analysis capabilities
-- • Handles millions of records efficiently
-- • Industry standard for 40+ years

-- ============================================
-- 7. REAL-WORLD APPLICATIONS
-- ============================================

-- Business Intelligence:
-- • Sales reporting and analysis
-- • Customer behavior analysis
-- • Financial reporting
-- • Performance metrics and KPIs

-- Web Development:
-- • User authentication systems
-- • Content management systems
-- • E-commerce platforms
-- • Social media applications

-- Data Science:
-- • Data cleaning and preparation
-- • Exploratory data analysis
-- • Statistical computations
-- • Machine learning data pipelines

-- Enterprise Systems:
-- • ERP (Enterprise Resource Planning)
-- • CRM (Customer Relationship Management)  
-- • HR Management Systems
-- • Inventory Management

-- ============================================
-- 8. PRACTICE EXERCISES
-- ============================================

-- Exercise 1: Write a query to show all columns from any table
-- (Replace 'TableName' with an actual table name)
-- SELECT * FROM TableName;

-- Exercise 2: Select only 2-3 specific columns from a table
-- SELECT column1, column2 FROM TableName;

-- Exercise 3: Use aliases to make column names more readable
-- SELECT column1 AS 'Readable Name' FROM TableName;

-- ============================================
-- 🎯 KEY TAKEAWAYS
-- ============================================
-- 1. SQL is a standardized language for databases
-- 2. It's essential for working with data
-- 3. Minor syntax differences exist between database systems
-- 4. SQL skills are highly valuable in the job market
-- 5. Start with basic SELECT statements and build up

-- ============================================
-- 📚 NEXT STEPS
-- ============================================
-- Continue to: 02_SQL_Syntax_Rules.sql
-- Learn about: SQL syntax, comments, and conventions