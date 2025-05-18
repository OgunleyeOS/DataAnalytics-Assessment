# DataAnalytics-Assessment
SQL Proficiency Assessment Customer and Account Insights

This project answers four business driven SQL questions using real customer, savings and investment data. The goal is to uncover customer behavior, identify high-value users, monitor account activity and estimate customer value over time.

## Question 1: High-Value Customers with Multiple Products
Goal: Find customers who actively use both funded savings and investment plans, highlighting opportunities for cross-selling.

Approach: To tackle this, I wrote the query using Common Table Expressions (CTEs) to keep things organized and intuitive:  
The savings CTE pulls the count of savings plans and their total funded amounts for each customer. The investments CTE does the same for investment plans.

Both CTEs filter for plans with confirmed deposits (confirmed_amount > 0) to ensure only looking at active accounts. Then, I joined these CTEs with the user table to identify customers who have both types of plans, ensuring only those with activity in both appear in the results.


## Question 2: Transaction Frequency Analysis
Goal: Group customers by their transaction frequency to inform targeted marketing and boost engagement.

Approach:
Counted all valid savings transactions (where confirmed_amount > 0).  
Calculated the time span between each customer’s earliest and latest transactions to get their active months.  

Divided transactions by months to get the average transactions per month, then used a CASE statement to assign each customer to a frequency bucket into three categories:  

High Frequency: 10+ transactions per month  
Medium Frequency: 3–9 transactions per month  
Low Frequency: 2 or fewer transactions per month

Grouped the results to show how many customers fall into each bucket.

## Question 3: Account Inactivity Alert
Goal: Find all active savings and investment accounts with no inflow transactions in the last 365 days.

Approach:
I joined plans_plan with savings_savingsaccount (filtered on confirmed_amount > 0) and grouped by plan ID to find:
The most recent inflow (MAX(transaction_date))

Days since that transaction (DATEDIFF(CURDATE(), last_transaction_date))

Plans were flagged if:
They had no inflow at all (last_transaction_date IS NULL) Or had a last inflow over 365 days ago

Interpreting NULLs:
When last_transaction_date is NULL, i assume it means the plan was created but never funded, a strong indicator of long-term dormancy.
No inflows = no activity, which still qualifies as inactivity.

## Question 4: Customer Lifetime Value (CLV) Estimation
Goal: Estimate the lifetime value of each customer using a simplified formula:

CLV = (Total Transactions / Tenure in months) * 12 * Avg Profit per Transaction
(With profit = 0.1% of transaction value)

Approach:
Calculated tenure in months since user signup.

Counted all valid transactions per user.

Computed average profit per transaction.

Used the provided formula to estimate CLV per user and ordered results from highest to lowest CLV

Some users had no transactions, resulting in NULL values for CLV. I used COALESCE to return 0 instead of NULL.

# Challenges & Fixes

| Challenge                               | Solution                                                                                 |
| --------------------------------------- | ---------------------------------------------------------------------------------------- |
| `name` column had NULLs and blanks           | Replaced with a **concatenation** of `first_name` and `last_name` using `CONCAT` function     |
| NULLs in `transaction_date` column               | Asummed as unfunded plans — treated as valid inactive accounts                         |
| `savings_savingsaccount` Dataset transaction date ended in Oct 2023               |  “last 1 year” should be treated relative to the latest available transaction date in the dataset (not the current date) to ensure fairness in evaluation |
| CLV calculation returned NULL for some users | Used COALESCE() to convert NULL estimated CLV values to 0, especially for users with no transactions  |
