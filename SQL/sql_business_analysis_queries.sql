USE smartlend;

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
