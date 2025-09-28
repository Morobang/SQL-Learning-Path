/*
===============================================
    DATA MODELING EXERCISES
    Practice with Normalization, Denormalization, ERD Design, and Dimensional Modeling
===============================================
*/

-- ============================================
-- SETUP: Create Database for Data Modeling Practice
-- ============================================

DROP DATABASE IF EXISTS data_modeling_practice;
CREATE DATABASE data_modeling_practice;
USE data_modeling_practice;

-- ============================================
-- EXERCISE 1: Entity-Relationship Diagram (ERD) Design
-- ============================================

/*
SCENARIO: University Management System

You need to design a database for a university that tracks:
- Students (ID, name, email, enrollment date, major)
- Courses (ID, name, credits, department)
- Instructors (ID, name, email, department, hire date)
- Enrollments (student takes courses, with grades and semester)
- Departments (ID, name, head of department)

TASK 1.1: Identify Entities and Attributes
List all entities and their attributes:

Entity: Student
Attributes: _________________

Entity: Course  
Attributes: _________________

Entity: Instructor
Attributes: _________________

Entity: Enrollment
Attributes: _________________

Entity: Department
Attributes: _________________

TASK 1.2: Identify Relationships
Define relationships between entities:

Student to Course: _________________ (Cardinality: _____)
Student to Department: _____________ (Cardinality: _____)
Course to Department: ______________ (Cardinality: _____)
Instructor to Department: __________ (Cardinality: _____)
Instructor to Course: ______________ (Cardinality: _____)

TASK 1.3: Create the Physical Schema
Based on your ERD, create the tables:
*/

-- YOUR ANSWER - Create the tables based on your ERD design:


-- ============================================
-- EXERCISE 2: Normalization Practice
-- ============================================

/*
SCENARIO: Poorly Designed Order System

You have a denormalized table with the following structure:
*/

CREATE TABLE bad_orders (
    order_id INT,
    order_date DATE,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_phone VARCHAR(20),
    customer_address VARCHAR(200),
    product_name VARCHAR(100),
    product_category VARCHAR(50),
    product_price DECIMAL(10,2),
    quantity INT,
    supplier_name VARCHAR(100),
    supplier_contact VARCHAR(100),
    employee_name VARCHAR(100),
    employee_department VARCHAR(50)
);

-- Sample data
INSERT INTO bad_orders VALUES
(1001, '2024-01-15', 'John Doe', 'john@email.com', '555-1234', '123 Main St', 'Laptop Pro', 'Electronics', 999.99, 2, 'Tech Supply Co', 'tech@supply.com', 'Alice Johnson', 'Sales'),
(1001, '2024-01-15', 'John Doe', 'john@email.com', '555-1234', '123 Main St', 'Mouse Wireless', 'Electronics', 29.99, 1, 'Peripheral Inc', 'info@peripheral.com', 'Alice Johnson', 'Sales'),
(1002, '2024-01-16', 'Jane Smith', 'jane@email.com', '555-5678', '456 Oak Ave', 'Office Chair', 'Furniture', 199.99, 1, 'Furniture Plus', 'sales@furniture.com', 'Bob Wilson', 'Sales'),
(1003, '2024-01-17', 'John Doe', 'john@email.com', '555-1234', '123 Main St', 'Desk Lamp', 'Furniture', 49.99, 3, 'Furniture Plus', 'sales@furniture.com', 'Alice Johnson', 'Sales');

/*
TASK 2.1: Identify Normalization Issues
List the normalization issues in the bad_orders table:

1st Normal Form Violations:
- _________________

2nd Normal Form Violations:
- _________________

3rd Normal Form Violations:
- _________________

TASK 2.2: Apply First Normal Form (1NF)
Create tables in 1NF (eliminate repeating groups):
*/

-- YOUR ANSWER - Create 1NF tables:


/*
TASK 2.3: Apply Second Normal Form (2NF)
Create tables in 2NF (eliminate partial dependencies):
*/

-- YOUR ANSWER - Create 2NF tables:


/*
TASK 2.4: Apply Third Normal Form (3NF)
Create tables in 3NF (eliminate transitive dependencies):
*/

-- YOUR ANSWER - Create 3NF tables:


/*
TASK 2.5: Verify Your Normalization
Insert the original data into your normalized tables and verify:
1. No data redundancy
2. All functional dependencies are preserved
3. No insertion, update, or deletion anomalies
*/

