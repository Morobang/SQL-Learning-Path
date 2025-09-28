-- 🎓 Views in SQL: Complete Educational Guide
-- This file teaches you everything about views with practical examples

-- 📚 Sample Data: Library Database
CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(100),
    author VARCHAR(100),
    genre VARCHAR(50),
    published_year INT,
    page_count INT,
    price DECIMAL(10,2),
    in_stock BOOLEAN
);

CREATE TABLE borrowers (
    borrower_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    membership_date DATE
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    book_id INT,
    borrower_id INT,
    loan_date DATE,
    due_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (borrower_id) REFERENCES borrowers(borrower_id)
);

-- Insert sample data
INSERT INTO books VALUES
(1, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 281, 12.99, true),
(2, '1984', 'George Orwell', 'Dystopian', 1949, 328, 10.99, true),
(3, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 1925, 180, 9.99, false),
(4, 'Pride and Prejudice', 'Jane Austen', 'Romance', 1813, 432, 11.99, true),
(5, 'The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937, 310, 13.99, true);

INSERT INTO borrowers VALUES
(1, 'John', 'Smith', 'john.smith@email.com', '2023-01-15'),
(2, 'Sarah', 'Johnson', 'sarah.j@email.com', '2023-02-20'),
(3, 'Mike', 'Williams', 'mike.w@email.com', '2023-03-10');

INSERT INTO loans VALUES
(1, 3, 1, '2023-06-01', '2023-06-15', NULL),  -- The Great Gatsby borrowed by John
(2, 2, 2, '2023-06-05', '2023-06-19', '2023-06-12'),  -- 1984 borrowed and returned by Sarah
(3, 5, 3, '2023-06-10', '2023-06-24', NULL);  -- The Hobbit borrowed by Mike

-- 🎯 SECTION 1: BASIC VIEWS

-- Example 1: Simple View for Public Book Catalog
CREATE VIEW book_catalog AS
SELECT book_id, title, author, genre, published_year
FROM books
WHERE in_stock = true;

-- 🔍 What this does: Creates a safe view without prices or stock status
-- 📊 Usage: SELECT * FROM book_catalog;

-- Example 2: View with Calculated Column
CREATE VIEW book_summary AS
SELECT 
    book_id,
    title,
    author,
    genre,
    published_year,
    page_count,
    -- Calculate century based on published year
    CASE 
        WHEN published_year < 1900 THEN '19th Century'
        WHEN published_year < 2000 THEN '20th Century' 
        ELSE '21st Century'
    END as century,
    -- Categorize by length
    CASE
        WHEN page_count < 200 THEN 'Short'
        WHEN page_count < 400 THEN 'Medium'
        ELSE 'Long'
    END as length_category
FROM books;

-- 🔍 What this does: Adds calculated columns for century and book length
-- 📊 Usage: SELECT * FROM book_summary WHERE century = '20th Century';

-- 🎯 SECTION 2: SECURITY-FOCUSED VIEWS

-- Example 3: View for Student Volunteers (Limited Access)
CREATE VIEW student_volunteer_view AS
SELECT 
    b.title,
    b.author,
    b.genre,
    br.first_name,
    br.last_name,
    l.loan_date,
    l.due_date
FROM loans l
JOIN books b ON l.book_id = b.book_id
JOIN borrowers br ON l.borrower_id = br.borrower_id
WHERE l.return_date IS NULL;  -- Only show current loans

-- 🔍 What this does: Shows current loans without sensitive data
-- 📊 Usage: SELECT * FROM student_volunteer_view;

-- Example 4: View for Librarians (More Access)
CREATE VIEW librarian_view AS
SELECT 
    l.loan_id,
    b.title,
    b.author,
    br.first_name || ' ' || br.last_name AS borrower_name,
    br.email,
    l.loan_date,
    l.due_date,
    l.return_date,
    -- Calculate overdue status
    CASE 
        WHEN l.return_date IS NULL AND l.due_date < CURRENT_DATE THEN 'Overdue'
        WHEN l.return_date IS NULL THEN 'On Loan'
        ELSE 'Returned'
    END as loan_status
FROM loans l
JOIN books b ON l.book_id = b.book_id
JOIN borrowers br ON l.borrower_id = br.borrower_id;

-- 🔍 What this does: Shows loan details with status calculations
-- 📊 Usage: SELECT * FROM librarian_view WHERE loan_status = 'Overdue';

-- 🎯 SECTION 3: AGGREGATION VIEWS

-- Example 5: Genre Statistics View
CREATE VIEW genre_statistics AS
SELECT 
    genre,
    COUNT(*) as total_books,
    AVG(page_count) as avg_pages,
    MIN(published_year) as oldest_book,
    MAX(published_year) as newest_book,
    SUM(CASE WHEN in_stock THEN 1 ELSE 0 END) as books_in_stock
FROM books
GROUP BY genre;

-- 🔍 What this does: Provides summary statistics by genre
-- 📊 Usage: SELECT * FROM genre_statistics ORDER BY total_books DESC;

-- Example 6: Borrower Activity View
CREATE VIEW borrower_activity AS
SELECT 
    br.borrower_id,
    br.first_name || ' ' || br.last_name as borrower_name,
    br.membership_date,
    COUNT(l.loan_id) as total_loans,
    SUM(CASE WHEN l.return_date IS NULL THEN 1 ELSE 0 END) as current_loans,
    -- Calculate membership duration in months
    EXTRACT(MONTH FROM AGE(CURRENT_DATE, br.membership_date)) as membership_months
FROM borrowers br
LEFT JOIN loans l ON br.borrower_id = l.borrower_id
GROUP BY br.borrower_id, borrower_name, br.membership_date;

-- 🔍 What this does: Shows borrower activity and statistics
-- 📊 Usage: SELECT * FROM borrower_activity WHERE current_loans > 0;

-- 🎯 SECTION 4: COMPLEX JOIN VIEWS

-- Example 7: Complete Library Overview
CREATE VIEW library_overview AS
SELECT 
    b.book_id,
    b.title,
    b.author,
    b.genre,
    b.published_year,
    b.in_stock,
    l.loan_id,
    l.loan_date,
    l.due_date,
    l.return_date,
    br.borrower_id,
    br.first_name || ' ' || br.last_name as borrower_name,
    -- Calculate book age
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, MAKE_DATE(b.published_year, 1, 1))) as book_age_years
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id AND l.return_date IS NULL
LEFT JOIN borrowers br ON l.borrower_id = br.borrower_id;

