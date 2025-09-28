/*
===============================================
    DATA MODELING EXAMPLES
    Practical Examples of Normalization, Denormalization, ERD Design, and Dimensional Modeling
===============================================
*/

-- ============================================
-- EXAMPLE 1: ENTITY-RELATIONSHIP DIAGRAM (ERD) TO PHYSICAL SCHEMA
-- ============================================

-- SCENARIO: Library Management System

DROP DATABASE IF EXISTS library_system;
CREATE DATABASE library_system;
USE library_system;

-- Step 1: Identify Entities and Relationships
/*
Entities:
- Author (author_id, first_name, last_name, birth_date, nationality)
- Book (book_id, title, isbn, publication_year, pages, genre)
- Publisher (publisher_id, name, address, phone, email)
- Member (member_id, first_name, last_name, email, phone, join_date, membership_type)
- Librarian (librarian_id, first_name, last_name, email, hire_date, shift)
- Loan (loan_id, book_id, member_id, librarian_id, checkout_date, due_date, return_date, fine_amount)

Relationships:
- Author writes Book (Many-to-Many)
- Book published by Publisher (Many-to-One)
- Member borrows Book (Many-to-Many through Loan)
- Librarian processes Loan (One-to-Many)
*/

-- Step 2: Physical Schema Implementation

-- Publishers table (Independent entity)
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100),
    established_year INT,
    
    CONSTRAINT uk_publishers_name UNIQUE (publisher_name)
);

-- Authors table (Independent entity)
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    death_date DATE,
    nationality VARCHAR(50),
    biography TEXT,
    
    INDEX idx_authors_name (last_name, first_name)
);

-- Books table (Dependent on Publisher)
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publication_year INT,
    pages INT,
    genre VARCHAR(50),
    publisher_id INT,
    language VARCHAR(30) DEFAULT 'English',
    availability_status ENUM('available', 'borrowed', 'reserved', 'maintenance') DEFAULT 'available',
    
    CONSTRAINT fk_books_publisher 
        FOREIGN KEY (publisher_id) 
        REFERENCES publishers(publisher_id),
        
    CONSTRAINT chk_books_year 
        CHECK (publication_year >= 1000 AND publication_year <= YEAR(CURDATE())),
        
    CONSTRAINT chk_books_pages 
        CHECK (pages > 0),
        
    INDEX idx_books_title (title),
    INDEX idx_books_genre (genre),
    INDEX idx_books_year (publication_year)
);

-- Book-Author junction table (Many-to-Many relationship)
CREATE TABLE book_authors (
    book_id INT,
    author_id INT,
    author_role ENUM('primary', 'co-author', 'editor', 'translator') DEFAULT 'primary',
    
    PRIMARY KEY (book_id, author_id),
    
    CONSTRAINT fk_book_authors_book 
        FOREIGN KEY (book_id) 
        REFERENCES books(book_id) 
        ON DELETE CASCADE,
        
    CONSTRAINT fk_book_authors_author 
        FOREIGN KEY (author_id) 
        REFERENCES authors(author_id) 
        ON DELETE CASCADE
);

-- Members table (Independent entity)
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    join_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    membership_type ENUM('student', 'faculty', 'public', 'senior') NOT NULL,
    membership_expiry DATE,
    is_active BOOLEAN DEFAULT TRUE,
    
    INDEX idx_members_name (last_name, first_name),
    INDEX idx_members_type (membership_type)
);

-- Librarians table (Independent entity)
CREATE TABLE librarians (
    librarian_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE NOT NULL,
    shift ENUM('morning', 'afternoon', 'evening') NOT NULL,
    department VARCHAR(50) DEFAULT 'Circulation',
    is_active BOOLEAN DEFAULT TRUE
);

