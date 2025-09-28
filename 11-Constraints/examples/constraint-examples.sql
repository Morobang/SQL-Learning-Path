/*
===============================================
    DATABASE CONSTRAINTS EXAMPLES
    Practical Examples of Primary Keys, Foreign Keys, Unique, NOT NULL, Check Constraints, and Defaults
===============================================
*/

-- ============================================
-- EXAMPLE DATABASE: Online Learning Platform
-- ============================================

DROP DATABASE IF EXISTS learning_platform;
CREATE DATABASE learning_platform;
USE learning_platform;

-- ============================================
-- PRIMARY KEY EXAMPLES
-- ============================================

-- Example 1: Single Column Primary Key (Auto-increment)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Example 2: Single Column Primary Key (UUID/Manual)
CREATE TABLE courses (
    course_id VARCHAR(36) PRIMARY KEY,  -- For UUID
    course_title VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) DEFAULT 0.00,
    created_date DATE DEFAULT (CURRENT_DATE)
);

-- Example 3: Composite Primary Key
CREATE TABLE enrollments (
    user_id INT,
    course_id VARCHAR(36),
    enrolled_date DATE DEFAULT (CURRENT_DATE),
    completion_status ENUM('not_started', 'in_progress', 'completed') DEFAULT 'not_started',
    PRIMARY KEY (user_id, course_id)
);

-- Example 4: Adding Primary Key to Existing Table
CREATE TABLE instructors (
    instructor_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    bio TEXT
);

-- Add primary key constraint
ALTER TABLE instructors 
ADD CONSTRAINT pk_instructors PRIMARY KEY (instructor_id);

-- ============================================
-- FOREIGN KEY EXAMPLES
-- ============================================

-- Example 1: Basic Foreign Key
CREATE TABLE lessons (
    lesson_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(36) NOT NULL,
    lesson_title VARCHAR(200) NOT NULL,
    content TEXT,
    duration_minutes INT DEFAULT 0,
    lesson_order INT DEFAULT 1,
    
    -- Foreign key constraint
    CONSTRAINT fk_lessons_course 
        FOREIGN KEY (course_id) 
        REFERENCES courses(course_id)
);

-- Example 2: Foreign Key with CASCADE DELETE
CREATE TABLE course_materials (
    material_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(36) NOT NULL,
    material_name VARCHAR(200) NOT NULL,
    file_path VARCHAR(500),
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Cascade delete: when course is deleted, materials are also deleted
    CONSTRAINT fk_materials_course 
        FOREIGN KEY (course_id) 
        REFERENCES courses(course_id) 
        ON DELETE CASCADE
);

-- Example 3: Foreign Key with CASCADE UPDATE
CREATE TABLE assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(36) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    due_date DATE,
    max_points INT DEFAULT 100,
    
    -- Cascade update: if course_id changes, assignment records update too
    CONSTRAINT fk_assignments_course 
        FOREIGN KEY (course_id) 
        REFERENCES courses(course_id) 
        ON UPDATE CASCADE
        ON DELETE RESTRICT  -- Cannot delete course if it has assignments
);

-- Example 4: Self-Referencing Foreign Key
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT,
    description TEXT,
    
    -- Self-referencing foreign key for hierarchical categories
    CONSTRAINT fk_categories_parent 
        FOREIGN KEY (parent_category_id) 
        REFERENCES categories(category_id)
        ON DELETE SET NULL  -- If parent is deleted, set child's parent to NULL
);

-- Example 5: Multiple Foreign Keys in One Table
CREATE TABLE course_instructors (
    course_id VARCHAR(36),
    instructor_id INT,
    role ENUM('primary', 'assistant', 'guest') DEFAULT 'assistant',
    assigned_date DATE DEFAULT (CURRENT_DATE),
    
    PRIMARY KEY (course_id, instructor_id),
    
    -- Multiple foreign key constraints
    CONSTRAINT fk_course_instructors_course 
        FOREIGN KEY (course_id) 
        REFERENCES courses(course_id) 
        ON DELETE CASCADE,
        
    CONSTRAINT fk_course_instructors_instructor 
        FOREIGN KEY (instructor_id) 
        REFERENCES instructors(instructor_id) 
        ON DELETE CASCADE
);

-- ============================================
-- UNIQUE CONSTRAINT EXAMPLES
-- ============================================

-- Example 1: Single Column Unique Constraint
ALTER TABLE users 
ADD CONSTRAINT uk_users_email UNIQUE (email);

