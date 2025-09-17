# 📚 Recursive CTEs: Explained Like You're Learning to Ride a Bike

## 🎯 What Are We Actually Doing?

Imagine you have a **family tree** or **company organization chart**. A recursive CTE helps you answer questions like:
- "Who reports to whom, all the way down?"
- "How much does each branch of the company cost in salaries?"
- "Who's ultimately in charge of this employee?"

## 🧩 Our Practice Data (Demi Tables)

Let's create a simple company structure:

```sql
-- Our pretend company employees
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    position VARCHAR(50),
    manager_id INT  -- This points to who their boss is
);

-- Insert our sample data
INSERT INTO employees VALUES
(1, 'Sarah', 'CEO', NULL),       -- Sarah has no boss (NULL)
(2, 'John', 'VP Engineering', 1), -- John reports to Sarah (ID 1)
(3, 'Lisa', 'VP Marketing', 1),   -- Lisa reports to Sarah
(4, 'Mike', 'Engineering Manager', 2), -- Mike reports to John
(5, 'Anna', 'Marketing Manager', 3),   -- Anna reports to Lisa
(6, 'David', 'Developer', 4),     -- David reports to Mike
(7, 'Emma', 'Designer', 4);       -- Emma reports to Mike
```

**Visualize this structure:**
```
Sarah (CEO)
├── John (VP Engineering)
│   └── Mike (Engineering Manager)
│       ├── David (Developer)
│       └── Emma (Designer)
└── Lisa (VP Marketing)
    └── Anna (Marketing Manager)
```

## 🚀 Your First Recursive CTE

Let's find **everyone who reports to Sarah, directly or indirectly**:

```sql
WITH RECURSIVE SarahsTeam AS (
    -- Step 1: Find Sarah (the anchor)
    SELECT id, name, position, manager_id, 1 as level
    FROM employees 
    WHERE name = 'Sarah'  -- This is our starting point!
    
    UNION ALL
    
    -- Step 2: Find people who report to anyone in SarahsTeam
    SELECT e.id, e.name, e.position, e.manager_id, st.level + 1
    FROM employees e
    INNER JOIN SarahsTeam st ON e.manager_id = st.id
    -- This says: "Find employees whose manager is already in SarahsTeam"
)
SELECT * FROM SarahsTeam;
```

**What happens step-by-step:**

1. **Anchor finds Sarah**: `(1, 'Sarah', 'CEO', NULL, 1)`
2. **First recursion finds**: John and Lisa (they report to Sarah)
3. **Second recursion finds**: Mike and Anna (they report to John and Lisa)
4. **Third recursion finds**: David and Emma (they report to Mike)
5. **Fourth recursion finds**: Nobody (David and Emma have no subordinates)

**Final Result:**
| id | name  | position            | manager_id | level |
|----|-------|---------------------|------------|-------|
| 1  | Sarah | CEO                 | NULL       | 1     |
| 2  | John  | VP Engineering      | 1          | 2     |
| 3  | Lisa  | VP Marketing        | 1          | 2     |
| 4  | Mike  | Engineering Manager | 2          | 3     |
| 5  | Anna  | Marketing Manager   | 3          | 3     |
| 6  | David | Developer           | 4          | 4     |
| 7  | Emma  | Designer            | 4          | 4     |

## 🧠 Breaking Down the Syntax

### Part 1: The Anchor
```sql
SELECT id, name, position, manager_id, 1 as level
FROM employees 
WHERE name = 'Sarah'
```
- **Purpose**: Find your starting point
- **Like saying**: "Start with Sarah at level 1"

### Part 2: The Recursive Join
```sql
INNER JOIN SarahsTeam st ON e.manager_id = st.id
```
- **Purpose**: Connect employees to their managers who are already in the results
- **Like saying**: "Find people who work for anyone we've already found"

### Part 3: UNION ALL
- **Purpose**: Combine the anchor results with each round of new findings
- **Keeps** all results (don't remove duplicates)

## 🎪 Cool Things You Can Do

### 1. Show the Management Chain
```sql
WITH RECURSIVE ManagementChain AS (
    SELECT id, name, position, manager_id, 
           CAST(name AS TEXT) AS chain
    FROM employees 
    WHERE name = 'David'  -- Start with David
    
    UNION ALL
    
    SELECT e.id, e.name, e.position, e.manager_id,
           CAST(mc.chain || ' ← ' || e.name AS TEXT)
    FROM employees e
    INNER JOIN ManagementChain mc ON e.id = mc.manager_id
)
SELECT * FROM ManagementChain;
```

**Result:**
```
David ← Mike ← John ← Sarah
```

### 2. Calculate Team Costs
```sql
WITH RECURSIVE TeamCosts AS (
    SELECT id, name, position, manager_id, 1 as level,
           50000 as salary  -- Let's pretend everyone makes 50k
    FROM employees 
    WHERE name = 'John'  -- Start with John's team
    
    UNION ALL
    
    SELECT e.id, e.name, e.position, e.manager_id, tc.level + 1,
           50000 as salary
    FROM employees e
    INNER JOIN TeamCosts tc ON e.manager_id = tc.id
)
SELECT SUM(salary) as total_team_cost FROM TeamCosts;
```

**Result:** John's team costs $200,000 (John + Mike + David + Emma)

## ⚠️ Important Safety Tips!

1. **Always have a stopping condition** - The recursion stops when no new rows are found
2. **Watch for cycles** - If an employee somehow reports to themselves (bad data!), this could loop forever
3. **Most databases have recursion limits** (usually 100-1000 levels) to prevent infinite loops

## 🎯 When to Use Recursive CTEs

- **Organization charts** (who reports to whom)
- **Category trees** (products in categories and subcategories)
- **Social networks** (friends of friends)
- **File systems** (folders and subfolders)

## 🏁 Summary

Think of recursive CTEs like this:
1. **Anchor**: "Start with this person" 🎯
2. **Recursive**: "Find everyone who reports to people we've already found" 🔍
3. **Combine**: "Keep adding to our results until nobody new is found"

**It's basically a "keep looking until you can't find any more" query!**

## Your Turn to Practice!

Try this: Can you modify the first example to find **everyone who reports to John** instead of Sarah?

```sql
-- Your code here!
```

Remember: Just change the anchor to start with John instead of Sarah! 😊
