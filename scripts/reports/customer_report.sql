/*
---------------------------------------------------------------------
Customer Report
---------------------------------------------------------------------

Script Purpose:
	Create a report for the customers by summerizing all the key
	metrics from Sales table and Customers table into one table

Highlights
	- Includes all the key customer values like
		1. Customer Key
		2. Customer Number
		3. Customer Name
		4. Customer Age

	- Segments customers based on
		1. Age Groups
		2. Segment (VIP, Regular, New)

	- Aggregated customer detials
		1. Total Orders
		2. Toatal Sales
		3. Total Quantity
		4. Total Products

	-- Calculated KPIs
		1. Recency (Months sice last purchase)
		2. Average Order Value
		3. Average Monthly Spend

---------------------------------------------------------------------
*/


---------------------------------------------------------------------
-- Create Report: gold.customer_report as a View
---------------------------------------------------------------------
IF OBJECT_ID('gold.customer_report', 'V') IS NOT NULL
	DROP VIEW gold.customer_report
;
GO

CREATE VIEW gold.customer_report AS

WITH base_query AS
---------------------------------------------------------------------
-- Base Query: Extract all the core columns for analysis
---------------------------------------------------------------------
(
	SELECT
		s.order_number,
		s.product_key,
		s.order_date,
		s.sales,
		s.quantity,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
		DATEDIFF(YEAR, c.birthdate, GETDATE()) AS customer_age
	FROM
		gold.fact_sales s
	LEFT JOIN
		gold.dim_customers c
	ON s.customer_key = c.customer_key
	WHERE order_date IS NOT NULL
)

,customer_aggregations AS
---------------------------------------------------------------------
-- Aggregate Query: Aggregate core columns for analysis
---------------------------------------------------------------------
(
	SELECT
		customer_key,
		customer_number,
		customer_name,
		customer_age,
		COUNT(DISTINCT order_number) AS                      total_orders,
		SUM(sales) AS                                        total_sales,
		SUM(quantity) AS                                     total_quantity,
		COUNT(DISTINCT product_key) AS                       total_products,
		MAX(order_date) AS                                   last_order,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
	FROM base_query
	GROUP BY
		customer_key,
		customer_number,
		customer_name,
		customer_age
)

---------------------------------------------------------------------
-- Main Query: Create Report based on Base and Aggregate Queries
---------------------------------------------------------------------
SELECT
	customer_key,
	customer_number,
	customer_name,
	customer_age,
	CASE
		-- Customer Segmentation based on Age
		WHEN customer_age < 18 THEN 'Under 18'
		WHEN customer_age BETWEEN 18 AND 39 THEN '18-39'
		WHEN customer_age BETWEEN 40 AND 59 THEN '40-59'
		ELSE '60 and Above'
	END AS customer_age_group,
	CASE
		-- Customer Segmentation based on Spending
		WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	lifespan,
	last_order,
	DATEDIFF(MONTH, last_order, GETDATE()) AS recency_in_months, -- Months since last order
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	-- Average Order Value
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_value,
	-- Monthly Spend
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS monthly_spend
FROM customer_aggregations
;
