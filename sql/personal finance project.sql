SELECT COUNT(*) FROM pf;
describe pf;

#Data Quality Checks
#3.1 Check NULL values
SELECT
    SUM(Income IS NULL) AS null_income,
    SUM(Age IS NULL) AS null_age,
    SUM(Disposable_Income IS NULL) AS null_disposable_income
FROM pf;

#Check negative or invalid values

SELECT *
FROM pf
WHERE Income < 0
   OR Rent < 0
   OR Groceries < 0;


# KPI 1: Average Income

select round(avg(Income),2) as avg_income
from pf;

#KPI 2: Average Monthly Expenses

SELECT ROUND(
    AVG(
        Rent + Loan_Repayment + Insurance + Groceries + Transport +
        Eating_Out + Entertainment + Utilities + Healthcare +
        Education + Miscellaneous
    ),2
) AS avg_monthly_expense
FROM pf;

# KPI 3: Average Savings vs Desired Savings

SELECT
    ROUND(AVG(Disposable_Income),2) AS avg_actual_savings,
    ROUND(AVG(Desired_Savings),2) AS avg_desired_savings
FROM pf;


# KPI 4: Income Group Classification

SELECT
    Income,
    CASE
        WHEN Income < 30000 THEN 'Low Income'
        WHEN Income BETWEEN 30000 AND 70000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS income_group
FROM pf;

# KPI 5 Savings Performance Flag

SELECT
    Disposable_Income,
    Desired_Savings,
    CASE
        WHEN Disposable_Income >= Desired_Savings THEN 'Goal Met'
        ELSE 'Goal Not Met'
    END AS savings_status
FROM pf;

# KPI 6 Total Expenses using CTE

WITH expense_cte AS (
    SELECT
        *,
        (Rent + Loan_Repayment + Insurance + Groceries + Transport +
         Eating_Out + Entertainment + Utilities + Healthcare +
         Education + Miscellaneous) AS total_expenses
    FROM pf
)
SELECT
    ROUND(AVG(total_expenses),2) AS avg_total_expenses
FROM expense_cte;

#KPI 7 Savings Rate by City Tier

WITH savings_cte AS (
    SELECT
        City_Tier,
        Income,
        Disposable_Income,
        ROUND((Disposable_Income / Income) * 100,2) AS savings_rate
    FROM pf
)
SELECT
    City_Tier,
    ROUND(AVG(savings_rate),2) AS avg_savings_rate
FROM savings_cte
GROUP BY City_Tier;

# KPI 8 Occupation-Based Insights
select Occupation,round(avg(income),2) as avg_income,
round(avg(disposable_income),2) as avg_savings from pf 
group by Occupation
order by avg_income desc;

# KPI 9 Identify High Expense Categories

SELECT
    'Groceries' AS category, ROUND(AVG(Groceries),2) AS avg_spend FROM pf
UNION ALL
SELECT
    'Transport', ROUND(AVG(Transport),2) FROM pf
UNION ALL
SELECT
    'Entertainment', ROUND(AVG(Entertainment),2) FROM pf;
    
# KPI 10 Savings Opportunity Analysis

SELECT
    ROUND(AVG(
        Potential_Savings_Groceries +
        Potential_Savings_Transport +
        Potential_Savings_Eating_Out +
        Potential_Savings_Entertainment +
        Potential_Savings_Utilities +
        Potential_Savings_Healthcare +
        Potential_Savings_Education +
        Potential_Savings_Miscellaneous
    ),2) AS avg_potential_savings
FROM pf;

# KPI 11 Final Analysis VIEW
CREATE VIEW finance_summary AS
SELECT
    Age,
    Occupation,
    City_Tier,
    Income,
    Disposable_Income,
    Desired_Savings,
    (Rent + Loan_Repayment + Insurance + Groceries + Transport +
     Eating_Out + Entertainment + Utilities + Healthcare +
     Education + Miscellaneous) AS total_expenses,
    CASE
        WHEN Disposable_Income >= Desired_Savings THEN 'Goal Met'
        ELSE 'Goal Not Met'
    END AS savings_status
FROM pf;


