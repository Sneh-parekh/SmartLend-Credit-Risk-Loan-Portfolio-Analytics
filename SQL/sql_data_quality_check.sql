USE smartlend;

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