-- YOUR ANSWER - Insert data and verification queries:


-- ============================================
-- EXERCISE 3: Denormalization Strategies
-- ============================================

/*
SCENARIO: E-commerce Analytics

You have a normalized e-commerce database but need to create denormalized views 
for analytics and reporting. The normalized schema includes:
*/

-- Normalized schema for e-commerce
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    registration_date DATE
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50),
    parent_category_id INT
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Sample data
INSERT INTO customers VALUES
(1, 'John', 'Doe', 'john@email.com', '2023-01-15'),
(2, 'Jane', 'Smith', 'jane@email.com', '2023-02-20'),
(3, 'Bob', 'Wilson', 'bob@email.com', '2023-03-10');

INSERT INTO categories VALUES
(1, 'Electronics', NULL),
(2, 'Computers', 1),
(3, 'Phones', 1),
(4, 'Furniture', NULL);

INSERT INTO products VALUES
(1, 'Laptop Pro', 2, 999.99),
(2, 'iPhone', 3, 799.99),
(3, 'Office Chair', 4, 199.99),
(4, 'Wireless Mouse', 2, 29.99);

INSERT INTO orders VALUES
(1001, 1, '2024-01-15', 1029.98),
(1002, 2, '2024-01-16', 199.99),
(1003, 1, '2024-01-20', 829.98);

INSERT INTO order_items VALUES
(1001, 1, 1, 999.99),
(1001, 4, 1, 29.99),
(1002, 3, 1, 199.99),
(1003, 2, 1, 799.99),
(1003, 4, 1, 29.99);

/*
TASK 3.1: Create Sales Summary Denormalized Table
Create a denormalized table for sales reporting that includes:
- Order information
- Customer information  
- Product information
- Category information
- Calculated fields (line totals, etc.)
*/

-- YOUR ANSWER - Create denormalized sales summary table:


/*
TASK 3.2: Create Customer Analytics Denormalized View
Create a denormalized view for customer analytics that includes:
- Customer details
- Aggregated purchase history
- Customer lifetime value
- Purchase patterns
*/

-- YOUR ANSWER - Create customer analytics view:


/*
TASK 3.3: Create Product Performance Denormalized Table
Create a denormalized table for product performance analysis:
- Product details with category hierarchy
- Sales metrics (total sold, revenue, etc.)
- Ranking and performance indicators
*/

-- YOUR ANSWER - Create product performance table:


-- ============================================
-- EXERCISE 4: Dimensional Modeling (Data Warehouse)
-- ============================================

/*
SCENARIO: Sales Data Warehouse

Design a dimensional model for sales analysis with the following requirements:
- Track sales by time, product, customer, and geography
- Support drill-down analysis
- Optimized for OLAP queries
*/

/*
TASK 4.1: Design Dimension Tables
Create dimension tables for your star schema:

Time Dimension - should support:
- Different time granularities (day, month, quarter, year)
- Business calendar vs fiscal calendar
- Holiday indicators
*/

-- YOUR ANSWER - Create time dimension:
CREATE TABLE dim_time (
    -- Define your time dimension structure
);

/*
Product Dimension - should support:
- Product hierarchy (category, subcategory, product)
- Product attributes
- Slowly changing dimensions (SCD) for price changes
*/

-- YOUR ANSWER - Create product dimension:
CREATE TABLE dim_product (
    -- Define your product dimension structure
);

/*
Customer Dimension - should support:
- Customer demographics
- Customer segmentation
- Geographic information
*/

-- YOUR ANSWER - Create customer dimension:
CREATE TABLE dim_customer (
    -- Define your customer dimension structure
);

/*
Geography Dimension - should support:
- Geographic hierarchy (country, state, city)
- Territory assignments
- Regional groupings
*/

-- YOUR ANSWER - Create geography dimension:
CREATE TABLE dim_geography (
    -- Define your geography dimension structure
);

/*
TASK 4.2: Design Fact Table
Create the fact table for sales transactions:
*/

-- YOUR ANSWER - Create sales fact table:
CREATE TABLE fact_sales (
    -- Define your fact table structure with foreign keys to dimensions
    -- Include measures like quantity, unit_price, total_amount, discount, etc.
);