ALTER TABLE users 
ADD CONSTRAINT uk_users_username UNIQUE (username);

-- Example 2: Composite Unique Constraint
CREATE TABLE quiz_attempts (
    attempt_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    quiz_id INT NOT NULL,
    attempt_number INT NOT NULL,
    score DECIMAL(5,2),
    attempt_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Composite unique: one attempt per user per quiz per attempt number
    CONSTRAINT uk_quiz_attempts_user_quiz_attempt 
        UNIQUE (user_id, quiz_id, attempt_number),
        
    CONSTRAINT fk_quiz_attempts_user 
        FOREIGN KEY (user_id) 
        REFERENCES users(user_id)
);

-- Example 3: Unique Constraint with Multiple Columns (Different Combinations)
CREATE TABLE course_coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_code VARCHAR(20) NOT NULL,
    course_id VARCHAR(36) NOT NULL,
    discount_percent DECIMAL(5,2),
    valid_from DATE,
    valid_until DATE,
    
    -- Each coupon code must be unique globally
    CONSTRAINT uk_coupons_code UNIQUE (coupon_code),
    
    -- Each course can have only one active coupon per date range (simplified)
    CONSTRAINT uk_coupons_course_dates UNIQUE (course_id, valid_from, valid_until),
    
    CONSTRAINT fk_coupons_course 
        FOREIGN KEY (course_id) 
        REFERENCES courses(course_id)
);

-- ============================================
-- NOT NULL CONSTRAINT EXAMPLES
-- ============================================

-- Example 1: Adding NOT NULL to Existing Column
ALTER TABLE courses 
MODIFY COLUMN course_title VARCHAR(200) NOT NULL;

-- Example 2: Table with Strategic NOT NULL Constraints
CREATE TABLE user_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,  -- Must have a user
    first_name VARCHAR(50) NOT NULL,  -- Required for personalization
    last_name VARCHAR(50) NOT NULL,   -- Required for certificates
    bio TEXT,  -- Optional
    profile_picture VARCHAR(500),  -- Optional
    linkedin_url VARCHAR(200),  -- Optional
    twitter_handle VARCHAR(50),  -- Optional
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_profiles_user 
        FOREIGN KEY (user_id) 
        REFERENCES users(user_id) 
        ON DELETE CASCADE,
        
    CONSTRAINT uk_profiles_user UNIQUE (user_id)  -- One profile per user
);

-- Example 3: Business Rule NOT NULL Constraints
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,  -- Must know who paid
    course_id VARCHAR(36) NOT NULL,  -- Must know what was purchased
    amount DECIMAL(10,2) NOT NULL,  -- Must have an amount
    payment_method VARCHAR(50) NOT NULL,  -- Must record payment method
    transaction_id VARCHAR(100) NOT NULL,  -- Must have transaction ID for tracking
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') NOT NULL DEFAULT 'pending',
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Optional fields
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    tax_amount DECIMAL(10,2) DEFAULT 0.00,
    notes TEXT,
    
    CONSTRAINT fk_payments_user 
        FOREIGN KEY (user_id) 
        REFERENCES users(user_id),
        
    CONSTRAINT fk_payments_course 
        FOREIGN KEY (course_id) 
        REFERENCES courses(course_id),
        
    CONSTRAINT uk_payments_transaction UNIQUE (transaction_id)
);

-- ============================================
-- CHECK CONSTRAINT EXAMPLES
-- ============================================

-- Example 1: Range Check Constraints
CREATE TABLE course_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id VARCHAR(36) NOT NULL,
    rating INT NOT NULL,
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Rating must be between 1 and 5
    CONSTRAINT chk_reviews_rating 
        CHECK (rating >= 1 AND rating <= 5),
    
    CONSTRAINT fk_reviews_user 
        FOREIGN KEY (user_id) 
        REFERENCES users(user_id),
        
    CONSTRAINT fk_reviews_course 
        FOREIGN KEY (course_id) 
        REFERENCES courses(course_id),
        
    -- One review per user per course
    CONSTRAINT uk_reviews_user_course UNIQUE (user_id, course_id)
);

-- Example 2: Value List Check Constraints
CREATE TABLE course_levels (
    level_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(36) NOT NULL,
    difficulty_level VARCHAR(20) NOT NULL,
    prerequisites TEXT,
    
    -- Difficulty must be one of specific values
    CONSTRAINT chk_levels_difficulty 
        CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced', 'expert')),
        
    CONSTRAINT fk_levels_course 
        FOREIGN KEY (course_id) 
        REFERENCES courses(course_id),
        
    CONSTRAINT uk_levels_course UNIQUE (course_id)  -- One level per course
);