-- Loans table (Intersection entity with additional attributes)
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    librarian_id INT NOT NULL,
    checkout_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    return_date DATE,
    fine_amount DECIMAL(8,2) DEFAULT 0.00,
    loan_status ENUM('active', 'returned', 'overdue', 'lost') DEFAULT 'active',
    
    CONSTRAINT fk_loans_book 
        FOREIGN KEY (book_id) 
        REFERENCES books(book_id),
        
    CONSTRAINT fk_loans_member 
        FOREIGN KEY (member_id) 
        REFERENCES members(member_id),
        
    CONSTRAINT fk_loans_librarian 
        FOREIGN KEY (librarian_id) 
        REFERENCES librarians(librarian_id),
        
    CONSTRAINT chk_loans_dates 
        CHECK (due_date >= checkout_date),
        
    CONSTRAINT chk_loans_return_date 
        CHECK (return_date IS NULL OR return_date >= checkout_date),
        
    CONSTRAINT chk_loans_fine 
        CHECK (fine_amount >= 0),
        
    INDEX idx_loans_member (member_id),
    INDEX idx_loans_book (book_id),
    INDEX idx_loans_dates (checkout_date, due_date),
    INDEX idx_loans_status (loan_status)
);

-- Sample Data
INSERT INTO publishers (publisher_name, address, phone, email, established_year) VALUES
('Penguin Random House', '1745 Broadway, New York, NY', '212-782-9000', 'info@penguinrandomhouse.com', 1927),
('HarperCollins', '195 Broadway, New York, NY', '212-207-7000', 'info@harpercollins.com', 1819),
('Simon & Schuster', '1230 Avenue of the Americas, New York, NY', '212-698-7000', 'info@simonandschuster.com', 1924);

INSERT INTO authors (first_name, last_name, birth_date, nationality, biography) VALUES
('George', 'Orwell', '1903-06-25', 'British', 'English novelist and journalist known for Animal Farm and 1984'),
('Jane', 'Austen', '1775-12-16', 'British', 'English novelist known for Pride and Prejudice and Emma'),
('Mark', 'Twain', '1835-11-30', 'American', 'American writer known for Adventures of Tom Sawyer and Huckleberry Finn');

INSERT INTO books (title, isbn, publication_year, pages, genre, publisher_id, language) VALUES
('1984', '978-0-452-28423-4', 1949, 328, 'Dystopian Fiction', 1, 'English'),
('Animal Farm', '978-0-452-28424-1', 1945, 95, 'Political Satire', 1, 'English'),
('Pride and Prejudice', '978-0-14-143951-8', 1813, 432, 'Romance', 2, 'English'),
('Adventures of Tom Sawyer', '978-0-486-40077-6', 1876, 274, 'Adventure', 3, 'English');

INSERT INTO book_authors (book_id, author_id, author_role) VALUES
(1, 1, 'primary'),
(2, 1, 'primary'),
(3, 2, 'primary'),
(4, 3, 'primary');

INSERT INTO members (first_name, last_name, email, phone, membership_type, membership_expiry) VALUES
('John', 'Doe', 'john.doe@email.com', '555-0101', 'public', '2024-12-31'),
('Jane', 'Smith', 'jane.smith@university.edu', '555-0102', 'faculty', '2025-06-30'),
('Bob', 'Johnson', 'bob.johnson@student.edu', '555-0103', 'student', '2024-08-31');

INSERT INTO librarians (employee_id, first_name, last_name, email, hire_date, shift) VALUES
('LIB001', 'Alice', 'Wilson', 'alice.wilson@library.org', '2020-03-15', 'morning'),
('LIB002', 'David', 'Brown', 'david.brown@library.org', '2019-08-20', 'afternoon');

INSERT INTO loans (book_id, member_id, librarian_id, due_date) VALUES
(1, 1, 1, DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY)),
(3, 2, 2, DATE_ADD(CURRENT_DATE, INTERVAL 21 DAY)),
(4, 3, 1, DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY));

-- ============================================
-- EXAMPLE 2: NORMALIZATION PROCESS
-- ============================================

-- SCENARIO: Student Course Registration (Unnormalized to 3NF)

-- Step 1: Unnormalized Table (0NF)
CREATE TABLE student_courses_unnormalized (
    student_id INT,
    student_name VARCHAR(100),
    student_email VARCHAR(100),
    student_major VARCHAR(50),
    advisor_name VARCHAR(100),
    advisor_office VARCHAR(20),
    course_codes VARCHAR(200),  -- "CS101,MATH201,ENG101"
    course_names VARCHAR(500),  -- "Intro to Programming,Calculus,English Composition"
    course_credits VARCHAR(50), -- "3,4,3"
    instructors VARCHAR(200),   -- "Dr. Smith,Prof. Jones,Ms. Davis"
    semester VARCHAR(20),
    year INT
);