/*
TASK 4.3: Handle Slowly Changing Dimensions
Implement SCD Type 2 for product price changes:
- Track historical prices
- Maintain effective date ranges
- Preserve historical accuracy
*/

-- YOUR ANSWER - Implement SCD Type 2 for products:


/*
TASK 4.4: Create Aggregate Tables
Create pre-aggregated fact tables for common queries:
- Monthly sales by product category
- Quarterly sales by customer segment
- Annual sales by geography
*/

-- YOUR ANSWER - Create aggregate tables:


-- ============================================
-- EXERCISE 5: Complex Data Modeling Scenarios
-- ============================================

/*
SCENARIO 1: Multi-Tenant SaaS Application

Design a database schema for a multi-tenant SaaS application where:
- Multiple companies (tenants) use the same application
- Each tenant's data must be isolated
- Some reference data is shared across tenants
- The schema must support different tenant sizes efficiently

TASK 5.1: Choose and Implement a Multi-Tenancy Strategy
Options:
1. Separate Database per Tenant
2. Separate Schema per Tenant  
3. Shared Schema with Tenant ID
4. Hybrid Approach

Justify your choice and implement the schema:
*/

-- YOUR ANSWER - Multi-tenant schema design:


/*
SCENARIO 2: Temporal Data Modeling

Design a schema for tracking employee salary history that supports:
- Valid time (when the salary was actually in effect)
- Transaction time (when the change was recorded in the database)
- Bitemporal queries (combining both time dimensions)

TASK 5.2: Implement Bitemporal Tables
*/

-- YOUR ANSWER - Bitemporal employee salary tracking:


/*
SCENARIO 3: Graph-Like Relationships in Relational Database

Design a schema for a social network that supports:
- User connections (friends, followers)
- Posts and comments with nested replies
- Content sharing and reposting
- Activity feeds

TASK 5.3: Model Graph Relationships
*/

-- YOUR ANSWER - Social network schema with graph-like structures:


-- ============================================
-- EXERCISE 6: Performance-Driven Data Modeling
-- ============================================

/*
SCENARIO: High-Volume Transaction System

Design a schema for a payment processing system that handles:
- 10,000+ transactions per second
- Real-time fraud detection
- Regulatory compliance (audit trails)
- Geographic distribution

TASK 6.1: Design for High Performance
Consider:
- Partitioning strategies
- Index optimization
- Denormalization for read performance
- Archival strategies
*/

-- YOUR ANSWER - High-performance payment system schema:


/*
TASK 6.2: Implement Audit Trail Design
Create a comprehensive audit system that tracks:
- All data changes (insert, update, delete)
- User actions and timestamps
- Before and after values
- Regulatory compliance fields
*/

-- YOUR ANSWER - Audit trail implementation:


-- ============================================
-- EXERCISE 7: NoSQL vs SQL Data Modeling
-- ============================================

/*
SCENARIO: Hybrid Data Architecture

You need to model data for an e-commerce platform that uses both SQL and NoSQL:
- Transactional data (orders, payments) in SQL
- Product catalog and search in NoSQL (document store)
- User behavior analytics in NoSQL (time series)
- Recommendations in graph database

TASK 7.1: Design Data Flow and Synchronization
Show how data flows between different data stores:
*/

-- YOUR ANSWER - Describe hybrid architecture and create SQL components:


-- ============================================
-- EXERCISE 8: Data Modeling Patterns
-- ============================================

/*
TASK 8.1: Implement Common Patterns

A. Party Pattern (Person/Organization abstraction)
Create a flexible schema that can handle both individual customers and corporate customers:
*/

-- YOUR ANSWER - Party pattern implementation:


/*
B. Account/Transaction Pattern
Design a flexible accounting system that supports:
- Multiple account types
- Different transaction types
- Balance calculations
- Audit requirements
*/

-- YOUR ANSWER - Account/Transaction pattern:


/*
C. Configuration/Settings Pattern
Design a flexible configuration system that supports:
- Different data types (string, number, boolean, JSON)
- Hierarchical configurations
- Environment-specific settings
- Default value inheritance
*/

-- YOUR ANSWER - Configuration pattern:


-- ============================================
-- EXERCISE 9: Data Quality and Validation Modeling
-- ============================================

/*
TASK 9.1: Design Data Quality Framework
Create tables and constraints that ensure:
- Data completeness
- Data accuracy
- Data consistency
- Data timeliness
*/