-- 🔍 What this does: Shows complete library status with current loans
-- 📊 Usage: SELECT * FROM library_overview WHERE in_stock = false;

-- 🎯 SECTION 5: VIEW MANAGEMENT

-- Show all views in the database
SELECT table_name as view_name 
FROM information_schema.views 
WHERE table_schema = 'public';

-- View definition
SELECT definition 
FROM pg_views 
WHERE viewname = 'library_overview';

-- Update a view (replace it)
CREATE OR REPLACE VIEW book_catalog AS
SELECT book_id, title, author, genre, published_year, page_count
FROM books
WHERE in_stock = true;

-- Drop a view
-- DROP VIEW IF EXISTS book_catalog;

-- 🎯 SECTION 6: PRACTICAL EXAMPLES

-- Example 8: View for Popular Books (Borrowed frequently)
CREATE VIEW popular_books AS
SELECT 
    b.book_id,
    b.title,
    b.author,
    b.genre,
    COUNT(l.loan_id) as times_borrowed,
    MAX(l.loan_date) as last_borrowed
FROM books b
LEFT JOIN loans l ON b.book_id = l.book_id
GROUP BY b.book_id, b.title, b.author, b.genre
HAVING COUNT(l.loan_id) > 0
ORDER BY times_borrowed DESC;

-- Example 9: View for Overdue Books
CREATE VIEW overdue_books AS
SELECT 
    l.loan_id,
    b.title,
    b.author,
    br.first_name || ' ' || br.last_name as borrower_name,
    br.email,
    l.loan_date,
    l.due_date,
    CURRENT_DATE - l.due_date as days_overdue
FROM loans l
JOIN books b ON l.book_id = b.book_id
JOIN borrowers br ON l.borrower_id = br.borrower_id
WHERE l.return_date IS NULL AND l.due_date < CURRENT_DATE;

