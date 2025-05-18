-- Inactive accounts with no inflow in 365 days
SELECT
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Unknown'
    END AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    -- last_transaction_date is NULL, inactivity_days set to full difference from a fixed point
    CASE
        WHEN MAX(s.transaction_date) IS NULL THEN DATEDIFF(CURDATE(), p.created_on)
        ELSE DATEDIFF(CURDATE(), MAX(s.transaction_date))
    END AS inactivity_days
FROM
    plans_plan p
LEFT JOIN
    savings_savingsaccount s 
    ON s.plan_id = p.id 
    AND s.confirmed_amount > 0
WHERE
    p.is_regular_savings = 1 OR p.is_a_fund = 1
GROUP BY
    p.id, p.owner_id, type, p.created_on
HAVING
    last_transaction_date IS NULL OR inactivity_days > 365
ORDER BY
    inactivity_days ASC;