-- Example 3: Complex Business Rule Check Constraints
CREATE TABLE subscription_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL,
    monthly_price DECIMAL(10,2) NOT NULL,
    annual_price DECIMAL(10,2) NOT NULL,
    max_courses INT NOT NULL,
    features JSON,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Price validations
    CONSTRAINT chk_plans_monthly_price 
        CHECK (monthly_price >= 0 AND monthly_price <= 1000),
        
    CONSTRAINT chk_plans_annual_price 
        CHECK (annual_price >= 0 AND annual_price <= 10000),
        
    -- Annual price should be less than 12 * monthly (discount)
    CONSTRAINT chk_plans_annual_discount 
        CHECK (annual_price < (monthly_price * 12)),
        
    -- Must allow at least 1 course
    CONSTRAINT chk_plans_max_courses 
        CHECK (max_courses >= 1 AND max_courses <= 1000),
        
    CONSTRAINT uk_plans_name UNIQUE (plan_name)
);

-- Example 4: Date and Time Check Constraints
CREATE TABLE live_sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(36) NOT NULL,
    instructor_id INT NOT NULL,
    session_title VARCHAR(200) NOT NULL,
    scheduled_start DATETIME NOT NULL,
    scheduled_end DATETIME NOT NULL,
    actual_start DATETIME,
    actual_end DATETIME,
    max_participants INT DEFAULT 50,
    
    -- Scheduled end must be after scheduled start
    CONSTRAINT chk_sessions_scheduled_duration 
        CHECK (scheduled_end > scheduled_start),
        
    -- If actual times are set, actual end must be after actual start
    CONSTRAINT chk_sessions_actual_duration 
        CHECK (actual_end IS NULL OR actual_start IS NULL OR actual_end > actual_start),
        
    -- Session must be scheduled in the future (at creation time)
    CONSTRAINT chk_sessions_future_schedule 
        CHECK (scheduled_start > NOW()),
        
    -- Maximum participants must be reasonable
    CONSTRAINT chk_sessions_max_participants 
        CHECK (max_participants >= 1 AND max_participants <= 1000),
        
    CONSTRAINT fk_sessions_course 
        FOREIGN KEY (course_id) 
        REFERENCES courses(course_id),
        
    CONSTRAINT fk_sessions_instructor 
        FOREIGN KEY (instructor_id) 
        REFERENCES instructors(instructor_id)
);

-- ============================================
-- DEFAULT VALUE EXAMPLES
-- ============================================

-- Example 1: Various Default Types
CREATE TABLE user_settings (
    setting_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    
    -- Boolean defaults
    email_notifications BOOLEAN DEFAULT TRUE,
    sms_notifications BOOLEAN DEFAULT FALSE,
    
    -- String defaults
    language_preference VARCHAR(10) DEFAULT 'en',
    timezone VARCHAR(50) DEFAULT 'UTC',
    theme VARCHAR(20) DEFAULT 'light',
    
    -- Numeric defaults
    video_quality VARCHAR(10) DEFAULT 'auto',
    playback_speed DECIMAL(3,2) DEFAULT 1.00,
    
    -- Date/Time defaults
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- NULL as explicit default (optional settings)
    preferred_instructor_id INT DEFAULT NULL,
    completion_certificate_email VARCHAR(100) DEFAULT NULL,
    
    CONSTRAINT fk_settings_user 
        FOREIGN KEY (user_id) 
        REFERENCES users(user_id) 
        ON DELETE CASCADE,
        
    CONSTRAINT uk_settings_user UNIQUE (user_id),
    
    -- Check constraints for default values
    CONSTRAINT chk_settings_language 
        CHECK (language_preference IN ('en', 'es', 'fr', 'de', 'zh', 'ja')),
        
    CONSTRAINT chk_settings_theme 
        CHECK (theme IN ('light', 'dark', 'auto')),
        
    CONSTRAINT chk_settings_video_quality 
        CHECK (video_quality IN ('auto', '240p', '360p', '480p', '720p', '1080p')),
        
    CONSTRAINT chk_settings_playback_speed 
        CHECK (playback_speed >= 0.25 AND playback_speed <= 3.00)
);