-- Step 2: First Normal Form (1NF) - Eliminate repeating groups
CREATE TABLE student_courses_1nf (
    student_id INT,
    student_name VARCHAR(100),
    student_email VARCHAR(100),
    student_major VARCHAR(50),
    advisor_name VARCHAR(100),
    advisor_office VARCHAR(20),
    course_code VARCHAR(10),
    course_name VARCHAR(100),
    course_credits INT,
    instructor_name VARCHAR(100),
    semester VARCHAR(20),
    year INT
);

-- Sample 1NF data
INSERT INTO student_courses_1nf VALUES
(1001, 'John Doe', 'john@student.edu', 'Computer Science', 'Dr. Wilson', 'CS-201', 'CS101', 'Intro to Programming', 3, 'Dr. Smith', 'Fall', 2024),
(1001, 'John Doe', 'john@student.edu', 'Computer Science', 'Dr. Wilson', 'CS-201', 'MATH201', 'Calculus', 4, 'Prof. Jones', 'Fall', 2024),
(1001, 'John Doe', 'john@student.edu', 'Computer Science', 'Dr. Wilson', 'CS-201', 'ENG101', 'English Composition', 3, 'Ms. Davis', 'Fall', 2024),
(1002, 'Jane Smith', 'jane@student.edu', 'Mathematics', 'Prof. Taylor', 'MATH-105', 'MATH201', 'Calculus', 4, 'Prof. Jones', 'Fall', 2024),
(1002, 'Jane Smith', 'jane@student.edu', 'Mathematics', 'Prof. Taylor', 'MATH-105', 'STAT301', 'Statistics', 3, 'Dr. Brown', 'Fall', 2024);

-- Step 3: Second Normal Form (2NF) - Eliminate partial dependencies
-- Identify partial dependencies: course_name, course_credits, instructor_name depend only on course_code

CREATE TABLE students_2nf (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    student_email VARCHAR(100),
    student_major VARCHAR(50),
    advisor_name VARCHAR(100),
    advisor_office VARCHAR(20)
);

CREATE TABLE courses_2nf (
    course_code VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(100),
    course_credits INT,
    instructor_name VARCHAR(100)
);

CREATE TABLE enrollments_2nf (
    student_id INT,
    course_code VARCHAR(10),
    semester VARCHAR(20),
    year INT,
    PRIMARY KEY (student_id, course_code, semester, year),
    FOREIGN KEY (student_id) REFERENCES students_2nf(student_id),
    FOREIGN KEY (course_code) REFERENCES courses_2nf(course_code)
);

-- Step 4: Third Normal Form (3NF) - Eliminate transitive dependencies
-- Identify transitive dependencies: advisor_office depends on advisor_name, not student_id

CREATE TABLE advisors_3nf (
    advisor_id INT AUTO_INCREMENT PRIMARY KEY,
    advisor_name VARCHAR(100) UNIQUE,
    advisor_office VARCHAR(20)
);

CREATE TABLE students_3nf (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    student_email VARCHAR(100),
    student_major VARCHAR(50),
    advisor_id INT,
    FOREIGN KEY (advisor_id) REFERENCES advisors_3nf(advisor_id)
);

CREATE TABLE instructors_3nf (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    instructor_name VARCHAR(100) UNIQUE
);

CREATE TABLE courses_3nf (
    course_code VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(100),
    course_credits INT,
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors_3nf(instructor_id)
);

CREATE TABLE enrollments_3nf (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_code VARCHAR(10),
    semester VARCHAR(20),
    year INT,
    grade VARCHAR(2),
    UNIQUE KEY uk_enrollment (student_id, course_code, semester, year),
    FOREIGN KEY (student_id) REFERENCES students_3nf(student_id),
    FOREIGN KEY (course_code) REFERENCES courses_3nf(course_code)
);

-- Insert normalized data
INSERT INTO advisors_3nf (advisor_name, advisor_office) VALUES
('Dr. Wilson', 'CS-201'),
('Prof. Taylor', 'MATH-105');

INSERT INTO students_3nf (student_id, student_name, student_email, student_major, advisor_id) VALUES
(1001, 'John Doe', 'john@student.edu', 'Computer Science', 1),
(1002, 'Jane Smith', 'jane@student.edu', 'Mathematics', 2);

