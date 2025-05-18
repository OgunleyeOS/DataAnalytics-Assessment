SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) + 1 AS tenure_months,
    COUNT(s.id) AS total_transactions,
    ROUND(
        (COUNT(s.id) / (TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) + 1)) * 12 *
        (IFNULL(AVG(s.confirmed_amount), 0) / 100.0 * 0.001), 2
    ) AS estimated_clv
FROM
    users_customuser u
LEFT JOIN
    savings_savingsaccount s ON s.owner_id = u.id AND s.confirmed_amount > 0
GROUP BY
    u.id, u.first_name, u.last_name, u.date_joined
ORDER BY
    estimated_clv DESC;