-- Example 2: Computed/Expression Defaults
CREATE TABLE course_analytics (
    analytics_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(36) NOT NULL,
    
    -- Counters with defaults
    total_enrollments INT DEFAULT 0,
    active_students INT DEFAULT 0,
    completed_students INT DEFAULT 0,
    
    -- Computed percentages (will be updated by triggers/procedures)
    completion_rate DECIMAL(5,2) DEFAULT 0.00,
    average_rating DECIMAL(3,2) DEFAULT 0.00,
    
    -- Revenue tracking
    gross_revenue DECIMAL(12,2) DEFAULT 0.00,
    net_revenue DECIMAL(12,2) DEFAULT 0.00,
    
    -- Timestamps
    last_enrollment DATE DEFAULT (CURRENT_DATE),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_analytics_course 
        FOREIGN KEY (course_id) 
        REFERENCES courses(course_id) 
        ON DELETE CASCADE,
        
    CONSTRAINT uk_analytics_course UNIQUE (course_id),
    
    -- Validation constraints
    CONSTRAINT chk_analytics_completion_rate 
        CHECK (completion_rate >= 0.00 AND completion_rate <= 100.00),
        
    CONSTRAINT chk_analytics_average_rating 
        CHECK (average_rating >= 0.00 AND average_rating <= 5.00),
        
    CONSTRAINT chk_analytics_revenue 
        CHECK (gross_revenue >= 0 AND net_revenue >= 0 AND net_revenue <= gross_revenue)
);

-- ============================================
-- COMPLEX REAL-WORLD EXAMPLES
-- ============================================

-- Example 1: Complete E-Learning Order System
CREATE TABLE orders (
    order_id VARCHAR(36) PRIMARY KEY,
    user_id INT NOT NULL,
    
    -- Order details with defaults and constraints
    order_status ENUM('cart', 'pending', 'processing', 'completed', 'cancelled', 'refunded') 
        DEFAULT 'cart',
    
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL DEFAULT NULL,
    
    -- Payment info
    payment_method VARCHAR(50),
    payment_reference VARCHAR(100),
    
    -- Address info (can be NULL for digital products)
    billing_address_id INT,
    
    -- Constraints
    CONSTRAINT fk_orders_user 
        FOREIGN KEY (user_id) 
        REFERENCES users(user_id),
        
    -- Business rule: total = subtotal + tax - discount
    CONSTRAINT chk_orders_total_calculation 
        CHECK (ABS(total_amount - (subtotal + tax_amount - discount_amount)) < 0.01),
        
    -- All amounts must be non-negative
    CONSTRAINT chk_orders_amounts_positive 
        CHECK (subtotal >= 0 AND tax_amount >= 0 AND discount_amount >= 0 AND total_amount >= 0),
        
    -- Discount cannot exceed subtotal
    CONSTRAINT chk_orders_discount_limit 
        CHECK (discount_amount <= subtotal),
        
    -- Completed orders must have payment info
    CONSTRAINT chk_orders_completed_payment 
        CHECK (
            order_status != 'completed' OR 
            (payment_method IS NOT NULL AND payment_reference IS NOT NULL)
        )
);

-- Example 2: Learning Progress Tracking
CREATE TABLE learning_progress (
    progress_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id VARCHAR(36) NOT NULL,
    lesson_id INT NOT NULL,
    
    -- Progress tracking
    status ENUM('not_started', 'in_progress', 'completed') DEFAULT 'not_started',
    progress_percentage DECIMAL(5,2) DEFAULT 0.00,
    time_spent_minutes INT DEFAULT 0,
    
    -- Timestamps
    first_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    
    -- Quiz/Assessment scores
    quiz_score DECIMAL(5,2) DEFAULT NULL,
    passing_score DECIMAL(5,2) DEFAULT 70.00,
    attempts_count INT DEFAULT 0,
    max_attempts INT DEFAULT 3,
    
    -- Constraints
    CONSTRAINT fk_progress_user 
        FOREIGN KEY (user_id) 
        REFERENCES users(user_id) 
        ON DELETE CASCADE,
        
    CONSTRAINT fk_progress_course 
        FOREIGN KEY (course_id) 
        REFERENCES courses(course_id) 
        ON DELETE CASCADE,
        
    CONSTRAINT fk_progress_lesson 
        FOREIGN KEY (lesson_id) 
        REFERENCES lessons(lesson_id) 
        ON DELETE CASCADE,
        
    -- One progress record per user per lesson
    CONSTRAINT uk_progress_user_lesson UNIQUE (user_id, lesson_id),
    
    -- Progress percentage must be 0-100
    CONSTRAINT chk_progress_percentage 
        CHECK (progress_percentage >= 0.00 AND progress_percentage <= 100.00),
        
    -- Quiz score must be 0-100 if not null
    CONSTRAINT chk_progress_quiz_score 
        CHECK (quiz_score IS NULL OR (quiz_score >= 0.00 AND quiz_score <= 100.00)),
        
    -- Passing score must be 0-100
    CONSTRAINT chk_progress_passing_score 
        CHECK (passing_score >= 0.00 AND passing_score <= 100.00),
        
    -- Time spent must be non-negative
    CONSTRAINT chk_progress_time_spent 
        CHECK (time_spent_minutes >= 0),
        
    -- Attempts cannot exceed maximum
    CONSTRAINT chk_progress_attempts 
        CHECK (attempts_count >= 0 AND attempts_count <= max_attempts),
        
    -- If completed, must have 100% progress
    CONSTRAINT chk_progress_completed_status 
        CHECK (
            status != 'completed' OR 
            (progress_percentage = 100.00 AND completed_at IS NOT NULL)
        ),
        
    -- Last accessed must be after or equal to first accessed
    CONSTRAINT chk_progress_access_dates 
        CHECK (last_accessed >= first_accessed)
);

