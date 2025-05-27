-- Summary of customers by frequency category
SELECT
    txn_category AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM (
    SELECT
        u.id AS owner_id,
        u.name,
        COUNT(s.id) AS total_transactions,
        ROUND(COUNT(s.id) / (DATEDIFF(MAX(s.transaction_date), MIN(s.transaction_date)) / 30.0 + 1), 2) AS avg_txn_per_month,
        CASE
            WHEN ROUND(COUNT(s.id) / (DATEDIFF(MAX(s.transaction_date), MIN(s.transaction_date)) / 30.0 + 1), 2) >= 8 THEN 'High Frequency'
            WHEN ROUND(COUNT(s.id) / (DATEDIFF(MAX(s.transaction_date), MIN(s.transaction_date)) / 30.0 + 1), 2) BETWEEN 4 AND 7 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS txn_category
    FROM
        users_customuser u
    JOIN
        savings_savingsaccount s ON s.owner_id = u.id
    GROUP BY
        u.id, u.name
) AS freq_data
GROUP BY
    txn_category
ORDER BY
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
