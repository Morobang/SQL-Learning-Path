/*
===============================================
    SQL BASICS EXERCISES
    Practice fundamental SQL concepts
===============================================
*/

-- ============================================
-- SETUP: Create Sample Database for Practice
-- ============================================

-- Create a database for our exercises
CREATE DATABASE sql_basics_practice;
USE sql_basics_practice;

-- Create sample tables
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT,
    grade_level VARCHAR(10),
    enrollment_date DATE
);

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(10) UNIQUE,
    credits INT,
    instructor VARCHAR(100)
);

CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Insert sample data
INSERT INTO students (first_name, last_name, email, age, grade_level, enrollment_date) VALUES
('John', 'Doe', 'john.doe@email.com', 20, 'Sophomore', '2023-08-15'),
('Jane', 'Smith', 'jane.smith@email.com', 19, 'Freshman', '2023-08-15'),
('Bob', 'Johnson', 'bob.johnson@email.com', 21, 'Junior', '2022-08-15'),
('Alice', 'Brown', 'alice.brown@email.com', 22, 'Senior', '2021-08-15'),
('Charlie', 'Davis', 'charlie.davis@email.com', 18, 'Freshman', '2023-08-15');

INSERT INTO courses (course_name, course_code, credits, instructor) VALUES
('Introduction to Computer Science', 'CS101', 3, 'Dr. Wilson'),
('Calculus I', 'MATH101', 4, 'Prof. Anderson'),
('English Composition', 'ENG101', 3, 'Dr. Martinez'),
('Physics I', 'PHYS101', 4, 'Prof. Thompson'),
('History of Art', 'ART101', 2, 'Dr. Garcia');

INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES
(1, 1, '2023-08-20', 'A'),
(1, 2, '2023-08-20', 'B'),
(2, 1, '2023-08-20', 'A'),
(2, 3, '2023-08-20', 'B+'),
(3, 2, '2022-08-20', 'A-'),
(3, 4, '2022-08-20', 'B'),
(4, 3, '2021-08-20', 'A'),
(4, 5, '2021-08-20', 'A-'),
(5, 1, '2023-08-20', NULL);  -- No grade yet

-- ============================================
-- EXERCISE 1: Basic SELECT Operations
-- ============================================

-- 1.1: Select all students
-- Write a query to retrieve all information about all students
-- YOUR ANSWER:

-- 1.2: Select specific columns
-- Write a query to show only first_name, last_name, and email of all students
-- YOUR ANSWER:

-- 1.3: Count total records
-- Write a query to count how many students are in the database
-- YOUR ANSWER:

-- 1.4: Select with simple condition
-- Write a query to find all students who are 20 years or older
-- YOUR ANSWER:

-- 1.5: Select with multiple conditions
-- Write a query to find all Freshman students who are younger than 19
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 2: CREATE (INSERT) Operations
-- ============================================

-- 2.1: Insert a new student
-- Add a new student: 'Emily', 'Wilson', 'emily.wilson@email.com', age 19, grade_level 'Sophomore', enrolled today
-- YOUR ANSWER:

-- 2.2: Insert multiple students
-- Add these three students in a single query:
-- ('Michael', 'Taylor', 'michael.taylor@email.com', 20, 'Junior', '2023-01-15')
-- ('Sarah', 'Anderson', 'sarah.anderson@email.com', 21, 'Senior', '2022-08-15')
-- ('David', 'Lee', 'david.lee@email.com', 18, 'Freshman', '2023-08-15')
-- YOUR ANSWER:

-- 2.3: Insert a new course
-- Add a new course: 'Database Design', 'CS201', 3 credits, instructor 'Prof. Johnson'
-- YOUR ANSWER:

-- 2.4: Insert enrollment record
-- Enroll student with ID 1 in the new Database Design course (course_id should be 6), enrollment date today, no grade yet
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 3: UPDATE Operations
-- ============================================

-- 3.1: Update single field
-- Change John Doe's email to 'john.doe.updated@email.com'
-- YOUR ANSWER:

-- 3.2: Update multiple fields
-- Update Alice Brown: change her age to 23 and grade_level to 'Graduate'
-- YOUR ANSWER:

-- 3.3: Update with calculation
-- Increase the credits for all courses by 1
-- YOUR ANSWER:

-- 3.4: Conditional update
-- Give all enrollments with NULL grade a grade of 'IP' (In Progress)
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 4: DELETE Operations
-- ============================================

-- 4.1: Delete specific record
-- Delete the enrollment record where student_id = 5 and course_id = 1
-- YOUR ANSWER:

-- 4.2: Delete with condition
-- Delete all students who are Freshmen and younger than 18
-- YOUR ANSWER:

-- 4.3: Delete related records (think about foreign keys!)
-- Before deleting a student, what do you need to consider?
-- Write the proper sequence to delete student with ID 2
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 5: Complex CRUD Scenarios
-- ============================================

