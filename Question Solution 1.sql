-- High-Value Customers with both funded savings and investment plans
WITH savings AS (
    SELECT 
        p.owner_id,
        COUNT(DISTINCT p.id) AS savings_count,
        SUM(s.confirmed_amount) AS savings_amount
    FROM plans_plan p
    JOIN savings_savingsaccount s ON s.plan_id = p.id
    WHERE p.is_regular_savings = 1 AND s.confirmed_amount > 0
    GROUP BY p.owner_id
),
investments AS (
    SELECT 
        p.owner_id,
        COUNT(DISTINCT p.id) AS investment_count,
        SUM(s.confirmed_amount) AS investment_amount
    FROM plans_plan p
    JOIN savings_savingsaccount s ON s.plan_id = p.id
    WHERE p.is_a_fund = 1 AND s.confirmed_amount > 0
    GROUP BY p.owner_id
)
SELECT 
    u.id AS owner_id,
    CONCAT (u.first_name, ' ', u.last_name) AS name,
    s.savings_count,
    i.investment_count,
    ROUND((COALESCE(s.savings_amount, 0) + COALESCE(i.investment_amount, 0)) / 100.0, 2) AS total_deposits
FROM users_customuser u
JOIN savings s ON s.owner_id = u.id
JOIN investments i ON i.owner_id = u.id
ORDER BY total_deposits DESC;

 