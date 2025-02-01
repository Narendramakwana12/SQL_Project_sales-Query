CREATE DATABASE project_2;
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
transactions_id	INT PRIMARY KEY,
sale_date	DATE,
sale_time   TIME,
customer_id   INT,
gender   VARCHAR(15),
age	INT,
category  VARCHAR(15),
quantiy	INT,
price_per_unit	FLOAT,
cogs	FLOAT,
total_sale FLOAT
);
SELECT * FROM retail_sales
LIMIT 10

SELECT COUNT(*) FROM retail_sales;

-- DATA CLEANING
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
 OR
 sale_date IS NULL
 OR
 sale_time IS NULL
 OR
 customer_id IS NULL
 OR
gender IS NULL
OR
 age IS NULL
 OR
category IS NULL
OR
 quantiy IS NULL
 OR
 price_per_unit IS NULL
 OR
 cogs IS NULL
 OR
 
 total_sale IS NULL

 DELETE FROM retail_sales
WHERE transactions_id IS NULL
 OR
 sale_date IS NULL
 OR
 sale_time IS NULL
 OR
 customer_id IS NULL
 OR
gender IS NULL
OR
 age IS NULL
 OR
category IS NULL
OR
 quantiy IS NULL
 OR
 price_per_unit IS NULL
 OR
 cogs IS NULL
 OR
 total_sale IS NULL

-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE?
SELECT COUNT(*) as total_sales FROM retail_sales 

-- HOW MANY CUSTOMERS WE HAVE?
SELECT COUNT(DISTINCT customer_id) as total_sales FROM retail_sales

SELECT DISTINCT category FROM retail_sales

-- Data Analyses and Business key problems?
-- 1 write a SQL query to retrieve all columns for sales made on '2022-11-05'?
SELECT * FROM retail_sales
WHERE sale_date='2022-11-05'
-- 2 write a SQL query to retrieve all the transactions where the category is
--'clothing' and the quantity sold is more than 10 in Nov 2022?
SELECT * FROM retail_sales
WHERE category='Clothing'
AND TO_CHAR(sale_date,'yyyy-mm')='2022-11'
AND quantiy >=4
-- 3 write a SQL query to calculate the total sales for each quantity?
SELECT category, SUM(total_sale) as net_sales,
COUNT(*) as orders FROM retail_sales
GROUP BY 1;
-- 4 write a SQL query to find the average age of who purchase a 'Beauty Product'?
SELECT ROUND(AVG(age),2) as average_ages
 FROM retail_sales
 WHERE category='Beauty'
-- 5 write a SQL query to find all the transaction where total purchase is greater than 1000?
SELECT *
FROM retail_sales
WHERE total_sale>=1000
-- 6 write a SQL query to find the total number of tranctions made by each gender in each category?
SELECT category,gender,COUNT(*) as total_tran
FROM retail_sales
GROUP BY  category,gender
ORDER BY 1;
-- 7 write a SQL query to calculate average sales for each months . Find out best selling month in ecah year?
SELECT year,month,avg_sales
FROM (
SELECT 
EXTRACT(YEAR FROM sale_date)as year,
EXTRACT(MONTH FROM sale_date)as month,
AVG(total_sale) as avg_sales,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC ) as rank
FROM retail_sales
GROUP BY 1,2) as t_1
WHERE rank=1;
--ORDER BY 1,3 DESC
-- 8 write a SQL query to find the top 5 customer based on highest sales?
SELECT customer_id,SUM(total_sale) as total_sales
FROM  retail_sales
GROUP BY 1
ORDER BY total_sales DESC
LIMIT 5
-- 9 write a SQL query to find the numbers of unique customer who purchased items of each category?
SELECT category , COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY category
-- 10 write a SQL query to create each shift and number of orders?
WITH hourly_sales
AS(
SELECT *,
   CASE
   WHEN EXTRACT(HOUR FROM sale_time ) <12 THEN 'Morning'
   WHEN EXTRACT(HOUR FROM sale_time ) BETWEEN 12 AND 17 THEN 'Afternoon'
   ELSE  'Evening'
   END as shift
FROM retail_sales
)
SELECT shift, COUNT(*) 
FROM hourly_sales
GROUP BY shift
