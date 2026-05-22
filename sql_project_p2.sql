CREATE DATABASE sql_project_p2;
USE sql_project_p2;

DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales
(
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

SELECT * 
FROM retail_sales
LIMIT 10;

SELECT * 
FROM retail_sales
WHERE transaction_id IS NULL;

SELECT * 
FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
    
    SET SQL_SAFE_UPDATES = 0;
    
    DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
    
    SELECT COUNT(*) AS total_sales
FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;


SELECT DISTINCT category
FROM retail_sales;

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
    AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND quantity >= 4;
    
    SELECT
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

SELECT
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

SELECT
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

SELECT
    year,
    month,
    avg_sale
FROM
(
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS ranking
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE ranking = 1;

SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift_type
    FROM retail_sales
)

SELECT
    shift_type,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift_type;
