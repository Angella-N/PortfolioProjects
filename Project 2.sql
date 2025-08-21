
SELECT *
FROM INFORMATION_SCHEMA.TABLES

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'gold.dim_customers'

SELECT DISTINCT country From dbo.[gold.dim_customers]

SELECT DISTINCT category
FROM dbo.[gold.dim_products];

SELECT DISTINCT category, subcategory
FROM dbo.[gold.dim_products];

SELECT DISTINCT category,  subcategory, product_name
FROM dbo.[gold.dim_products];


SELECT order_date 
FROM dbo.[gold.fact_sales]

SELECT MIN(order_date) 
FROM dbo.[gold.fact_sales]

SELECT MAX(order_date) 
FROM dbo.[gold.fact_sales]

SELECT
MIN(order_date) AS first_order_date, 
MAX(order_date) AS las_order_date
FROM dbo.[gold.fact_sales]

SELECT
MIN(order_date) AS first_order_date, 
MAX(order_date) AS las_order_date,
DATEDIFF(year, MIN(order_date), MAX(order_date)) AS oder_range_years
FROM dbo.[gold.fact_sales]

SELECT
MIN(order_date) AS first_order_date, 
MAX(order_date) AS las_order_date,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS oder_range_years
FROM dbo.[gold.fact_sales]


SELECT
MIN(birthdate) AS oldest_birthdate, 
MAX(birthdate) AS youngest_birthdate
FROM dbo.[gold.dim_customers]

SELECT
MIN(birthdate) AS oldest_birthdate,
DATEDIFF(year,MIN(birthdate), GETDATE()) AS oldest_age,
MAX(birthdate) AS youngest_birthdate,
DATEDIFF(year,MAX(birthdate), GETDATE()) AS youngest_age
FROM dbo.[gold.dim_customers]

SELECT SUM(sales_amount) AS total_sales FROM dbo.[gold.fact_sales]

SELECT SUM(quantity) AS total_quantity FROM dbo.[gold.fact_sales]


SELECT AVG(price) AS avg_price FROM dbo.[gold.fact_sales]

SELECT COUNT(order_number) AS total_orders FROM dbo.[gold.fact_sales]
SELECT COUNT(DISTINCT order_number) AS total_orders FROM dbo.[gold.fact_sales]

SELECT COUNT(product_key) AS total_products FROM dbo.[gold.dim_products]


SELECT COUNT(customer_key) AS total_customers FROM dbo.[gold.dim_customers]

SELECT COUNT(DISTINCT customer_key) AS total_customers FROM dbo.[gold.fact_sales]

--REPORT

SELECT 'Total Sales' as measure_name, SUM(sales_amount) AS measure_value FROM dbo.[gold.fact_sales]
UNION ALL
SELECT 'Total Quantity' as measure_name, SUM(Quantity) AS measure_value FROM dbo.[gold.fact_sales]
UNION ALL 
SELECT 'Average Price', AVG(price) AS avg_price FROM dbo.[gold.fact_sales]
UNION ALL
SELECT 'Total No Orders', COUNT(DISTINCT order_number) AS total_orders FROM dbo.[gold.fact_sales]
UNION ALL
SELECT 'Total No Products', COUNT(product_key) AS total_products FROM dbo.[gold.dim_products]
UNION ALL
SELECT 'Total No Customers', COUNT(customer_key) AS total_customers FROM dbo.[gold.dim_customers]

--Total customers by country
SELECT country,
COUNT(customer_key) AS total_customers
FROM dbo.[gold.dim_customers]
GROUP by country
ORDER BY total_customers DESC

--Total Customers by gender
SELECT gender,
COUNT(customer_key) AS total_customers
FROM dbo.[gold.dim_customers]
GROUP by gender
ORDER BY total_customers DESC

--Total Products by category
SELECT category,
COUNT(product_key) AS total_products
FROM dbo.[gold.dim_products]
GROUP BY category 
ORDER BY total_products DESC

--Average cost in each category
SELECT category,
AVG(cost) AS avg_costs
FROM dbo.[gold.dim_products]
GROUP BY category 
ORDER BY avg_costs DESC

--Total revenue by category
SELECT
p.category,
	SUM(f.sales_amount) total_revenue
FROM [dbo].[gold.fact_sales] f
LEFT JOIN dbo.[gold.dim_products] p
ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

--Total revenue by each customer
SELECT c.customer_key, c.first_name, c.last_name,
SUM(f.sales_amount) total_revenue
FROM dbo.[gold.fact_sales] f
LEFT JOIN dbo.[gold.dim_customers] c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC

--Distribution of sold items by country
SELECT c.country,
SUM(f.quantity) total_sold_items
FROM dbo.[gold.fact_sales] f
LEFT JOIN dbo.[gold.dim_customers] c
ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC

--Products with highest revenue
SELECT TOP 5
p.product_name,
	SUM(f.sales_amount) total_revenue
FROM [dbo].[gold.fact_sales] f
LEFT JOIN dbo.[gold.dim_products] p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

--Worst performing products
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) total_revenue
FROM [dbo].[gold.fact_sales] f
LEFT JOIN dbo.[gold.dim_products] p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue 

--Rank
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) total_revenue,
ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_product
FROM [dbo].[gold.fact_sales] f
LEFT JOIN dbo.[gold.dim_products] p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;














