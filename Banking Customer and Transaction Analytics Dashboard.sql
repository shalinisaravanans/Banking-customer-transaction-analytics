CREATE DATABASE banking_analytics;
USE banking_analytics;
CREATE TABLE bank_data ( Branch_ID VARCHAR(50), City VARCHAR(100), Region VARCHAR(100), Firm_Revenue DECIMAL(15,2), Expenses DECIMAL(15,2), Profit_Margin DECIMAL(10,4) );
CREATE TABLE customer_data ( Customer_ID VARCHAR(50), Age INT, Customer_Type VARCHAR(100), City VARCHAR(100), Region VARCHAR(100), Bank_Name VARCHAR(100), Branch_ID VARCHAR(50), Age_Group VARCHAR(20) );
CREATE TABLE transaction_data ( Transaction_ID VARCHAR(50), Customer_ID VARCHAR(50), Account_Type VARCHAR(100), Total_Balance DECIMAL(15,2), Transaction_Amount DECIMAL(15,2), Investment_Amount DECIMAL(15,2), Investment_Type VARCHAR(100), Transaction_Date DATE );
ALTER TABLE bank_data
ADD COLUMN Profit DECIMAL(15,2);
ALTER TABLE transaction_data
ADD COLUMN Customer_Type VARCHAR(100),
ADD COLUMN Region VARCHAR(100);
SELECT COUNT(*) AS total_rows FROM bank_data;
SELECT COUNT(*) AS total_rows FROM customer_data;
SELECT COUNT(*) AS total_rows FROM transaction_data;
SELECT * FROM transaction_data LIMIT 5;
CREATE TABLE transaction_data (
    Transaction_ID VARCHAR(50),
    Customer_ID VARCHAR(50),
    Account_Type VARCHAR(100),
    Total_Balance DECIMAL(15,2),
    Transaction_Amount DECIMAL(15,2),
    Investment_Amount DECIMAL(15,2),
    Investment_Type VARCHAR(100),
    Transaction_Date DATE,
    Customer_Type VARCHAR(100),
    Region VARCHAR(100)
);
DROP TABLE transaction_data; 
SELECT * FROM bank_data LIMIT 10;
SELECT * FROM customer_data LIMIT 10;
SELECT * FROM transaction_data LIMIT 10;
SELECT COUNT(*) AS total_rows, SUM(Firm_Revenue IS NULL) AS missing_revenue FROM bank_data;
SELECT SUM(Age IS NULL) AS missing_age, SUM(Customer_Type IS NULL) AS missing_customer_type, SUM(City IS NULL) AS missing_city FROM customer_data;
SELECT SUM(Transaction_Date IS NULL) AS missing_transaction_date FROM transaction_data;
SELECT Branch_ID, COUNT(*) AS cnt FROM bank_data GROUP BY Branch_ID HAVING COUNT(*) > 1;
SELECT Customer_ID, COUNT(*) AS cnt FROM customer_data GROUP BY Customer_ID HAVING COUNT(*) > 1;
SELECT Transaction_ID, COUNT(*) AS cnt FROM transaction_data GROUP BY Transaction_ID HAVING COUNT(*) > 1;
SELECT COUNT(*) AS total_rows
FROM transaction_data;
TRUNCATE TABLE transaction_data;
SELECT COUNT(*) AS total_rows
FROM transaction_data;
TRUNCATE TABLE transaction_data;
SELECT COUNT(*) AS total_rows
FROM transaction_data;
SELECT COUNT(*) AS total_rows
FROM transaction_data;
SELECT Transaction_ID, COUNT(*) AS cnt FROM transaction_data GROUP BY Transaction_ID HAVING COUNT(*) > 1;
SELECT * FROM customer_data WHERE Age < 0 OR Age > 120;  #Invalid Ages
SELECT * FROM transaction_data
WHERE Transaction_Amount < 0; #Negative Transaction Amounts
SELECT * FROM transaction_data
WHERE Total_Balance < 0; #Negative Balances
SELECT c.Customer_ID, c.Branch_ID FROM customer_data c LEFT JOIN bank_data b
    ON c.Branch_ID = b.Branch_ID
WHERE b.Branch_ID IS NULL; #Branch Relationship
SELECT t.Transaction_ID, t.Customer_ID FROM transaction_data t LEFT JOIN customer_data c
    ON t.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL; #Customer Relationship
SELECT COUNT(*) AS total_customers FROM customer_data; #Total Customers
SELECT ROUND(AVG(Age),2) AS average_age FROM customer_data; #Average Customer Age
SELECT Region, COUNT(*) AS total_customers FROM customer_data GROUP BY Region ORDER BY total_customers DESC; #Customers by Region
SELECT Customer_Type, COUNT(*) AS total_customers FROM customer_data GROUP BY Customer_Type ORDER BY total_customers DESC; #Customers by Customer Type
SELECT
    Age_Group,
    COUNT(*) AS total_customers
FROM (
    SELECT
        CASE
            WHEN Age IS NULL THEN 'Missing'
            WHEN Age < 25 THEN '18-24'
            WHEN Age < 35 THEN '25-34'
            WHEN Age < 45 THEN '35-44'
            WHEN Age < 55 THEN '45-54'
            ELSE '55+'
        END AS Age_Group
    FROM customer_data
) AS age_data
GROUP BY Age_Group
ORDER BY
    CASE Age_Group
        WHEN '18-24' THEN 1
        WHEN '25-34' THEN 2
        WHEN '35-44' THEN 3
        WHEN '45-54' THEN 4
        WHEN '55+' THEN 5
        WHEN 'Missing' THEN 6
    END; # Age Group Analysis - MySQL got confused because we grouped by Age_Group, but Age was used inside CASE
