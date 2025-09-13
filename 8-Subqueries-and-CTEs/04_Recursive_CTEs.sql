sql
-- 04_Recursive_CTEs.sql
-- Recursive Common Table Expressions in SQL
-- A comprehensive guide with detailed explanations and examples

/*
WHAT ARE RECURSIVE CTEs?
Recursive CTEs allow you to work with hierarchical or tree-structured data.
They consist of two parts:
1. Anchor member: The initial query that provides the starting point
2. Recursive member: The query that references the CTE itself, building upon previous results

IMPORTANT: Recursive CTEs must use the RECURSIVE keyword
*/

-- Sample Data: Organizational Hierarchy
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    position VARCHAR(50),
    manager_id INT,
    salary DECIMAL(10, 2)
);

-- Insert sample organizational data
INSERT INTO employees VALUES
(1, 'Sarah', 'CEO', NULL, 100000),          -- Top level (no manager)
(2, 'John', 'VP of Engineering', 1, 90000), -- Reports to Sarah
(3, 'Lisa', 'VP of Marketing', 1, 85000),   -- Reports to Sarah
(4, 'Mike', 'Engineering Manager', 2, 80000), -- Reports to John
(5, 'Anna', 'Marketing Manager', 3, 78000), -- Reports to Lisa
(6, 'David', 'Senior Developer', 4, 75000), -- Reports to Mike
(7, 'Emma', 'Developer', 4, 70000),         -- Reports to Mike
(8, 'Chris', 'Marketing Specialist', 5, 65000), -- Reports to Anna
(9, 'Olivia', 'Content Writer', 5, 60000);  -- Reports to Anna

/*
EXAMPLE 1: BASIC RECURSIVE CTE
Display the complete organizational hierarchy with levels
*/
WITH RECURSIVE OrgChart AS (
    -- Anchor member: Top-level employees (those with no manager)
    SELECT 
        employee_id,
        name,
        position,
        manager_id,
        1 AS level,                  -- Start at level 1
        CAST(name AS VARCHAR(255)) AS hierarchy_path
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive member: Find subordinates of current level
    SELECT 
        e.employee_id,
        e.name,
        e.position,
        e.manager_id,
        oc.level + 1 AS level,       -- Increment level
        CAST(oc.hierarchy_path || ' -> ' || e.name AS VARCHAR(255)) AS hierarchy_path
    FROM employees e
    INNER JOIN OrgChart oc ON e.manager_id = oc.employee_id
)
SELECT 
    employee_id,
    name,
    position,
    manager_id,
    level,
    hierarchy_path
FROM OrgChart
ORDER BY level, name;

/*
WHAT HAPPENS IN EXAMPLE 1:
1. Anchor query finds Sarah (CEO) at level 1
2. First recursion finds John and Lisa (VPs) at level 2
3. Second recursion finds Mike and Anna (Managers) at level 3
4. Third recursion finds David, Emma, Chris, Olivia at level 4
5. The hierarchy_path shows the complete reporting chain
*/

/*
EXAMPLE 2: CALCULATE TOTAL SALARY BY DEPARTMENT BRANCH
Show the total salary cost for each managerial branch
*/
WITH RECURSIVE SalaryTree AS (
    -- Anchor member: Start with top-level employees
    SELECT 
        employee_id,
        name,
        position,
        manager_id,
        salary,
        salary AS total_branch_salary  -- For top-level, total = own salary
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive member: Add subordinate salaries to manager's total
    SELECT 
        e.employee_id,
        e.name,
        e.position,
        e.manager_id,
        e.salary,
        st.total_branch_salary + e.salary AS total_branch_salary
    FROM employees e
    INNER JOIN SalaryTree st ON e.manager_id = st.employee_id
)
SELECT 
    employee_id,
    name,
    position,
    manager_id,
    salary,
    total_branch_salary,
    ROUND((salary / total_branch_salary) * 100, 2) AS salary_percentage
FROM SalaryTree
ORDER BY total_branch_salary DESC;

/*
WHAT HAPPENS IN EXAMPLE 2:
1. Starts with Sarah (total_branch_salary = 100000)
2. Adds John's salary to Sarah's branch: 100000 + 90000 = 190000
3. Continues down each branch, accumulating salaries
4. Shows what percentage each person's salary is of their branch total
*/

