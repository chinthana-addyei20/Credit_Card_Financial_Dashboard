-- ============================================================
-- Credit Card Financial Dashboard - Analysis Queries
-- These queries were run in PostgreSQL AFTER importing the data
-- (see SQL_Query_-_Financial_Dashboard_Data.sql for table creation
-- and CSV import steps)
-- ============================================================


-- 1. Total revenue and average transaction amount by card category
-- Business question: Which card category brings in the most transaction value?
SELECT 
    Card_Category,
    SUM(Total_Trans_Amt) AS total_transaction_amount,
    ROUND(AVG(Total_Trans_Amt), 2) AS avg_transaction_amount,
    COUNT(*) AS num_customers
FROM cc_detail
GROUP BY Card_Category
ORDER BY total_transaction_amount DESC;


-- 2. Customer demographics joined with card usage behavior
-- Business question: Does education level or gender relate to card utilization
-- and satisfaction?
SELECT 
    c.Gender,
    c.Education_Level,
    ROUND(AVG(cc.Avg_Utilization_Ratio), 3) AS avg_utilization,
    ROUND(AVG(c.Cust_Satisfaction_Score), 2) AS avg_satisfaction
FROM cust_detail c
JOIN cc_detail cc 
    ON c.Client_Num = cc.Client_Num
GROUP BY c.Gender, c.Education_Level
ORDER BY avg_utilization DESC;


-- 3. High-risk customers: high credit utilization + delinquent accounts
-- Business question: Which customers should be flagged for credit risk review?
SELECT 
    cc.Client_Num,
    cc.Avg_Utilization_Ratio,
    cc.Delinquent_Acc,
    c.Income,
    c.Customer_Job
FROM cc_detail cc
JOIN cust_detail c 
    ON cc.Client_Num = c.Client_Num
WHERE cc.Avg_Utilization_Ratio > 0.7 
  AND cc.Delinquent_Acc = 'yes'
ORDER BY cc.Avg_Utilization_Ratio DESC;


-- 4. Revenue by expenditure type per quarter
-- Business question: Which spending categories drive revenue, and does it
-- change quarter to quarter?
SELECT 
    Qtr,
    Exp_Type,
    SUM(Total_Trans_Amt) AS total_spent
FROM cc_detail
GROUP BY Qtr, Exp_Type
ORDER BY Qtr, total_spent DESC;


-- 5. Income group vs credit limit and revolving balance
-- Business question: Do higher-income customers carry higher balances,
-- or manage credit more conservatively?
SELECT 
    c.Income,
    ROUND(AVG(cc.Credit_Limit), 2) AS avg_credit_limit,
    ROUND(AVG(cc.Total_Revolving_Bal), 2) AS avg_revolving_balance
FROM cust_detail c
JOIN cc_detail cc 
    ON c.Client_Num = cc.Client_Num
GROUP BY c.Income
ORDER BY c.Income DESC;


-- 6. Top 10 customers by total transaction amount
-- Business question: Who are the highest-value customers?
SELECT 
    cc.Client_Num,
    c.Customer_Job,
    c.Income,
    cc.Total_Trans_Amt,
    cc.Total_Trans_Ct
FROM cc_detail cc
JOIN cust_detail c 
    ON cc.Client_Num = c.Client_Num
ORDER BY cc.Total_Trans_Amt DESC
LIMIT 10;
