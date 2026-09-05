CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    Order_ID VARCHAR(20),
    Order_Date VARCHAR(20),
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Region VARCHAR(20),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(100),
    Quantity INT,
    Sales DECIMAL(10, 2),
    Discount DECIMAL(4, 2),
    Profit DECIMAL(10, 2)
);

Select * from sales;

USE ecommerce_db;

-- ========================================================
-- SECTION 1: SALES & REVENUE PERFORMANCE
-- ========================================================

-- Q1: Total Revenue and Total Profit
SELECT 
    ROUND(SUM(`Sales`), 2) AS `Total_Revenue`,
    ROUND(SUM(`Profit`), 2) AS `Total_Profit`
FROM `sales`;

-- Q2: Average Order Value (AOV)
SELECT 
    ROUND(AVG(`Sales`), 2) AS `Average_Order_Value`
FROM `sales`;

-- Q3: Monthly Sales & Profit Trend
SELECT 
    SUBSTRING(TRIM(`Order_Date`), 1, 7) AS `Year_Month`,
    ROUND(SUM(`Sales`), 2) AS `Monthly_Revenue`,
    ROUND(SUM(`Profit`), 2) AS `Monthly_Profit`,
    COUNT(DISTINCT `Order_ID`) AS `Total_Orders`
FROM `sales`
WHERE `Order_Date` IS NOT NULL AND TRIM(`Order_Date`) != ''
GROUP BY SUBSTRING(TRIM(`Order_Date`), 1, 7)
ORDER BY `Year_Month` ASC;

-- ========================================================
-- SECTION 2: PRODUCT & CATEGORY ANALYSIS
-- ========================================================

-- Q4: Top 5 Products by Revenue
SELECT 
    `Product_Name`,
    `Category`,
    ROUND(SUM(`Sales`), 2) AS `Total_Revenue`,
    SUM(`Quantity`) AS `Units_Sold`
FROM `sales`
GROUP BY `Product_Name`, `Category`
ORDER BY `Total_Revenue` DESC
LIMIT 5;

-- Q5: Category Margin Breakdown
SELECT 
    `Category`,
    ROUND(SUM(`Sales`), 2) AS `Category_Revenue`,
    ROUND(SUM(`Profit`), 2) AS `Category_Profit`,
    ROUND((SUM(`Profit`) / SUM(`Sales`)) * 100, 2) AS `Profit_Margin_PCT`
FROM `sales`
GROUP BY `Category`
ORDER BY `Category_Profit` DESC;

-- ========================================================
-- SECTION 3: CUSTOMER ANALYSIS
-- ========================================================

-- Q6: Top 10 Customers by Revenue
SELECT 
    `Customer_ID`,
    `Customer_Name`,
    COUNT(DISTINCT `Order_ID`) AS `Total_Orders`,
    ROUND(SUM(`Sales`), 2) AS `Total_Spent`,
    ROUND(SUM(`Profit`), 2) AS `Total_Profit_Generated`
FROM `sales`
WHERE `Customer_Name` != 'Unknown'
GROUP BY `Customer_ID`, `Customer_Name`
ORDER BY `Total_Spent` DESC
LIMIT 10;

-- Q7: Unprofitable Customers (Discount Exploitation Check)
SELECT 
    `Customer_ID`,
    `Customer_Name`,
    ROUND(SUM(`Sales`), 2) AS `Total_Revenue`,
    ROUND(SUM(`Profit`), 2) AS `Net_Profit`,
    ROUND(AVG(`Discount`), 2) AS `Average_Discount_Used`
FROM `sales`
GROUP BY `Customer_ID`, `Customer_Name`
HAVING `Net_Profit` < 0
ORDER BY `Total_Revenue` DESC;

-- ========================================================
-- SECTION 4: GEOGRAPHIC PERFORMANCE
-- ========================================================

-- Q8: City & State Revenue Breakdown
SELECT 
    `City`,
    `State`,
    COUNT(DISTINCT `Order_ID`) AS `Total_Orders`,
    ROUND(SUM(`Sales`), 2) AS `City_Revenue`,
    ROUND(SUM(`Profit`), 2) AS `City_Profit`,
    ROUND((SUM(`Profit`) / SUM(`Sales`)) * 100, 2) AS `Profit_Margin_PCT`