-- 🔍 What this does: Shows all overdue books with contact info
-- 📊 Usage: SELECT * FROM overdue_books ORDER BY days_overdue DESC;

-- Example 10: View for Book Recommendations
CREATE VIEW book_recommendations AS
SELECT 
    b1.book_id,
    b1.title,
    b1.author,
    b1.genre,
    b1.published_year,
    -- Suggest similar books based on genre
    (SELECT COUNT(*) 
     FROM books b2 
     WHERE b2.genre = b1.genre AND b2.book_id != b1.book_id) as similar_books_count
FROM books b1
WHERE b1.in_stock = true
ORDER BY similar_books_count DESC, b1.published_year DESC;

-- 🎯 SECTION 7: USING VIEWS IN QUERIES

-- Query 1: Find available classic books
SELECT * FROM book_catalog WHERE genre = 'Classic';

-- Query 2: Show borrowers with current loans
SELECT borrower_name, current_loans 
FROM borrower_activity 
WHERE current_loans > 0 
ORDER BY current_loans DESC;

-- Query 3: Contact borrowers with overdue books
SELECT borrower_name, email, title, days_overdue
FROM overdue_books
WHERE days_overdue > 7
ORDER BY days_overdue DESC;

-- Query 4: Genre analysis for collection development
SELECT 
    genre,
    total_books,
    books_in_stock,
    ROUND((books_in_stock::decimal / total_books) * 100, 2) as percentage_in_stock
FROM genre_statistics
ORDER BY percentage_in_stock ASC;

-- 🎯 SECTION 8: VIEWS WITH PARAMETERS (Using functions)

-- Create a function that acts like a parameterized view
CREATE FUNCTION get_books_by_year_range(start_year INT, end_year INT)
RETURNS TABLE (
    book_id INT,
    title VARCHAR,
    author VARCHAR,
    published_year INT,
    genre VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT b.book_id, b.title, b.author, b.published_year, b.genre
    FROM books b
    WHERE b.published_year BETWEEN start_year AND end_year
    ORDER BY b.published_year;
END;
$$ LANGUAGE plpgsql;

-- 🔍 Usage: SELECT * FROM get_books_by_year_range(1900, 1950);

-- 🎯 SECTION 9: MATERIALIZED VIEWS (Advanced)

-- Create a materialized view for better performance
CREATE MATERIALIZED VIEW monthly_loan_stats AS
SELECT 
    DATE_TRUNC('month', loan_date) as month,
    COUNT(*) as total_loans,
    COUNT(DISTINCT borrower_id) as unique_borrowers,
    AVG(EXTRACT(DAY FROM due_date - loan_date)) as avg_loan_duration
FROM loans
GROUP BY DATE_TRUNC('month', loan_date)
ORDER BY month DESC;

-- 🔍 Materialized views store actual data and need refreshing
-- REFRESH MATERIALIZED VIEW monthly_loan_stats;

-- 🎓 SUMMARY: WHY USE VIEWS?

-- 1. 🔒 Security: Hide sensitive data
-- 2. 👓 Simplification: Make complex queries easy
-- 3. 📊 Consistency: Standardize calculations
-- 4. 🛡️ Abstraction: Protect from schema changes
-- 5. 🎯 Organization: Logical data presentation

-- 🚀 BEST PRACTICES:

-- 1. Use descriptive view names
-- 2. Document what each view is for
-- 3. Avoid nesting views too deeply
-- 4. Consider performance implications
-- 5. Regularly review and clean up unused views

-- 🧹 Cleanup (uncomment to remove all views)
/*
DROP VIEW IF EXISTS book_catalog;
DROP VIEW IF EXISTS book_summary;
DROP VIEW IF EXISTS student_volunteer_view;
DROP VIEW IF EXISTS librarian_view;
DROP VIEW IF EXISTS genre_statistics;
DROP VIEW IF EXISTS borrower_activity;
DROP VIEW IF EXISTS library_overview;
DROP VIEW IF EXISTS popular_books;
DROP VIEW IF EXISTS overdue_books;
DROP VIEW IF EXISTS book_recommendations;
DROP MATERIALIZED VIEW IF EXISTS monthly_loan_stats;
DROP FUNCTION IF EXISTS get_books_by_year_range;
*/