-- YOUR ANSWER - Data quality framework:


/*
TASK 9.2: Implement Business Rule Validation
Create a flexible rule engine that can validate:
- Cross-table business rules
- Complex calculations
- Time-based validations
- Custom validation logic
*/

-- YOUR ANSWER - Business rule validation system:


-- ============================================
-- EXERCISE 10: Advanced Modeling Techniques
-- ============================================

/*
TASK 10.1: Model Hierarchical Data
Implement different approaches to model hierarchical data:

A. Adjacency List Model
B. Nested Set Model  
C. Path Enumeration Model
D. Closure Table Model

Compare the pros and cons of each approach:
*/

-- YOUR ANSWER - Hierarchical data models:


/*
TASK 10.2: Implement Soft Delete Pattern
Design a system that supports:
- Logical deletion (soft delete)
- Physical deletion (hard delete)
- Restoration capabilities
- Audit trails for deletions
*/

-- YOUR ANSWER - Soft delete implementation:


-- ============================================
-- VERIFICATION AND TESTING QUERIES
-- ============================================

-- Test your normalized schema
SELECT 'Testing normalized schema integrity' AS test_section;

-- Verify no redundant data
-- YOUR VERIFICATION QUERIES HERE

-- Test your denormalized tables
SELECT 'Testing denormalized table performance' AS test_section;

-- Compare query performance between normalized and denormalized
-- YOUR PERFORMANCE TEST QUERIES HERE

-- Test your dimensional model
SELECT 'Testing dimensional model queries' AS test_section;

-- Typical OLAP queries (drill-down, roll-up, slice, dice)
-- YOUR OLAP QUERIES HERE

-- ============================================
-- REAL-WORLD CASE STUDIES
-- ============================================

/*
CASE STUDY 1: Netflix-Style Streaming Service
Design a complete data model for a streaming service that supports:
- User management and subscriptions
- Content catalog with metadata
- Viewing history and recommendations
- Rating and review system
- Content delivery optimization

Requirements:
- Support for multiple device types
- Offline viewing capabilities
- Parental controls
- Content licensing and regional restrictions
- Analytics for content popularity

YOUR SOLUTION:
*/

/*
CASE STUDY 2: Banking Core System
Design a data model for a modern banking system that supports:
- Account management (checking, savings, loans, credit cards)
- Transaction processing
- Interest calculations
- Regulatory reporting
- Fraud detection
- Multi-currency support

Requirements:
- ACID compliance
- Audit trails
- Real-time balance calculations
- Historical data retention
- Integration with external systems

YOUR SOLUTION:
*/

/*
CASE STUDY 3: Healthcare Management System
Design a data model for a hospital management system that supports:
- Patient records and medical history
- Appointment scheduling
- Staff management
- Billing and insurance
- Pharmacy management
- Medical equipment tracking

Requirements:
- HIPAA compliance
- Emergency access protocols
- Integration with medical devices
- Clinical decision support
- Research data anonymization

YOUR SOLUTION:
*/

-- ============================================
-- REFLECTION QUESTIONS
-- ============================================

/*
1. When should you choose normalization over denormalization?

2. How do you balance data integrity with query performance?

3. What factors influence your choice of dimensional modeling vs. normalized modeling?

4. How do you handle evolving business requirements in your data models?

5. What are the trade-offs between different multi-tenancy strategies?

6. How do you model temporal data effectively?

7. When is it appropriate to use hybrid SQL/NoSQL architectures?

8. How do you ensure data quality in your models?

Answer these questions:

1. 

2. 

3. 

4. 

5. 

6. 

7. 

8. 

*/

-- ============================================
-- COMPLETION CHECKLIST
-- ============================================
/*
□ Designed ERD for university system
□ Applied 1NF, 2NF, and 3NF normalization
□ Created denormalized tables for analytics
□ Designed dimensional model (star schema)
□ Implemented slowly changing dimensions
□ Handled multi-tenant data modeling
□ Modeled temporal/bitemporal data
□ Designed graph-like relationships
□ Created high-performance schemas
□ Implemented audit trail systems
□ Designed hybrid SQL/NoSQL architecture
□ Applied common data modeling patterns
□ Created data quality framework
□ Modeled hierarchical data structures
□ Implemented soft delete patterns
□ Completed real-world case studies
□ Answered reflection questions
*/