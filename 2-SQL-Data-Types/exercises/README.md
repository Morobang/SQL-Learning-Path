# 🏋️ SQL Data Types - Practice Exercises

Test your understanding of SQL data types with these hands-on exercises.

## 📊 Practice Scenario: Online Bookstore Database

Create tables for an online bookstore using appropriate data types.

## 🎯 Exercise Set 1: Table Design with Data Types

### Exercise 1.1: Authors Table
**Problem**: Design an authors table with the following requirements:
- Author ID (unique identifier)
- Full name (up to 100 characters)
- Biography (large text, optional)
- Birth date (date only)
- Country (3-letter code like USA, GBR)
- Is active (true/false)

**Your Task**: Write the CREATE TABLE statement with appropriate data types.

**Expected Considerations**:
- What's the best ID type?
- Should name be VARCHAR or CHAR?
- How to handle optional biography?
- Date vs DateTime for birth date?

---

### Exercise 1.2: Books Table  
**Problem**: Design a books table with these requirements:
- Book ID (unique identifier)
- ISBN (13 characters, always present)
- Title (up to 255 characters)
- Description (large text, optional)
- Publication date (date only)
- Page count (whole number, could be large)
- Price (currency, must be precise)
- Discount percentage (0-100, with decimals)
- In stock (true/false)
- Stock quantity (whole number, never negative)

**Your Task**: Create the table with proper data types and constraints.

---

### Exercise 1.3: Orders Table
**Problem**: Design an orders table with these requirements:
- Order ID (unique identifier)
- Customer email (valid email format, up to 255 chars)
- Order timestamp (exact date and time)
- Subtotal (currency, precise)
- Tax amount (currency, precise)  
- Shipping cost (currency, precise)
- Total amount (currency, precise)
- Order status (one of: 'pending', 'processing', 'shipped', 'delivered', 'cancelled')
- Tracking number (optional, up to 50 chars)

**Your Task**: Design the table with appropriate types and constraints.

---

## 🎯 Exercise Set 2: Data Type Comparison

### Exercise 2.1: Numeric Type Selection
**Problem**: For each scenario, choose the best numeric data type and explain why:

1. **Student grades** (0-100, no decimals)
2. **Product prices** ($0.01 to $99,999.99)
3. **Scientific measurements** (very large/small numbers, approximations OK)
4. **Population counts** (could exceed 2 billion)
5. **Percentage values** (0.00% to 100.00%)

**Your Task**: List the best data type for each and justify your choice.

---

### Exercise 2.2: String Type Selection
**Problem**: Choose the best string type for each:

1. **US state codes** (always 2 characters: CA, NY, TX)
2. **Product names** (vary from 5-200 characters)
3. **Blog post content** (could be very long)
4. **Phone numbers** (various formats, up to 20 chars)
5. **User passwords** (hashed, always 60 characters)

**Your Task**: Select appropriate string types and explain your reasoning.

---

## 🎯 Exercise Set 3: NULL and Default Handling

### Exercise 3.1: Default Values Design
**Problem**: Add appropriate DEFAULT values to this table:

```sql
CREATE TABLE user_profiles (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    registration_date DATE,
    last_login DATETIME,
    is_active BOOLEAN,
    preferred_language CHAR(2),
    timezone VARCHAR(50),
    notification_enabled BOOLEAN
);
```

**Your Task**: Modify the table to include sensible default values.

---

### Exercise 3.2: NULL Handling Strategy
**Problem**: For each field, decide if it should allow NULL and explain why:

1. **Customer first name**
2. **Customer middle name**  
3. **Customer last name**
4. **Customer phone number**
5. **Customer birth date**
6. **Order delivery instructions**
7. **Product weight**
8. **Employee salary**

**Your Task**: Mark each as NULL or NOT NULL and justify your decisions.

---

## 🎯 Exercise Set 4: Real-World Application

### Exercise 4.1: E-commerce Product Catalog
**Problem**: Design a complete product catalog with these entities:
- Categories (electronics, books, clothing, etc.)
- Products (name, description, price, etc.)
- Product variants (size, color, etc.)
- Inventory tracking

**Your Task**: Create all necessary tables with proper data types.

**Requirements**:
- Support for hierarchical categories
- Variable pricing (sales, discounts)
- Track inventory levels
- Handle product variants (same product, different size/color)
- Store product images (URLs)
- Track when products were added/modified

---

### Exercise 4.2: User Management System
**Problem**: Design a user system with these features:
- User accounts with profiles
- Role-based permissions
- Login history tracking
- Password reset functionality

**Your Task**: Design the database schema with appropriate data types.

**Consider**:
- User identification methods
- Password storage (security)
- Session management
- Audit trail requirements
- Performance for frequent logins

---

## ✅ Self-Assessment Checklist

After completing these exercises, you should be comfortable with:

- [ ] Choosing between INT, BIGINT, and SMALLINT
- [ ] Using DECIMAL for financial data
- [ ] Deciding between VARCHAR and CHAR
- [ ] Handling large text with TEXT fields
- [ ] Working with DATE vs DATETIME vs TIMESTAMP
- [ ] Implementing NULL vs NOT NULL appropriately
- [ ] Setting useful DEFAULT values
- [ ] Considering storage efficiency
- [ ] Planning for data growth
- [ ] Understanding database-specific variations

## 🎯 Difficulty Levels

- **Beginner** (Exercises 1.1-1.3): Basic table design with common data types
- **Intermediate** (Exercises 2.1-3.2): Data type selection and NULL handling
- **Advanced** (Exercises 4.1-4.2): Complex schema design with real-world requirements

## 💡 Tips for Success

1. **Think about the data first**: What values will actually be stored?
2. **Consider edge cases**: What's the largest/smallest possible value?
3. **Plan for growth**: Will the data requirements change over time?
4. **Performance matters**: Smaller data types are faster to query
5. **Be consistent**: Use the same patterns throughout your schema

## 🚀 Next Steps

After mastering these exercises:
1. Check your solutions against [solutions.sql](./solutions.sql)
2. Try designing schemas for your own projects
3. Move on to [3-Basic-Queries](../../3-Basic-Queries/README.md)
4. Practice with real datasets to validate your type choices

---
[← Back to Data Types](../README.md) | [View Solutions →](./solutions.sql)