-- 5.1: Find students not enrolled in any course
-- Write a query to find students who have no enrollments
-- Hint: Use LEFT JOIN or NOT EXISTS
-- YOUR ANSWER:

-- 5.2: Update grades based on conditions
-- Update all grades from 'B+' to 'B' for students in grade_level 'Freshman'
-- YOUR ANSWER:

-- 5.3: Insert with subquery
-- Insert a new enrollment for the student with email 'alice.brown@email.com' 
-- into the course with course_code 'CS201', enrollment date today
-- Use subqueries to find the IDs
-- YOUR ANSWER:

-- 5.4: Complex delete
-- Delete all enrollments for courses that have fewer than 5 credits
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 6: Data Validation and Constraints
-- ============================================

-- 6.1: Try to insert invalid data
-- Try to insert a student with a duplicate email (should fail)
-- What happens? Write the query and explain the result.
-- YOUR ANSWER:

-- 6.2: Try to delete referenced data
-- Try to delete a student who has enrollments (should fail due to foreign key)
-- What happens? Write the query and explain the result.
-- YOUR ANSWER:

-- 6.3: Insert with missing required data
-- Try to insert a student without a first_name (should fail)
-- What happens? Write the query and explain the result.
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 7: Practical Scenarios
-- ============================================

-- 7.1: New semester setup
-- Write the SQL statements to:
-- a) Add a new course 'Advanced Programming', 'CS301', 4 credits, 'Dr. Smith'
-- b) Enroll all Junior and Senior students in this course
-- c) Set their enrollment date to today
-- YOUR ANSWER:

-- 7.2: Grade update scenario
-- A teacher needs to update grades for course 'CS101'. Write SQL to:
-- a) Update John Doe's grade to 'A+'
-- b) Update Jane Smith's grade to 'A'
-- c) Give any student without a grade an 'F'
-- YOUR ANSWER:

-- 7.3: Student transfer scenario
-- A student is transferring. Write SQL to:
-- a) Update their email address
-- b) Remove them from all current enrollments
-- c) Change their status (you may need to add a status column)
-- YOUR ANSWER:

-- ============================================
-- EXERCISE 8: Performance and Best Practices
-- ============================================

-- 8.1: Write an inefficient query, then improve it
-- First, write a query that selects all data even though you only need names
-- Then, write the improved version
-- BAD VERSION:

-- GOOD VERSION:

-- 8.2: Demonstrate transaction usage
-- Write a transaction that enrolls a student in multiple courses
-- If any enrollment fails, all should be rolled back
-- YOUR ANSWER:

-- 8.3: Add proper indexes
-- Write statements to add indexes that would help with these common queries:
-- - Finding students by email
-- - Finding enrollments by student_id
-- - Finding courses by course_code
-- YOUR ANSWER:

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Run these queries to check your work:

-- Check total number of students
SELECT COUNT(*) as total_students FROM students;

-- Check total number of courses
SELECT COUNT(*) as total_courses FROM courses;

-- Check total number of enrollments
SELECT COUNT(*) as total_enrollments FROM enrollments;

-- Show all students with their enrollment count
SELECT 
    s.first_name, 
    s.last_name, 
    COUNT(e.enrollment_id) as enrollment_count
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY s.last_name;

-- Show grade distribution
SELECT 
    grade,
    COUNT(*) as count
FROM enrollments
WHERE grade IS NOT NULL
GROUP BY grade
ORDER BY grade;

-- ============================================
-- CHALLENGE EXERCISES
-- ============================================

-- Challenge 1: Complex Insert
-- Create a stored procedure or write SQL that adds a new student 
-- and automatically enrolls them in all courses with 'CS' in the course code
-- YOUR ANSWER:

-- Challenge 2: Audit Trail
-- Add created_at and updated_at columns to the students table
-- Then write triggers or application logic to maintain these timestamps
-- YOUR ANSWER:

-- Challenge 3: Data Migration
-- Write SQL to copy all Senior students to a new 'graduates' table
-- Include all their enrollment history
-- YOUR ANSWER:

-- ============================================
-- REFLECTION QUESTIONS
-- ============================================

/*
1. What's the difference between DELETE and TRUNCATE?

2. When would you use a transaction for CRUD operations?

3. How do foreign key constraints affect your CRUD operations?

4. What are the performance implications of different CRUD operations?

5. How do you ensure data integrity when performing bulk operations?

6. What's the difference between INSERT and REPLACE/UPSERT?

Answer these questions in comments below:

1. 

2. 

3. 

4. 

5. 

6. 

*/

-- ============================================
-- COMPLETION CHECKLIST
-- ============================================
/*
□ Completed basic SELECT exercises
□ Performed CREATE (INSERT) operations
□ Executed UPDATE operations safely
□ Handled DELETE operations with care
□ Worked with complex CRUD scenarios
□ Understood constraint violations
□ Applied practical scenarios
□ Considered performance implications
□ Answered reflection questions
□ Tested all queries successfully
*/