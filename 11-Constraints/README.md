# 🔒 Database Constraints

Master data integrity and business rule enforcement through comprehensive constraint implementation.

## 📋 What You'll Learn

This section covers all types of database constraints that ensure data quality, consistency, and enforce business rules at the database level.

### Core Topics
- **Primary Key Constraints**: Unique identification and entity integrity
- **Foreign Key Constraints**: Referential integrity between tables
- **Unique Constraints**: Preventing duplicate values
- **NOT NULL Constraints**: Ensuring required data
- **Check Constraints**: Custom business rule validation
- **Default Values**: Automatic data population

## 📁 Folder Structure

```
11-Constraints/
├── concepts/           # Theory and explanations
│   ├── primary-key.md
│   ├── foreign-key.md
│   ├── unique-constraint.md
│   ├── not-null-constraint.md
│   ├── check-constraint.md
│   └── default-values.md
├── examples/           # Practical SQL examples
│   ├── 01-primary-key-examples.sql
│   ├── 02-foreign-key-examples.sql
│   ├── 03-unique-constraint-examples.sql
│   └── 04-check-constraint-examples.sql
├── exercises/          # Practice problems
│   └── constraint-exercises.sql
└── resources/          # Additional learning materials
    └── constraint-resources.md
```

## 🎯 Learning Objectives

By the end of this section, you will:

1. **Master Primary Keys**
   - Design effective primary key strategies
   - Understand surrogate vs natural keys
   - Implement composite primary keys
   - Handle primary key conflicts and resolution

2. **Implement Foreign Keys**
   - Create referential integrity relationships
   - Handle cascade operations (UPDATE/DELETE)
   - Understand foreign key performance implications
   - Design complex relationship patterns

3. **Apply Data Validation**
   - Use CHECK constraints for business rules
   - Implement domain-specific validations
   - Create table-level constraints
   - Handle constraint violations gracefully

4. **Ensure Data Quality**
   - Prevent NULL values where inappropriate
   - Enforce unique business identifiers
   - Set up intelligent default values
   - Create comprehensive validation strategies

## 🚀 Quick Start

1. **Start with Concepts**: Understand why constraints are crucial for data integrity
2. **Study Examples**: See real-world constraint implementations
3. **Practice**: Apply constraints to sample database designs
4. **Explore Resources**: Learn advanced constraint techniques

## 💡 Key Concepts Preview

### Primary Key Constraints
```sql
-- Simple primary key
CREATE TABLE customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Composite primary key
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### Foreign Key Constraints
```sql
-- Basic foreign key with cascade
CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

### Check Constraints
```sql
-- Business rule validation
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT,
    salary DECIMAL(10,2),
    department VARCHAR(50),
    CONSTRAINT chk_age CHECK (age >= 18 AND age <= 65),
    CONSTRAINT chk_salary CHECK (salary > 0),
    CONSTRAINT chk_department CHECK (department IN ('HR', 'IT', 'Finance', 'Marketing'))
);
```

### Unique Constraints
```sql
-- Multiple unique constraints
CREATE TABLE products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    product_code VARCHAR(20) UNIQUE NOT NULL,
    barcode VARCHAR(50) UNIQUE,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) CHECK (price > 0)
);
```

## 🔗 Prerequisites

Before starting this section, make sure you're comfortable with:
- Database design fundamentals (Section 12)
- Table creation and modification
- Basic SQL operations (Sections 1-4)
- Understanding of relationships between tables

## ➡️ Next Steps

After completing this section, you'll be ready for:
- **Advanced Queries** (Section 13): Query constrained data effectively
- **Performance Tuning** (Section 14): Optimize constraint performance
- **Database Administration** (Section 16): Manage constraints in production

## 🎯 Real-World Applications

- **E-commerce**: Product codes, customer emails, order integrity
- **Financial Systems**: Account numbers, transaction validation, balance checks
- **Healthcare**: Patient IDs, medical record integrity, regulatory compliance
- **Inventory Management**: SKU uniqueness, stock level validation, supplier relationships

## ⚠️ Common Constraint Scenarios

### Data Integrity Issues
- **Orphaned Records**: Foreign key constraints prevent
- **Duplicate Data**: Unique constraints eliminate
- **Invalid Data**: Check constraints validate
- **Missing Data**: NOT NULL constraints require

### Business Rule Enforcement
- **Age Restrictions**: Check constraints for valid age ranges
- **Status Validation**: Enum-like constraints for status fields
- **Cross-table Validation**: Complex business rules across multiple tables
- **Temporal Constraints**: Date range validations and logical sequences

## 📊 Constraint Performance Impact

### Benefits
- ✅ **Data Quality**: Automatic validation prevents bad data
- ✅ **Business Rules**: Database enforces critical rules
- ✅ **Query Optimization**: Constraints help query optimizer
- ✅ **Application Simplicity**: Less validation code needed

### Considerations
- ⚠️ **Insert Performance**: Constraint checking adds overhead
- ⚠️ **Bulk Operations**: Large data loads may need constraint management
- ⚠️ **Cascade Operations**: Can impact performance on related tables
- ⚠️ **Lock Contention**: Foreign keys can create additional locking

## 🛠️ Constraint Management

### Creation Strategies
```sql
-- Add constraints to existing tables
ALTER TABLE customers
ADD CONSTRAINT uk_customers_email UNIQUE (email);

-- Temporarily disable constraints for bulk operations
ALTER TABLE orders NOCHECK CONSTRAINT fk_orders_customer;
-- Bulk operation here
ALTER TABLE orders CHECK CONSTRAINT fk_orders_customer;
```

### Monitoring and Maintenance
```sql
-- Check constraint violations
SELECT * FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS;

-- Find foreign key relationships
SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS;

-- Validate constraint integrity
DBCC CHECKCONSTRAINTS;
```

## 🏆 Best Practices

1. **Design Phase**
   - Plan constraints during database design
   - Document business rules clearly
   - Consider performance implications
   - Use meaningful constraint names

2. **Implementation**
   - Add constraints incrementally
   - Test with real data volumes
   - Plan for constraint violations
   - Create informative error messages

3. **Maintenance**
   - Regularly monitor constraint violations
   - Update constraints as business rules change
   - Coordinate with application development
   - Plan for database migrations

## 🔍 Troubleshooting Guide

### Common Issues
- **Constraint Violations**: Identify and fix data quality issues
- **Performance Problems**: Optimize constraint checking
- **Cascade Conflicts**: Resolve circular foreign key dependencies
- **Bulk Load Failures**: Manage constraints during data imports

Build bulletproof databases with rock-solid data integrity! 🔒🛡️