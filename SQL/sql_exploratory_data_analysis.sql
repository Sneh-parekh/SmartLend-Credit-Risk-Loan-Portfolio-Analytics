USE smartlend;

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
