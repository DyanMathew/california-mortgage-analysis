-- ============================================================
-- California Mortgage Lending Analysis 2023
-- Data Source: CFPB HMDA Loan Application Register
-- Tool: SQLite via DB Browser for SQLite
-- Author: Dyan Reji Mathew
-- ============================================================

-- DATA PREPARATION
-- CSV imported into SQLite using DB Browser for SQLite
-- Table name: hmda_clean
-- Source file: state_CA_clean.csv (cleaned via Python pandas)
-- Records: ~500,000 California mortgage applications (2023)

-- ============================================================
-- QUERY 1: Approval Rate by County
-- Purpose: Identify geographic disparities in loan approval
-- ============================================================
SELECT county_code,
       COUNT(*) AS total_apps,
       SUM(CASE WHEN action_taken = 1 THEN 1 ELSE 0 END) AS approved,
       ROUND(100.0 * SUM(CASE WHEN action_taken = 1 THEN 1 ELSE 0 END) / COUNT(*), 1) AS approval_rate_pct
FROM hmda_clean
GROUP BY county_code
ORDER BY total_apps DESC;

-- Result: 58 county rows
-- Key finding: Approval rates range from 60% to 85% across counties
-- Highest: County 6091 | Lowest: County 6007

-- ============================================================
-- QUERY 2: Denial Reasons Breakdown
-- Purpose: Identify primary barriers to mortgage approval
-- ============================================================
SELECT "denial_reason-1" AS denial_reason,
       COUNT(*) AS count
FROM hmda_clean
WHERE action_taken = 3
GROUP BY "denial_reason-1"
ORDER BY count DESC;

-- Result: 9 denial reason categories
-- Key finding: Debt-to-income ratio (code 1) accounts for ~60% 
-- of all denials — single largest barrier to approval

-- ============================================================
-- QUERY 3: Income Band vs Average Loan Amount
-- Purpose: Analyse relationship between borrower income 
-- and loan size across California market
-- ============================================================
SELECT ROUND(CAST(income AS FLOAT) * 1000 / 10000) * 10000 AS income_band,
       ROUND(AVG(CAST(loan_amount AS FLOAT)), 0) AS avg_loan_amount,
       COUNT(*) AS app_count
FROM hmda_clean
WHERE CAST(income AS FLOAT) BETWEEN 10 AND 500
AND CAST(loan_amount AS FLOAT) BETWEEN 50000 AND 2000000
GROUP BY income_band
HAVING COUNT(*) > 100
ORDER BY income_band;

-- Note: Income stored in thousands in HMDA data (e.g. 50 = $50,000)
-- Loan amount stored in full dollars
-- Result: Smooth upward curve from $200K to $1.1M+
-- Key finding: Strong positive correlation between income and 
-- loan amount confirming expected market behaviour

-- ============================================================
-- QUERY 4: Approval Rate by Race
-- Purpose: Fair lending analysis — detect potential 
-- racial disparities in mortgage approval outcomes
-- ============================================================
SELECT "applicant_race-1" AS race,
       COUNT(*) AS total,
       SUM(CASE WHEN action_taken = 1 THEN 1 ELSE 0 END) AS approved,
       ROUND(100.0 * SUM(CASE WHEN action_taken = 1 THEN 1 ELSE 0 END) / COUNT(*), 1) AS approval_rate_pct
FROM hmda_clean
GROUP BY "applicant_race-1"
ORDER BY approval_rate_pct DESC;

-- Race codes: 1=American Indian, 2=Asian, 3=Black/African American
-- 4=Native Hawaiian, 5=White, 6=Not Provided, 7=Not Applicable
-- Key finding: 15-point approval rate gap between highest (Asian) 
-- and lowest (Black/African American) groups
-- flagged as potential fair lending signal for further investigation

-- ============================================================
-- QUERY 5: Application Outcome Breakdown
-- Purpose: Understand overall distribution of loan 
-- application outcomes across California market
-- ============================================================
SELECT action_taken,
       COUNT(*) AS total,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM hmda_clean
GROUP BY action_taken
ORDER BY total DESC;

-- Action codes: 1=Originated, 2=Approved not accepted, 3=Denied
-- 4=Withdrawn, 5=File closed, 6=Purchased, 7=Pre-approval denied
-- Key finding: 63% of applications originated successfully
-- 16.9% withdrawn, 9.5% denied outright