SELECT ROUND(SUM(Transaction_Amount),2) AS total_transaction_amount FROM transaction_data; #Total Transaction Amount
SELECT ROUND(AVG(Transaction_Amount),2) AS average_transaction_amount FROM transaction_data; #Average Transaction Amount
SELECT ROUND(SUM(Total_Balance),2) AS total_balance FROM transaction_data; # Total Balance
SELECT Account_Type, ROUND(SUM(Transaction_Amount),2) AS total_transaction_amount FROM transaction_data GROUP BY Account_Type ORDER BY total_transaction_amount DESC;  # Transaction by Account Type
SELECT c.Customer_Type, ROUND(SUM(t.Transaction_Amount),2) AS total_transaction_amount FROM transaction_data t JOIN customer_data c ON t.Customer_ID = c.Customer_ID GROUP BY c.Customer_Type ORDER BY total_transaction_amount DESC; # Transaction by Customer Type - using join
SELECT ROUND(SUM(Investment_Amount),2) AS total_investment FROM transaction_data; # Total Investment
SELECT Investment_Type, ROUND(SUM(Investment_Amount),2) AS total_investment FROM transaction_data GROUP BY Investment_Type ORDER BY total_investment DESC;  # Investment by Type
SELECT c.Region, ROUND(SUM(t.Investment_Amount),2) AS total_investment FROM transaction_data t JOIN customer_data c ON t.Customer_ID = c.Customer_ID GROUP BY c.Region ORDER BY total_investment DESC; # Investment by Region
SELECT Region, ROUND(SUM(Firm_Revenue),2) AS total_revenue FROM bank_data GROUP BY Region ORDER BY total_revenue DESC;  # Revenue by Region
SELECT Region, ROUND(SUM(Expenses),2) AS total_expenses FROM bank_data GROUP BY Region ORDER BY total_expenses DESC;  # Expenses by Region
SELECT Region, ROUND(SUM(Firm_Revenue - Expenses),2) AS total_profit FROM bank_data GROUP BY Region ORDER BY total_profit DESC;  # Profit by Region - Revenue − Expenses                         
SELECT Region, ROUND(AVG(Profit_Margin) * 100,2) AS average_profit_margin FROM bank_data GROUP BY Region ORDER BY average_profit_margin DESC;  #Profit Margin
SELECT Region, ROUND(SUM(Firm_Revenue),2) AS total_revenue, ROUND(SUM(Expenses),2) AS total_expenses, ROUND(SUM(Firm_Revenue - Expenses),2) AS total_profit FROM bank_data GROUP BY Region ORDER BY total_revenue DESC; # Revenue vs Expenses
SELECT * FROM transaction_data t JOIN customer_data c ON t.Customer_ID = c.Customer_ID; # JOIN
SELECT Customer_ID, Age, CASE WHEN Age < 25 THEN '18-24' WHEN Age < 35 THEN '25-34' WHEN Age < 45 THEN '35-44' WHEN Age < 55 THEN '45-54' ELSE '55+' END AS Age_Group FROM customer_data; # CASE
SELECT Branch_ID, Firm_Revenue FROM bank_data WHERE Firm_Revenue > (SELECT AVG(Firm_Revenue) FROM bank_data); # Subquery
WITH branch_profit AS
 ( SELECT Branch_ID, Firm_Revenue, Expenses, Firm_Revenue - Expenses AS Profit FROM bank_data )
 SELECT * FROM branch_profit ORDER BY Profit DESC; #CTE = Common Table Expression.
WITH branch_profit AS (
    SELECT
        Branch_ID,
        Firm_Revenue,
        Expenses,
        Firm_Revenue - Expenses AS Profit
    FROM bank_data
)
SELECT
    Branch_ID,
    Profit,
    RANK() OVER (ORDER BY Profit DESC) AS Profit_Rank
FROM branch_profit
ORDER BY Profit_Rank; # RANK() - Top 10 branches by profit

WITH branch_profit AS (
    SELECT
        Branch_ID,
        Firm_Revenue - Expenses AS Profit
    FROM bank_data
),
ranked_branches AS (
    SELECT
        Branch_ID,
        Profit,
        RANK() OVER (ORDER BY Profit DESC) AS Profit_Rank
    FROM branch_profit
)
SELECT *
FROM ranked_branches
WHERE Profit_Rank <= 10
ORDER BY Profit_Rank; #Rank () - Top 10 only

SELECT
    Branch_ID,
    Firm_Revenue,
    ROW_NUMBER() OVER (
        ORDER BY Firm_Revenue DESC
    ) AS Revenue_Rank
FROM bank_data;  # ROW_NUMBER()
SELECT
    Region,
    Firm_Revenue,
    SUM(Firm_Revenue) OVER () AS Overall_Revenue
FROM bank_data; # SUM() OVER()

SELECT
    Region,
    SUM(Firm_Revenue) AS Region_Revenue,
    SUM(SUM(Firm_Revenue)) OVER () AS Overall_Revenue
FROM bank_data
GROUP BY Region; #Regional Revenue + Overall Revenue
SELECT
    Branch_ID,
    Region,
    Firm_Revenue,
    AVG(Firm_Revenue) OVER (
        PARTITION BY Region
    ) AS Regional_Average_Revenue
FROM bank_data; # AVG() OVER()