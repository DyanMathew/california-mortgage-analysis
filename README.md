# California Mortgage Lending Analysis 2023

## Overview
End-to-end analysis of 500,000+ California mortgage applications 
using CFPB HMDA 2023 data. Built to identify approval rate patterns, 
denial drivers, and fair lending signals across 58 counties.

## Live Dashboard
[View on Tableau Public](https://public.tableau.com/shared/NYMP2T47W)

## Key Findings
1. Debt-to-income ratio accounts for ~60% of all loan denials in 
   California — the single largest barrier to mortgage approval
2. Approval rates range from 60% to 85% across California counties, 
   suggesting significant geographic disparity in lending outcomes
3. A 15-point approval rate gap exists between highest and lowest 
   performing racial groups, flagged as a potential fair lending signal 
   requiring further investigation with income and DTI controls
4. Average loan amounts rise consistently from $200K at lower income 
   bands to $1.1M+ at higher bands, confirming strong income-loan 
   correlation in California's market
5. 63% of applications resulted in originated loans, with 16.9% 
   withdrawn and 9.5% denied outright

## Tools Used
- Python (pandas) — data cleaning and ETL pipeline
- SQLite + DB Browser — analytical query layer
- Tableau Public — interactive dashboard and visualization

## Data Source
Consumer Financial Protection Bureau (CFPB)
Home Mortgage Disclosure Act (HMDA) Loan Application Register 2023