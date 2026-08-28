--SQL Retail Sales Analysis - 01

--CREATE TABLE
CREATE TABLE retail_sales
			(
			     transactions_id INT PRIMARY KEY,
				 sale_date DATE,
				 sale_time TIME,
				 customer_id INT,	
				 gender	VARCHAR(20),
				 age INT,	
				 category VARCHAR(20),
				 quantiy INT,	
				 price_per_unit	FLOAT,
				 cogs_purchasing_costs FLOAT,	
				 total_sale FLOAT
			);


SELECT * FROM retail_sales;

SELECT COUNT (*) FROM retail_sales;

--SELECT * FROM retail_sales
--WHERE sale_date is NULL;

--SELECT * FROM retail_sales
--WHERE sale_time is NULL;

--SELECT * FROM retail_sales
--WHERE customer_id is NULL;

--SELECT * FROM retail_sales
--WHERE gender is NULL;

--SELECT * FROM retail_sales
--WHERE age is NULL;

--SELECT COUNT (*) FROM retail_sales
--WHERE age is NULL;

DELETE FROM retail_sales
WHERE 
	transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR
	customer_id is NULL
	OR
	gender is NULL
	OR
	age is NULL
	OR
	category is NULL
	OR
	quantiy is NULL
	OR
	price_per_unit is NULL
	OR
	cogs_purchasing_costs is NULL
	OR
	total_sale is NULL;


--DATA EXPLORATION

--SALES COUNT
SELECT COUNT (*) as total_sale FROM retail_sales;

--NUMBER OF UNIQUE CUSTOMERS
SELECT COUNT (DISTINCT customer_id) as total_customers FROM retail_sales;

--DISTINCT CATEGORY
SELECT DISTINCT category FROM retail_sales;



--DATA ANALYSIS & BUSINESS KEY QUESTIONS AND ANSWERS


-- 1. Retrieve all columns for sales made on '2022,11,05'

SELECT * FROM retail_sales
WHERE sale_date = '2022,11,05';

-- 2. Retrieve all transactions where the category is 'clothing' and the quantity sold is more tha in the month of Nov-2022 

SELECT 
	*
	--category,
	--SUM(quantiy)
FROM retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >= 3
	;


-- 3. Calculate the total sales (total_sale) for each category

SELECT 
	category,
	SUM(total_sale) as net_sales,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;


-- 4. Find the average age of customers who purchased items from the 'Beauty' category.

SELECT
	ROUND(AVG(age)) AS average_age
FROM retail_sales
WHERE category = 'Beauty';

 -- 5. Find all transactions where the total_sale is greater than 1000.

 SELECT *
 	--transactions_id,
	 --customer_id,
	 --category,
	 --total_sale
 FROM retail_sales
 WHERE total_sale >1000;


 -- 6. Find total number of transactions made by each gender in each category.

 SELECT 
	category,
	gender,
	COUNT(*) as total_tansactions
FROM retail_saleS
GROUP BY 
	category,
	gender
ORDER BY 1
	;


-- 7. Calculate the average sale for each month. Find out the best selling month in each year.

SELECT
	year,
	month,
	avg_sale
FROM 
(
SELECT
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as MONTH,
	AVG(total_sale) as avg_sale,
	RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1, 2
--ORDER BY 1, 3 DESC
) as t1
WHERE rank = 1
;


-- 8. Find the top 5 customers based on the highest total_sale.

SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
	;


-- 9. Find the number of unique customers who purchased items from each category. 

SELECT 
	category,
	COUNT(DISTINCT customer_id) as count_unique_customers
FROM retail_sales
GROUP BY category
	;

	
	
-- 10. Creat each shift and and number of orders (excample: Morning<12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
		END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