-- ============================================
-- SAMPLE DATA WITH CONSTRAINT DEMONSTRATIONS
-- ============================================

-- Insert sample data that demonstrates constraint behavior

INSERT INTO users (username, email) VALUES 
('johndoe', 'john.doe@email.com'),
('janesmaith', 'jane.smith@email.com'),
('bobwilson', 'bob.wilson@email.com');

INSERT INTO instructors (instructor_id, first_name, last_name, bio) VALUES 
(1, 'Dr. Alice', 'Johnson', 'PhD in Computer Science with 10 years teaching experience'),
(2, 'Prof. David', 'Brown', 'Industry expert with 15 years in web development'),
(3, 'Sarah', 'Davis', 'Certified data scientist and machine learning specialist');

INSERT INTO courses (course_id, course_title, description, price) VALUES 
('course-001', 'Introduction to SQL', 'Learn SQL from basics to advanced queries', 99.99),
('course-002', 'Python for Beginners', 'Complete Python programming course', 149.99),
('course-003', 'Web Development Bootcamp', 'Full-stack web development', 299.99);

-- This will work - valid foreign key
INSERT INTO lessons (course_id, lesson_title, content, duration_minutes, lesson_order) VALUES 
('course-001', 'What is SQL?', 'Introduction to SQL and databases', 15, 1),
('course-001', 'Basic SELECT Statements', 'Learning to query data', 30, 2),
('course-002', 'Python Basics', 'Variables, data types, and operators', 45, 1);

-- This will work - valid enrollment
INSERT INTO enrollments (user_id, course_id) VALUES 
(1, 'course-001'),
(1, 'course-002'),
(2, 'course-001'),
(3, 'course-003');

-- Examples of constraint violations (commented out to avoid errors):

/*
-- This would violate PRIMARY KEY constraint (duplicate)
INSERT INTO users (user_id, username, email) VALUES 
(1, 'duplicate', 'duplicate@email.com');

-- This would violate UNIQUE constraint (duplicate email)
INSERT INTO users (username, email) VALUES 
('newuser', 'john.doe@email.com');

-- This would violate FOREIGN KEY constraint (non-existent course)
INSERT INTO lessons (course_id, lesson_title) VALUES 
('course-999', 'Non-existent Course Lesson');

-- This would violate CHECK constraint (invalid rating)
INSERT INTO course_reviews (user_id, course_id, rating) VALUES 
(1, 'course-001', 6);  -- Rating must be 1-5

-- This would violate NOT NULL constraint
INSERT INTO payments (user_id, course_id) VALUES 
(1, NULL);  -- course_id cannot be NULL
*/

-- ============================================
-- CONSTRAINT INFORMATION QUERIES
-- ============================================

-- View all constraints in the database
SELECT 
    TABLE_NAME,
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE,
    ENFORCED
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'learning_platform'
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

-- View foreign key relationships
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME,
    UPDATE_RULE,
    DELETE_RULE
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'learning_platform'
AND REFERENCED_TABLE_NAME IS NOT NULL;

-- View check constraints (MySQL 8.0+)
SELECT 
    CONSTRAINT_SCHEMA,
    TABLE_NAME,
    CONSTRAINT_NAME,
    CHECK_CLAUSE
FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'learning_platform';

-- View column defaults and nullable status
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    EXTRA
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'learning_platform'
ORDER BY TABLE_NAME, ORDINAL_POSITION;