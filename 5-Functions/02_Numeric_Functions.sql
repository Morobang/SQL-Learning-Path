-- 02_Numeric_Functions.sql
-- ======================================
-- LESSON: SQL Numeric Functions
-- Numeric functions let you perform calculations
-- and transform numeric values inside queries.

-- ======================================
-- Example Table: products
-- id | product  | price | discount
--  1 | Apple    |  2.546 | 0.1
--  2 | Orange   |  3.999 | 0.2
--  3 | Banana   |  1.245 | 0.15
--  4 | Mango    |  5.75  | 0.05

-- ======================================
-- 1. ROUND: Round a number to given decimal places
SELECT product, price, ROUND(price, 2) AS rounded_price
FROM products;

-- 2. CEIL / CEILING: Round UP to nearest whole number
SELECT product, price, CEIL(price) AS ceil_price
FROM products;

-- 3. FLOOR: Round DOWN to nearest whole number
SELECT product, price, FLOOR(price) AS floor_price
FROM products;

-- 4. ABS: Absolute value (removes negative sign)
SELECT ABS(-10) AS positive_number;

-- 5. POWER: Raise number to a power
SELECT POWER(2, 3) AS two_cubed; -- 2^3 = 8

-- 6. SQRT: Square root of a number
SELECT SQRT(25) AS square_root;

-- 7. MOD: Remainder after division
SELECT MOD(10, 3) AS remainder; -- 10 ÷ 3 = 3 remainder 1

-- ======================================
-- COMBINING NUMERIC FUNCTIONS
-- Example: Calculate final price after discount,
-- rounded to 2 decimal places
SELECT product,
       price,
       discount,
       ROUND(price - (price * discount), 2) AS final_price
FROM products;

-- ======================================
-- PRACTICE QUESTIONS
-- 1. Round all prices to 1 decimal place.
-- 2. Show the ceiling and floor of each product price.
-- 3. Find the square root of 81.
-- 4. Use POWER to calculate 5^2.
-- 5. Get the remainder when dividing each price by 2.

-- ======================================
-- END OF LESSON
