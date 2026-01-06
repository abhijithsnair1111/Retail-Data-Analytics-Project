/*
---------------------------------------------------------------------
Measures Exploration
---------------------------------------------------------------------

Script Purpose:
	Explore the Measure values inside the table. Understand the basic
	aggregations that can be performed on the measures

Method:
	Use SUM, AVG or COUNT to aggregate the values

---------------------------------------------------------------------
*/


-- Find the total sales
SELECT	SUM(sales) AS total_sales FROM gold.fact_sales;

-- Find the total number of items sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales;

-- Find the average selling price
SELECT AVG(price) AS average_price FROM gold.fact_sales;

-- Find the total number of orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales; -- Unique Products

-- Find the total number of produts
SELECT COUNT(product_name) AS total_products FROM gold.dim_products;

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Generate a report with all the key measures in the tables
SELECT 'Total Sales' AS measure_name, SUM(sales) AS measure_values FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS measure_name, SUM(quantity) AS meaasure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' AS measure_name, AVG(price) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Products' AS measure_name, COUNT(product_name) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total Customers' AS measure_name, COUNT(customer_key) AS measure_value FROM gold.dim_customers
;