FROM `sales`
WHERE `City` != 'Unknown'
GROUP BY `City`, `State`
ORDER BY `City_Revenue` DESC;

-- ========================================================
-- SECTION 5: DISCOUNT VS PROFITABILITY TRADEOFF
-- ========================================================

-- Q9: Margin Impact across Discount Bands
SELECT 
    CASE 
        WHEN `Discount` = 0 THEN '0% (No Discount)'
        WHEN `Discount` > 0 AND `Discount` <= 0.10 THEN '1% - 10%'
        WHEN `Discount` > 0.10 AND `Discount` <= 0.20 THEN '11% - 20%'
        WHEN `Discount` > 0.20 AND `Discount` <= 0.35 THEN '21% - 35%'
        ELSE 'Above 35%'
    END AS `Discount_Band`,
    COUNT(DISTINCT `Order_ID`) AS `Total_Orders`,
    ROUND(SUM(`Sales`), 2) AS `Total_Sales`,
    ROUND(SUM(`Profit`), 2) AS `Total_Profit`,
    ROUND(AVG(`Profit`), 2) AS `Avg_Profit_Per_Order`,
    ROUND((SUM(`Profit`) / SUM(`Sales`)) * 100, 2) AS `Profit_Margin_PCT`
FROM `sales`
GROUP BY `Discount_Band`
ORDER BY `Total_Sales` DESC;

---- Q10: Which products generate the highest revenue vs. highest profit?
SELECT 
    `Product_Name`,
    `Category`,
    ROUND(SUM(`Sales`), 2) AS `Total_Revenue`,
    ROUND(SUM(`Profit`), 2) AS `Total_Profit`,
    RANK() OVER (ORDER BY SUM(`Sales`) DESC) AS `Revenue_Rank`,
    RANK() OVER (ORDER BY SUM(`Profit`) DESC) AS `Profit_Rank`
FROM `sales`
GROUP BY `Product_Name`, `Category`
LIMIT 10;

---- Q11: Which products have high sales volume but low or negative profit? (High Sales, Low Margin Warning)
SELECT 
    `Product_Name`,
    `Category`,
    SUM(`Quantity`) AS `Total_Quantity_Sold`,
    ROUND(SUM(`Sales`), 2) AS `Total_Revenue`,
    ROUND(SUM(`Profit`), 2) AS `Total_Profit`,
    ROUND((SUM(`Profit`) / SUM(`Sales`)) * 100, 2) AS `Profit_Margin_PCT`
FROM `sales`
GROUP BY `Product_Name`, `Category`
HAVING `Total_Revenue` > 5000 AND `Profit_Margin_PCT` < 5
ORDER BY `Total_Revenue` DESC;

---- Q12: Which sub-categories perform best in each category?
SELECT 
    `Category`,
    `Sub_Category`,
    ROUND(SUM(`Sales`), 2) AS `SubCategory_Revenue`,
    ROUND(SUM(`Profit`), 2) AS `SubCategory_Profit`
FROM `sales`
GROUP BY `Category`, `Sub_Category`
ORDER BY `Category` ASC, `SubCategory_Revenue` DESC;


---- Q13: Which products are consistently underperforming across all orders?
SELECT 
    `Product_Name`,
    `Category`,
    COUNT(DISTINCT `Order_ID`) AS `Total_Orders`,
    ROUND(SUM(`Sales`), 2) AS `Total_Revenue`,
    ROUND(SUM(`Profit`), 2) AS `Total_Profit`
FROM `sales`
GROUP BY `Product_Name`, `Category`
HAVING `Total_Profit` < 0
ORDER BY `Total_Profit` ASC;


--- Q14: How many total unique customers do we have, and what is the purchase frequency per customer?
SELECT 
    COUNT(DISTINCT `Customer_ID`) AS `Total_Unique_Customers`,
    ROUND(COUNT(DISTINCT `Order_ID`) / COUNT(DISTINCT `Customer_ID`), 2) AS `Avg_Orders_Per_Customer`
