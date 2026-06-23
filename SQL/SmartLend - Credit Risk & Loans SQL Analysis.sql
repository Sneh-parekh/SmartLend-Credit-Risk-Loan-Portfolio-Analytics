-- ========================================================
-- SmartLend - Credit Risk & Loan Portfolio Analytics
-- Devloped By: Sneh Parekh
-- ========================================================

-- ========================================================
-- SECTION 1 : DATABASE CREATION
-- ========================================================

CREATE DATABASE SmartLend;
USE SmartLend;

-- ========================================================
-- SECTION 2 : TABLE CREATION
-- ========================================================

-- ---------------------------------------------------------
-- TABLE: CUSTOMERS
-- Stores customer information
-- ---------------------------------------------------------

CREATE TABLE customers(
	   customer_id VARCHAR(20) PRIMARY KEY,
       gender VARCHAR(10),
       age INT,
       marital_status VARCHAR(50),
       education VARCHAR(50),
       occupation VARCHAR(50),
       annual_income DECIMAL(12,2),
       city VARCHAR(50),
       state VARCHAR(50),
       join_date DATE
);

-- ---------------------------------------------------------
-- TABLE: CREDIT RISK
-- ---------------------------------------------------------

CREATE TABLE credit_risk(
       customer_id VARCHAR(20) PRIMARY KEY,
       credit_score INT,
       debt_to_income_ratio DECIMAL(4,2),
       late_payments INT,
       loan_default TINYINT,
       risk_category VARCHAR(50),
       
       FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- ---------------------------------------------------------
-- TABLE: LOANS
-- ---------------------------------------------------------

CREATE TABLE loans(
	   loan_id VARCHAR(20) PRIMARY KEY,
       customer_id VARCHAR(20),
       loan_amount DECIMAL(15,2),
       loan_term_months INT,
       interest_rate DECIMAL(5,2),
       loan_type VARCHAR(50),
       loan_status VARCHAR(50),
       loan_issue_date DATE,
       loan_end_date DATE,
       
       FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- ========================================================
-- SECTION 3 : VERIFY TABLES AND  DATA VALIDATION
-- Check imported data
-- ========================================================

SHOW TABLES;

SELECT * FROM customers;

SELECT * FROM credit_risk;

SELECT * FROM loans;

-- ---------------------------------------------------------
-- Count total rows 
-- ---------------------------------------------------------

SELECT COUNT(*) AS total_customers 
FROM customers;

SELECT COUNT(*) FROM credit_risk;

SELECT COUNT(*) FROM loans;

-- ---------------------------------------------------------
-- Check NULL Values
-- ---------------------------------------------------------

SELECT * FROM customers
WHERE customer_id IS NULL;

SELECT COUNT(*) AS total_rows, 

SUM(customer_id IS NULL) AS null_customer_id,
SUM(gender IS NULL) AS null_gender,
SUM(age IS NULL) AS null_age,
SUM(marital_status IS NULL) AS null_marital_status,
SUM(education IS NULL) AS null_education,
SUM(occupation IS NULL) AS null_occupation,
SUM(annual_income IS NULL) AS null_annual_income,
SUM(city IS NULL) AS null_city,
SUM(state IS NULL) AS null_state,
SUM(join_date IS NULL) AS null_join_date

FROM customers;

SELECT COUNT(*) AS total_rows,

SUM(customer_id IS NULL) AS null_customer_id,
SUM(credit_score IS NULL) AS null_credit_score,
SUM(debt_to_income_ratio IS NULL) AS null_debt_to_income_ratio,
SUM(late_payments IS NULL) AS null_late_payments,
SUM(loan_default IS NULL) AS null_loan_default,
SUM(risk_category IS NULL) AS null_risk_category

FROM credit_risk;

SELECT COUNT(*) AS total_rows,

SUM(loan_id IS NULL) AS null_loan_id,
SUM(customer_id IS NULL) AS null_customer_id,
SUM(loan_amount IS NULL) AS null_loan_amount,
SUM(loan_term_months IS NULL) AS null_loan_term_months,
SUM(interest_rate IS NULL) AS null_interest_rate,
SUM(loan_type IS NULL) AS null_loan_type,
SUM(loan_status IS NULL) AS null_loan_status,
SUM(loan_issue_date IS NULL) AS null_loan_issue_date,
SUM(loan_end_date IS NULL) AS null_loan_end_date

FROM loans;

-- ---------------------------------------------------------
-- Check DUPLICATE RECORDS 
-- ---------------------------------------------------------

SELECT customer_id,
       COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT customer_id,
       COUNT(*)
FROM credit_risk
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT loan_id,
       COUNT(*)
FROM loans
GROUP BY loan_id
HAVING COUNT(*) > 1;


-- ---------------------------------------------------------
-- Age Validation
-- ---------------------------------------------------------
SELECT * FROM customers
WHERE age < 18;

-- ---------------------------------------------------------
-- Income Validation
-- ---------------------------------------------------------
SELECT * FROM customers
WHERE annual_income < 0;

-- ---------------------------------------------------------
-- Credit Score Validation (Range:: 300-850)
-- ---------------------------------------------------------
SELECT * FROM credit_risk
WHERE credit_score < 300
OR credit_score > 850;

-- ---------------------------------------------------------
-- Loan Amount Validation
-- ---------------------------------------------------------
SELECT * FROM loans
WHERE loan_amount <= 0;

-- ---------------------------------------------------------
-- Interest Rate Validation
-- ---------------------------------------------------------
SELECT * FROM loans
WHERE interest_rate <= 0;

-- ---------------------------------------------------------
-- Date Validation (Loan ending before starting?)
-- ---------------------------------------------------------
SELECT * FROM loans
WHERE loan_end_date < loan_issue_date;

-- ---------------------------------------------------------
-- Category Standardization (Look for inconsistent values.)
-- ---------------------------------------------------------
SELECT DISTINCT gender
FROM customers;

SELECT DISTINCT marital_status
FROM customers;

SELECT DISTINCT loan_type
FROM loans;

SELECT DISTINCT loan_status
FROM loans;

-- =========================================================
-- SECTION 4: SQL EXPLORATORY DATA ANALYSIS
-- =========================================================

-- ---------------------------------------------------------
-- Total Customers 
-- ---------------------------------------------------------
SELECT COUNT(*) AS total_customers
FROM customers;

-- ------------------------------------------------------------------
-- Gender Distribution (Do we have more male or female borrowers?)
-- ------------------------------------------------------------------
SELECT gender,
       COUNT(*) AS customers
FROM customers
GROUP BY gender;

-- ---------------------------------------------------------
-- Age Statistics (What's our typical customer age?) 
-- ---------------------------------------------------------
SELECT MIN(age), MAX(age), AVG(age)
FROM customers;

-- ---------------------------------------------------------
-- Income Statistics 
-- ---------------------------------------------------------
SELECT MIN(annual_income), MAX(annual_income), AVG(annual_income)
FROM customers;

-- ---------------------------------------------------------
-- Average Credit Score
-- ---------------------------------------------------------
SELECT AVG(credit_score)
FROM credit_risk;

-- ---------------------------------------------------------
-- Default Rate
-- ---------------------------------------------------------
SELECT
ROUND( 
SUM(loan_default) * 100.0 / COUNT(*),
2
) AS default_rate
FROM credit_risk;

-- ------------------------------------------------------------------------
-- Risk Category Distribution (How many High-Risk customers do we have?)
-- ------------------------------------------------------------------------
SELECT risk_category,
       COUNT(*)
FROM credit_risk
GROUP BY risk_category;

-- ---------------------------------------------------------
-- Total Loan Amount
-- ---------------------------------------------------------
SELECT SUM(loan_amount) FROM loans;

-- ---------------------------------------------------------
-- Average Loan Amount
-- ---------------------------------------------------------
SELECT AVG(loan_amount) FROM loans;

-- ---------------------------------------------------------------------------
-- Loan Status Distribution (How many loans are Active, Closed, Defaulted?)
-- ---------------------------------------------------------------------------
SELECT loan_status,
       COUNT(*)
FROM loans
GROUP BY loan_status;

-- -----------------------------------------------------------------
-- Loan Type Distribution (Which loan products are most popular?)
-- -----------------------------------------------------------------
SELECT loan_type,
	   COUNT(*)
FROM loans
GROUP BY loan_type;

-- =========================================================
-- SECTION 5: Business Analysis Queries
-- =========================================================

-- ---------------------------------------------------------
-- Q1. Who are our borrowers? 
-- ---------------------------------------------------------
-- ---------------- --
--  By Gender
-- ---------------- --
SELECT gender,
       COUNT(*) AS total_customers
FROM customers
GROUP BY gender;

-- ---------------- --
--  By Education
-- ---------------- --
SELECT education,
       COUNT(*) AS total_customers
FROM customers
GROUP BY education
ORDER BY total_customers DESC;

-- ---------------- --
--  By Occupation
-- ---------------- --
SELECT occupation,
       COUNT(*) AS total_customers
FROM customers
GROUP BY occupation
ORDER BY total_customers DESC;

-- ---------------------------------------------------------
-- Q2. Which age groups take the most loans?
-- ---------------------------------------------------------
SELECT
CASE
    WHEN c.age BETWEEN 18 AND 25 THEN '18-25'
    WHEN c.age BETWEEN 26 AND 35 THEN '26-35'
    WHEN c.age BETWEEN 36 AND 45 THEN '36-45'
    WHEN c.age BETWEEN 46 AND 55 THEN '46-55'
    ELSE '56+'
END AS age_group,
COUNT(l.loan_id) AS total_loans
FROM customers c
JOIN loans l
ON c.customer_id = l.customer_id
GROUP BY age_group
ORDER BY total_loans DESC;

-- ---------------------------------------------------------------
-- Q3. Which income segments generate the highest loan volume?
-- ---------------------------------------------------------------
SELECT
CASE
    WHEN annual_income < 500000 THEN 'Low Income'
    WHEN annual_income < 1000000 THEN 'Middle Income'
    ELSE 'High Income'
END AS income_segment,
ROUND(SUM(l.loan_amount),2) AS loan_volume
FROM customers c
JOIN loans l
ON c.customer_id = l.customer_id
GROUP BY income_segment
ORDER BY loan_volume DESC;

-- ---------------------------------------------------------
-- Q4. Do certain occupations show higher risk?
-- ---------------------------------------------------------
SELECT
c.occupation,
ROUND(
SUM(cr.loan_default)*100.0/COUNT(*),
2
) AS default_rate
FROM customers c
JOIN credit_risk cr
ON c.customer_id = cr.customer_id
GROUP BY c.occupation
ORDER BY default_rate DESC;

-- ---------------------------------------------------------
-- Q5. What is the overall default rate?
-- ---------------------------------------------------------
SELECT
ROUND(
SUM(loan_default)*100.0/COUNT(*),
2
) AS default_rate
FROM credit_risk;

-- ---------------------------------------------------------
-- Q6. How does default rate vary by credit score?
-- ---------------------------------------------------------
SELECT
CASE
    WHEN credit_score < 600 THEN 'Poor'
    WHEN credit_score < 700 THEN 'Fair'
    WHEN credit_score < 750 THEN 'Good'
    ELSE 'Excellent'
END AS credit_band,

ROUND(
SUM(loan_default)*100.0/COUNT(*),
2
) AS default_rate

FROM credit_risk
GROUP BY credit_band
ORDER BY default_rate DESC;

-- --------------------------------------------------------------
-- Q7. How does debt-to-income ratio impact default behavior?
-- --------------------------------------------------------------
SELECT
CASE
    WHEN debt_to_income_ratio < 0.20 THEN 'Low DTI'
    WHEN debt_to_income_ratio < 0.40 THEN 'Medium DTI'
    ELSE 'High DTI'
END AS dti_group,

ROUND(
SUM(loan_default)*100.0/COUNT(*),
2
) AS default_rate

FROM credit_risk
GROUP BY dti_group
ORDER BY default_rate DESC;

-- ---------------------------------------------------------
-- Q8. Which customers belong to the High-Risk category?
-- ---------------------------------------------------------
SELECT
customer_id,
credit_score,
debt_to_income_ratio,
late_payments
FROM credit_risk
WHERE risk_category = 'High Risk';

-- -------------------------------------------------------------
-- Q9. Which loan products generate the highest loan volume?
-- -------------------------------------------------------------
SELECT
loan_type,
ROUND(SUM(loan_amount),2) AS total_loan_volume
FROM loans
GROUP BY loan_type
ORDER BY total_loan_volume DESC;

-- --------------------------------------------------------------
-- Q10. Which loan types experience the highest default rates?
-- --------------------------------------------------------------
SELECT
l.loan_type,

ROUND(
SUM(cr.loan_default)*100.0/
COUNT(*),
2
) AS default_rate

FROM loans l
JOIN credit_risk cr
ON l.customer_id = cr.customer_id

GROUP BY l.loan_type
ORDER BY default_rate DESC;

-- -------------------------------------------------------------------------
-- Q11. What is the distribution of Active, Closed, and Defaulted loans?
-- -------------------------------------------------------------------------
SELECT
loan_status,
COUNT(*) AS total_loans
FROM loans
GROUP BY loan_status;

-- ---------------------------------------------------------
-- Q12. How has loan issuance changed over time?
-- ---------------------------------------------------------
SELECT
YEAR(loan_issue_date) AS year,
MONTH(loan_issue_date) AS month,
COUNT(*) AS loans_issued
FROM loans
GROUP BY year, month
ORDER BY year, month;

-- ---------------------------------------------------------
-- Q13. Which states have the highest loan amounts?
-- ---------------------------------------------------------
SELECT
c.state,
ROUND(SUM(l.loan_amount),2) AS total_loan_amount
FROM customers c
JOIN loans l
ON c.customer_id = l.customer_id
GROUP BY c.state
ORDER BY total_loan_amount DESC;

-- ---------------------------------------------------------
-- Q14. Which states have the highest default rates?
-- ---------------------------------------------------------
SELECT
c.state,

ROUND(
SUM(cr.loan_default)*100.0/
COUNT(*),
2
) AS default_rate

FROM customers c
JOIN credit_risk cr
ON c.customer_id = cr.customer_id
GROUP BY c.state
ORDER BY default_rate DESC;

-- ---------------------------------------------------------
-- Q15. Which cities contribute most to revenue and risk?
-- ---------------------------------------------------------
-- ---------------- --
--  Revenue
-- ---------------- --
SELECT
c.city,
ROUND(SUM(l.loan_amount),2) AS total_loan_amount
FROM customers c
JOIN loans l
ON c.customer_id = l.customer_id
GROUP BY c.city
ORDER BY total_loan_amount DESC;

-- ---------------- --
--  Risk
-- ---------------- --
SELECT
c.city,
SUM(cr.loan_default) AS total_defaults
FROM customers c
JOIN credit_risk cr
ON c.customer_id = cr.customer_id
GROUP BY c.city
ORDER BY total_defaults DESC;