/*
EXAMPLE 3: FIND ALL SUBORDINATES OF A SPECIFIC MANAGER
Get the complete team under Lisa (VP of Marketing)
*/
WITH RECURSIVE MarketingTeam AS (
    -- Anchor member: Start with Lisa
    SELECT 
        employee_id,
        name,
        position,
        manager_id,
        1 AS level
    FROM employees
    WHERE name = 'Lisa'  -- Start with Lisa
    
    UNION ALL
    
    -- Recursive member: Find all subordinates
    SELECT 
        e.employee_id,
        e.name,
        e.position,
        e.manager_id,
        mt.level + 1 AS level
    FROM employees e
    INNER JOIN MarketingTeam mt ON e.manager_id = mt.employee_id
)
SELECT 
    employee_id,
    name,
    position,
    manager_id,
    level
FROM MarketingTeam
ORDER BY level, name;

/*
EXAMPLE 4: DETECT MANAGEMENT CHAIN FOR A SPECIFIC EMPLOYEE
Find the complete management chain for Olivia (Content Writer)
*/
WITH RECURSIVE ManagementChain AS (
    -- Anchor member: Start with Olivia
    SELECT 
        employee_id,
        name,
        position,
        manager_id,
        0 AS level
    FROM employees
    WHERE name = 'Olivia'  -- Start with Olivia
    
    UNION ALL
    
    -- Recursive member: Move up the chain to find managers
    SELECT 
        e.employee_id,
        e.name,
        e.position,
        e.manager_id,
        mc.level - 1 AS level  -- Negative levels for managers above
    FROM employees e
    INNER JOIN ManagementChain mc ON e.employee_id = mc.manager_id
)
SELECT 
    employee_id,
    name,
    position,
    manager_id,
    level
FROM ManagementChain
ORDER BY level;

/*
WHAT HAPPENS IN EXAMPLE 4:
1. Starts with Olivia (level 0)
2. Finds her manager: Anna (level -1)
3. Finds Anna's manager: Lisa (level -2)
4. Finds Lisa's manager: Sarah (level -3)
5. Shows the complete chain from CEO to employee
*/

/*
EXAMPLE 5: FIND EMPLOYEES WITH NO SUBORDINATES (LEAF NODES)
Identify employees who are not managers of anyone
*/
WITH RECURSIVE OrgStructure AS (
    -- Anchor member: All employees
    SELECT 
        employee_id,
        name,
        position,
        manager_id,
        1 AS has_subordinates
    FROM employees
    
    UNION ALL
    
    -- Mark managers as having subordinates
    SELECT 
        os.employee_id,
        os.name,
        os.position,
        os.manager_id,
        0 AS has_subordinates  -- This will be overwritten for managers
    FROM OrgStructure os
    INNER JOIN employees e ON os.employee_id = e.manager_id
)
SELECT DISTINCT
    employee_id,
    name,
    position,
    manager_id
FROM OrgStructure
WHERE employee_id NOT IN (
    SELECT manager_id 
    FROM employees 
    WHERE manager_id IS NOT NULL
)
ORDER BY position;

/*
EXAMPLE 6: CALCULATE AVERAGE SALARY BY LEVEL
Show how average salary changes at each organizational level
*/
WITH RECURSIVE LeveledEmployees AS (
    -- Anchor member: Top-level employees
    SELECT 
        employee_id,
        name,
        position,
        manager_id,
        salary,
        1 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive member: Add subordinates with level + 1
    SELECT 
        e.employee_id,
        e.name,
        e.position,
        e.manager_id,
        e.salary,
        le.level + 1 AS level
    FROM employees e
    INNER JOIN LeveledEmployees le ON e.manager_id = le.employee_id
)
SELECT 
    level,
    COUNT(*) AS employee_count,
    ROUND(AVG(salary), 2) AS average_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM LeveledEmployees
GROUP BY level
ORDER BY level;

/*
SAFETY NOTE: RECURSIVE CTE LIMITATIONS
Recursive CTEs have built-in safeguards:
1. Maximum recursion depth (usually 100-1000 levels depending on database)
2. You can specify MAXRECURSION option if needed
*/

-- Example with recursion limit (SQL Server syntax shown, varies by database)
/*
WITH RECURSIVE OrgChart AS (
    -- Anchor member
    SELECT employee_id, name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive member
    SELECT e.employee_id, e.name, e.manager_id, oc.level + 1
    FROM employees e
    INNER JOIN OrgChart oc ON e.manager_id = oc.employee_id
)
SELECT * FROM OrgChart
OPTION (MAXRECURSION 50);  -- Limit to 50 recursion levels
*/

/*
CLEAN UP (optional)
DROP TABLE employees;
*/

/*
KEY TAKEAWAYS:
1. Recursive CTEs are essential for hierarchical data
2. Always have an anchor member and recursive member
3. Use UNION ALL to combine results
4. Be mindful of recursion limits
5. Useful for organizational charts, category trees, bill of materials
6. Can traverse both downward (subordinates) and upward (managers)
*/