FROM `sales`
WHERE `Customer_Name` != 'Unknown';


--- Q15: Who are our repeat/returning customers vs. single-order customers?
WITH Customer_Orders AS (
    SELECT 
        `Customer_ID`,
        COUNT(DISTINCT `Order_ID`) AS `Order_Count`
    FROM `sales`
    WHERE `Customer_Name` != 'Unknown'
    GROUP BY `Customer_ID`
)
SELECT 
    CASE 
        WHEN `Order_Count` = 1 THEN 'Single Purchase Customer'
        ELSE 'Repeat Customer (2+ Orders)'
    END AS `Customer_Segment`,
    COUNT(`Customer_ID`) AS `Customer_Count`,
    ROUND(COUNT(`Customer_ID`) * 100.0 / (SELECT COUNT(*) FROM Customer_Orders), 2) AS `Percentage`
FROM Customer_Orders
GROUP BY `Customer_Segment`;


--- Q16: Identify churn/at-risk customers (customers whose last purchase was over 180 days before the latest dataset date).

SELECT 
    `Customer_ID`,
    `Customer_Name`,
    MAX(`Order_Date`) AS `Last_Purchase_Date`,
    DATEDIFF((SELECT MAX(`Order_Date`) FROM `sales`), MAX(`Order_Date`)) AS `Days_Since_Last_Purchase`,
    ROUND(SUM(`Sales`), 2) AS `Historical_Spend`
FROM `sales`
WHERE `Customer_Name` != 'Unknown'
GROUP BY `Customer_ID`, `Customer_Name`
HAVING `Days_Since_Last_Purchase` > 180
ORDER BY `Historical_Spend` DESC
LIMIT 15;


--- Q17: RFM Customer Segmentation (Grouping Customers into High Value, Mid Value, and Low Value)

SELECT 
    `Customer_ID`,
    `Customer_Name`,
    ROUND(SUM(`Sales`), 2) AS `Total_Spend`,
    COUNT(DISTINCT `Order_ID`) AS `Order_Frequency`,
    CASE 
        WHEN SUM(`Sales`) >= 10000 THEN 'Tier 1: High Value (VIP)'
        WHEN SUM(`Sales`) BETWEEN 4000 AND 9999 THEN 'Tier 2: Mid Value'
        ELSE 'Tier 3: Low Value'
    END AS `Customer_Tier`
FROM `sales`
WHERE `Customer_Name` != 'Unknown'
GROUP BY `Customer_ID`, `Customer_Name`
ORDER BY `Total_Spend` DESC;

-- Q18: Which Regions have the highest average profit margin percentage?

SELECT 
    `Region`,
    COUNT(DISTINCT `Order_ID`) AS `Total_Orders`,
    ROUND(SUM(`Sales`), 2) AS `Region_Revenue`,
    ROUND(SUM(`Profit`), 2) AS `Region_Profit`,
    ROUND((SUM(`Profit`) / SUM(`Sales`)) * 100, 2) AS `Profit_Margin_PCT`
FROM `sales`
WHERE `Region` != 'Unknown'
GROUP BY `Region`
ORDER BY `Profit_Margin_PCT` DESC;

--- Q19: Which cities are generating high sales volume but losing money overall?

SELECT 
    `City`,
    `State`,
    `Region`,
    ROUND(SUM(`Sales`), 2) AS `Total_Sales`,
    ROUND(SUM(`Profit`), 2) AS `Net_Loss`
FROM `sales`
WHERE `City` != 'Unknown'
GROUP BY `City`, `State`, `Region`
HAVING `Net_Loss` < 0
ORDER BY `Net_Loss` ASC;

--- Q20: What is the optimal discount percentage that maximizes profit without eroding margins?

SELECT 
    `Discount`,
    COUNT(DISTINCT `Order_ID`) AS `Total_Orders`,
    ROUND(SUM(`Sales`), 2) AS `Total_Sales`,
    ROUND(SUM(`Profit`), 2) AS `Total_Profit`,
    ROUND(AVG(`Profit`), 2) AS `Avg_Profit_Per_Order`
FROM `sales`
GROUP BY `Discount`
ORDER BY `Discount` ASC;