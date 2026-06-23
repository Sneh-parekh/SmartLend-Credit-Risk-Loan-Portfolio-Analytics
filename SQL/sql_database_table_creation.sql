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