INSERT INTO instructors_3nf (instructor_name) VALUES
('Dr. Smith'),
('Prof. Jones'),
('Ms. Davis'),
('Dr. Brown');

INSERT INTO courses_3nf (course_code, course_name, course_credits, instructor_id) VALUES
('CS101', 'Intro to Programming', 3, 1),
('MATH201', 'Calculus', 4, 2),
('ENG101', 'English Composition', 3, 3),
('STAT301', 'Statistics', 3, 4);

INSERT INTO enrollments_3nf (student_id, course_code, semester, year) VALUES
(1001, 'CS101', 'Fall', 2024),
(1001, 'MATH201', 'Fall', 2024),
(1001, 'ENG101', 'Fall', 2024),
(1002, 'MATH201', 'Fall', 2024),
(1002, 'STAT301', 'Fall', 2024);

-- ============================================
-- EXAMPLE 3: DENORMALIZATION FOR PERFORMANCE
-- ============================================

-- SCENARIO: E-commerce Order Reporting System

-- Normalized schema (for transactional operations)
CREATE TABLE customers_norm (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE products_norm (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    unit_price DECIMAL(10,2)
);

CREATE TABLE orders_norm (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers_norm(customer_id)
);

CREATE TABLE order_details_norm (
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders_norm(order_id),
    FOREIGN KEY (product_id) REFERENCES products_norm(product_id)
);

-- Denormalized table for reporting (read-optimized)
CREATE TABLE order_reporting_denorm (
    -- Order information
    order_id INT,
    order_date DATE,
    order_year INT,
    order_month INT,
    order_quarter INT,
    
    -- Customer information (denormalized)
    customer_id INT,
    customer_name VARCHAR(100),  -- Combined first_name + last_name
    customer_email VARCHAR(100),
    customer_city VARCHAR(50),
    customer_state VARCHAR(50),
    customer_country VARCHAR(50),
    
    -- Product information (denormalized)
    product_id INT,
    product_name VARCHAR(100),
    product_category VARCHAR(50),
    product_subcategory VARCHAR(50),
    
    -- Order line details
    quantity INT,
    unit_price DECIMAL(10,2),
    line_total DECIMAL(10,2),  -- Calculated: quantity * unit_price
    
    -- Aggregated order information
    order_total_amount DECIMAL(10,2),
    order_item_count INT,  -- Total items in the order
    
    -- Pre-calculated business metrics
    revenue DECIMAL(10,2),  -- Same as line_total for this example
    
    -- Indexes for reporting queries
    INDEX idx_reporting_date (order_date),
    INDEX idx_reporting_customer (customer_id),
    INDEX idx_reporting_product (product_id),
    INDEX idx_reporting_category (product_category),
    INDEX idx_reporting_location (customer_country, customer_state),
    INDEX idx_reporting_time (order_year, order_month)
);

-- Sample data for normalized tables
INSERT INTO customers_norm (first_name, last_name, email, city, state, country) VALUES
('John', 'Doe', 'john@email.com', 'New York', 'NY', 'USA'),
('Jane', 'Smith', 'jane@email.com', 'Los Angeles', 'CA', 'USA'),
('Bob', 'Wilson', 'bob@email.com', 'London', '', 'UK');

INSERT INTO products_norm (product_name, category, subcategory, unit_price) VALUES
('iPhone 15', 'Electronics', 'Smartphones', 999.99),
('MacBook Pro', 'Electronics', 'Laptops', 1999.99),
('AirPods Pro', 'Electronics', 'Audio', 249.99),
('Office Chair', 'Furniture', 'Chairs', 299.99);

INSERT INTO orders_norm (customer_id, order_date, total_amount) VALUES
(1, '2024-01-15', 1249.98),
(2, '2024-01-16', 1999.99),
(3, '2024-01-17', 549.98);

INSERT INTO order_details_norm (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 999.99),
(1, 3, 1, 249.99),
(2, 2, 1, 1999.99),
(3, 3, 1, 249.99),
(3, 4, 1, 299.99);

-- Populate denormalized table using a stored procedure or ETL process
INSERT INTO order_reporting_denorm (
    order_id, order_date, order_year, order_month, order_quarter,
    customer_id, customer_name, customer_email, customer_city, customer_state, customer_country,
    product_id, product_name, product_category, product_subcategory,
    quantity, unit_price, line_total, order_total_amount, order_item_count, revenue
)
SELECT 
    o.order_id,
    o.order_date,
    YEAR(o.order_date) as order_year,
    MONTH(o.order_date) as order_month,
    QUARTER(o.order_date) as order_quarter,
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    c.email as customer_email,
    c.city as customer_city,
    c.state as customer_state,
    c.country as customer_country,
    p.product_id,
    p.product_name,
    p.category as product_category,
    p.subcategory as product_subcategory,
    od.quantity,
    od.unit_price,
    (od.quantity * od.unit_price) as line_total,
    o.total_amount as order_total_amount,
    (SELECT COUNT(*) FROM order_details_norm od2 WHERE od2.order_id = o.order_id) as order_item_count,
    (od.quantity * od.unit_price) as revenue
FROM orders_norm o
JOIN customers_norm c ON o.customer_id = c.customer_id
JOIN order_details_norm od ON o.order_id = od.order_id
JOIN products_norm p ON od.product_id = p.product_id;

-- Example reporting queries (much faster on denormalized table)
-- Monthly sales by category
SELECT 
    order_year,
    order_month,
    product_category,
    SUM(revenue) as total_revenue,
    COUNT(DISTINCT order_id) as order_count,
    SUM(quantity) as units_sold
FROM order_reporting_denorm
GROUP BY order_year, order_month, product_category
ORDER BY order_year, order_month, total_revenue DESC;

-- Customer analysis
SELECT 
    customer_country,
    customer_state,
    COUNT(DISTINCT customer_id) as unique_customers,
    COUNT(DISTINCT order_id) as total_orders,
    SUM(revenue) as total_revenue,
    AVG(order_total_amount) as avg_order_value
FROM order_reporting_denorm
GROUP BY customer_country, customer_state
ORDER BY total_revenue DESC;

-- ============================================
-- EXAMPLE 4: DIMENSIONAL MODELING (STAR SCHEMA)
-- ============================================

-- SCENARIO: Sales Data Warehouse for Retail Chain

-- Time Dimension
CREATE TABLE dim_time (
    time_key INT PRIMARY KEY,
    date_actual DATE,
    day_of_week INT,
    day_name VARCHAR(10),
    day_of_month INT,
    day_of_year INT,
    week_of_year INT,
    month_actual INT,
    month_name VARCHAR(10),
    quarter_actual INT,
    year_actual INT,
    is_weekend BOOLEAN,
    is_holiday BOOLEAN,
    holiday_name VARCHAR(50),
    fiscal_year INT,
    fiscal_quarter INT,
    
    INDEX idx_time_date (date_actual),
    INDEX idx_time_year_month (year_actual, month_actual),
    INDEX idx_time_quarter (year_actual, quarter_actual)
);

-- Product Dimension with SCD Type 2 (Slowly Changing Dimension)
CREATE TABLE dim_product (
    product_key INT AUTO_INCREMENT PRIMARY KEY,  -- Surrogate key
    product_id VARCHAR(20),  -- Natural key
    product_name VARCHAR(100),
    brand VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    color VARCHAR(30),
    size VARCHAR(20),
    unit_cost DECIMAL(10,2),
    unit_price DECIMAL(10,2),
    supplier_name VARCHAR(100),
    
    -- SCD Type 2 columns
    effective_date DATE,
    expiration_date DATE,
    is_current BOOLEAN DEFAULT TRUE,
    
    INDEX idx_product_id (product_id),
    INDEX idx_product_category (category, subcategory),
    INDEX idx_product_current (is_current),
    INDEX idx_product_effective (effective_date, expiration_date)
);

-- Customer Dimension
CREATE TABLE dim_customer (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    customer_type ENUM('individual', 'business'),
    age_group VARCHAR(20),
    gender ENUM('M', 'F', 'O'),
    income_bracket VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    region VARCHAR(30),
    loyalty_tier ENUM('bronze', 'silver', 'gold', 'platinum'),
    
    INDEX idx_customer_id (customer_id),
    INDEX idx_customer_location (country, state, city),
    INDEX idx_customer_demographics (age_group, gender),
    INDEX idx_customer_loyalty (loyalty_tier)
);

-- Store Dimension
CREATE TABLE dim_store (
    store_key INT AUTO_INCREMENT PRIMARY KEY,
    store_id VARCHAR(20),
    store_name VARCHAR(100),
    store_type ENUM('flagship', 'regular', 'outlet', 'online'),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    region VARCHAR(30),
    district VARCHAR(30),
    manager_name VARCHAR(100),
    opening_date DATE,
    square_footage INT,
    
    INDEX idx_store_id (store_id),
    INDEX idx_store_location (country, state, city),
    INDEX idx_store_type (store_type)
);

-- Sales Fact Table
CREATE TABLE fact_sales (
    sales_key INT AUTO_INCREMENT PRIMARY KEY,
    
    -- Foreign keys to dimensions
    time_key INT,
    product_key INT,
    customer_key INT,
    store_key INT,
    
    -- Degenerate dimensions (stored in fact table)
    transaction_id VARCHAR(50),
    receipt_number VARCHAR(30),
    
    -- Measures
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    unit_cost DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    gross_sales_amount DECIMAL(10,2),
    net_sales_amount DECIMAL(10,2),
    profit_amount DECIMAL(10,2),
    tax_amount DECIMAL(10,2),
    
    -- Additional measures
    promotion_id VARCHAR(20),
    sales_rep_id VARCHAR(20),
    
    FOREIGN KEY (time_key) REFERENCES dim_time(time_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (store_key) REFERENCES dim_store(store_key),
    
    INDEX idx_fact_time (time_key),
    INDEX idx_fact_product (product_key),
    INDEX idx_fact_customer (customer_key),
    INDEX idx_fact_store (store_key),
    INDEX idx_fact_transaction (transaction_id)
);

-- Aggregate Tables for Common Queries
-- Monthly Sales by Product Category
CREATE TABLE agg_monthly_sales_by_category (
    year_month INT,
    category VARCHAR(50),
    subcategory VARCHAR(50),
    total_quantity INT,
    total_gross_sales DECIMAL(12,2),
    total_net_sales DECIMAL(12,2),
    total_profit DECIMAL(12,2),
    transaction_count INT,
    
    PRIMARY KEY (year_month, category, subcategory),
    INDEX idx_agg_monthly_date (year_month),
    INDEX idx_agg_monthly_category (category)
);

-- Sample data for dimensions
-- Time dimension (populate for several years)
INSERT INTO dim_time (time_key, date_actual, day_of_week, day_name, day_of_month, day_of_year, 
                     week_of_year, month_actual, month_name, quarter_actual, year_actual, 
                     is_weekend, is_holiday, fiscal_year, fiscal_quarter) VALUES
(20240115, '2024-01-15', 2, 'Monday', 15, 15, 3, 1, 'January', 1, 2024, FALSE, FALSE, 2024, 1),
(20240116, '2024-01-16', 3, 'Tuesday', 16, 16, 3, 1, 'January', 1, 2024, FALSE, FALSE, 2024, 1),
(20240117, '2024-01-17', 4, 'Wednesday', 17, 17, 3, 1, 'January', 1, 2024, FALSE, FALSE, 2024, 1);

-- Product dimension with SCD
INSERT INTO dim_product (product_id, product_name, brand, category, subcategory, color, size, 
                        unit_cost, unit_price, supplier_name, effective_date, expiration_date, is_current) VALUES
('P001', 'iPhone 15', 'Apple', 'Electronics', 'Smartphones', 'Black', '128GB', 750.00, 999.99, 'Apple Inc', '2023-09-01', '9999-12-31', TRUE),
('P002', 'Samsung Galaxy S24', 'Samsung', 'Electronics', 'Smartphones', 'White', '256GB', 650.00, 899.99, 'Samsung', '2024-01-01', '9999-12-31', TRUE),
('P003', 'Nike Air Max', 'Nike', 'Footwear', 'Athletic', 'Red', '10', 60.00, 120.00, 'Nike Inc', '2023-06-01', '9999-12-31', TRUE);

-- Customer dimension
INSERT INTO dim_customer (customer_id, customer_name, customer_type, age_group, gender, income_bracket, 
                         city, state, country, region, loyalty_tier) VALUES
('C001', 'John Doe', 'individual', '25-34', 'M', '50K-75K', 'New York', 'NY', 'USA', 'Northeast', 'gold'),
('C002', 'Jane Smith', 'individual', '35-44', 'F', '75K-100K', 'Los Angeles', 'CA', 'USA', 'West', 'platinum'),
('C003', 'Acme Corp', 'business', 'N/A', 'O', '500K+', 'Chicago', 'IL', 'USA', 'Midwest', 'silver');

-- Store dimension
INSERT INTO dim_store (store_id, store_name, store_type, address, city, state, country, region, district, 
                      manager_name, opening_date, square_footage) VALUES
('S001', 'Manhattan Flagship', 'flagship', '123 5th Avenue', 'New York', 'NY', 'USA', 'Northeast', 'Manhattan', 'Alice Johnson', '2020-01-01', 15000),
('S002', 'Beverly Hills Store', 'regular', '456 Rodeo Drive', 'Beverly Hills', 'CA', 'USA', 'West', 'LA Metro', 'Bob Wilson', '2019-06-01', 8000),
('S999', 'Online Store', 'online', 'N/A', 'N/A', 'N/A', 'USA', 'Online', 'Digital', 'Carol Davis', '2018-01-01', 0);

-- Fact table data
INSERT INTO fact_sales (time_key, product_key, customer_key, store_key, transaction_id, receipt_number,
                       quantity_sold, unit_price, unit_cost, discount_amount, gross_sales_amount, 
                       net_sales_amount, profit_amount, tax_amount) VALUES
(20240115, 1, 1, 1, 'TXN001', 'REC001', 1, 999.99, 750.00, 50.00, 999.99, 949.99, 199.99, 76.00),
(20240116, 2, 2, 2, 'TXN002', 'REC002', 1, 899.99, 650.00, 0.00, 899.99, 899.99, 249.99, 72.00),
(20240117, 3, 3, 1, 'TXN003', 'REC003', 2, 120.00, 60.00, 20.00, 240.00, 220.00, 120.00, 17.60);

-- Example OLAP Queries
-- 1. Sales by time period and product category
SELECT 
    dt.year_actual,
    dt.quarter_actual,
    dp.category,
    SUM(fs.net_sales_amount) as total_sales,
    SUM(fs.profit_amount) as total_profit,
    COUNT(*) as transaction_count
FROM fact_sales fs
JOIN dim_time dt ON fs.time_key = dt.time_key
JOIN dim_product dp ON fs.product_key = dp.product_key
GROUP BY dt.year_actual, dt.quarter_actual, dp.category
ORDER BY dt.year_actual, dt.quarter_actual, total_sales DESC;

-- 2. Customer analysis by region and loyalty tier
SELECT 
    dc.region,
    dc.loyalty_tier,
    COUNT(DISTINCT dc.customer_key) as customer_count,
    SUM(fs.net_sales_amount) as total_sales,
    AVG(fs.net_sales_amount) as avg_transaction_value
FROM fact_sales fs
JOIN dim_customer dc ON fs.customer_key = dc.customer_key
GROUP BY dc.region, dc.loyalty_tier
ORDER BY total_sales DESC;

-- 3. Store performance comparison
SELECT 
    ds.store_name,
    ds.store_type,
    ds.region,
    SUM(fs.net_sales_amount) as total_sales,
    SUM(fs.profit_amount) as total_profit,
    COUNT(DISTINCT fs.customer_key) as unique_customers,
    ROUND(SUM(fs.profit_amount) / SUM(fs.net_sales_amount) * 100, 2) as profit_margin_pct
FROM fact_sales fs
JOIN dim_store ds ON fs.store_key = ds.store_key
GROUP BY ds.store_key, ds.store_name, ds.store_type, ds.region
ORDER BY total_sales DESC;

-- ============================================
-- EXAMPLE 5: ADVANCED DATA MODELING PATTERNS
-- ============================================

-- PATTERN 1: Temporal Data Modeling (Bitemporal Tables)
-- Tracks both valid time (when fact was true) and transaction time (when recorded)

CREATE TABLE employee_salary_history (
    employee_id INT,
    salary DECIMAL(10,2),
    
    -- Valid time (when the salary was actually effective)
    valid_from DATE,
    valid_to DATE,
    
    -- Transaction time (when the record was created/modified in database)
    trans_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    trans_to TIMESTAMP DEFAULT '9999-12-31 23:59:59',
    
    -- Metadata
    recorded_by VARCHAR(50),
    reason VARCHAR(100),
    
    PRIMARY KEY (employee_id, valid_from, trans_from),
    
    INDEX idx_temporal_valid (employee_id, valid_from, valid_to),
    INDEX idx_temporal_trans (employee_id, trans_from, trans_to)
);

-- PATTERN 2: Audit Trail Pattern
CREATE TABLE data_audit_log (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    record_id VARCHAR(50),
    operation_type ENUM('INSERT', 'UPDATE', 'DELETE'),
    old_values JSON,
    new_values JSON,
    changed_by VARCHAR(50),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_id VARCHAR(100),
    application_name VARCHAR(50),
    
    INDEX idx_audit_table (table_name),
    INDEX idx_audit_record (table_name, record_id),
    INDEX idx_audit_user (changed_by),
    INDEX idx_audit_time (changed_at)
);

-- PATTERN 3: Hierarchical Data (Closure Table)
CREATE TABLE categories_hierarchy (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100),
    description TEXT
);

CREATE TABLE category_closure (
    ancestor_id INT,
    descendant_id INT,
    depth INT,
    
    PRIMARY KEY (ancestor_id, descendant_id),
    FOREIGN KEY (ancestor_id) REFERENCES categories_hierarchy(category_id),
    FOREIGN KEY (descendant_id) REFERENCES categories_hierarchy(category_id),
    
    INDEX idx_closure_ancestor (ancestor_id),
    INDEX idx_closure_descendant (descendant_id),
    INDEX idx_closure_depth (depth)
);

-- Sample hierarchical data
INSERT INTO categories_hierarchy (category_name) VALUES
('Electronics'),      -- 1
('Computers'),        -- 2
('Laptops'),          -- 3
('Gaming Laptops'),   -- 4
('Mobile Devices'),   -- 5
('Smartphones');      -- 6

-- Closure table entries (all ancestor-descendant relationships)
INSERT INTO category_closure (ancestor_id, descendant_id, depth) VALUES
-- Self-references (depth 0)
(1, 1, 0), (2, 2, 0), (3, 3, 0), (4, 4, 0), (5, 5, 0), (6, 6, 0),
-- Direct parent-child relationships (depth 1)
(1, 2, 1), (1, 5, 1),  -- Electronics -> Computers, Mobile Devices
(2, 3, 1),             -- Computers -> Laptops
(3, 4, 1),             -- Laptops -> Gaming Laptops
(5, 6, 1),             -- Mobile Devices -> Smartphones
-- Indirect relationships (depth 2+)
(1, 3, 2), (1, 6, 2),  -- Electronics -> Laptops, Smartphones
(1, 4, 3),             -- Electronics -> Gaming Laptops
(2, 4, 2);             -- Computers -> Gaming Laptops

-- Query: Find all descendants of Electronics (category_id = 1)
SELECT 
    c.category_name,
    cc.depth
FROM category_closure cc
JOIN categories_hierarchy c ON cc.descendant_id = c.category_id
WHERE cc.ancestor_id = 1 AND cc.depth > 0
ORDER BY cc.depth, c.category_name;

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Verify referential integrity
SELECT 'Checking foreign key constraints' as check_type;

-- Check for orphaned records in fact table
SELECT COUNT(*) as orphaned_sales_records
FROM fact_sales fs
LEFT JOIN dim_time dt ON fs.time_key = dt.time_key
LEFT JOIN dim_product dp ON fs.product_key = dp.product_key
LEFT JOIN dim_customer dc ON fs.customer_key = dc.customer_key
LEFT JOIN dim_store ds ON fs.store_key = ds.store_key
WHERE dt.time_key IS NULL 
   OR dp.product_key IS NULL 
   OR dc.customer_key IS NULL 
   OR ds.store_key IS NULL;

-- Verify SCD Type 2 implementation
SELECT 
    product_id,
    COUNT(*) as version_count,
    SUM(CASE WHEN is_current = TRUE THEN 1 ELSE 0 END) as current_versions
FROM dim_product
GROUP BY product_id;

-- Check data consistency in denormalized table
SELECT 
    order_id,
    COUNT(DISTINCT order_total_amount) as different_totals
FROM order_reporting_denorm
GROUP BY order_id
HAVING COUNT(DISTINCT order_total_amount) > 1;