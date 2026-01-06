/*
---------------------------------------------------------------------
Change Over Time Analysis
---------------------------------------------------------------------

Script Purpose:
	Track trends, growth and chages in key values over time.
	Understand performance of over time

Method:
	Use SUM, AVG or COUNT to aggregate the measures, group by a date
	and order by the same date

---------------------------------------------------------------------
*/


-- Analyse Sales performance over time

-- Using Basic Date Functions (Date Output in Integer)
SELECT
	YEAR(order_date) AS             order_year,
	MONTH(order_date) AS            order_month,
	SUM(sales) AS                   total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS                total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)
;

-- Using Advanced Date Functions (Date Output in Date)
SELECT
	DATETRUNC(MONTH, order_date) AS order_date,
	SUM(sales) AS                   total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS                total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date)
;

-- Using Format Functions (Date Output in String)
SELECT
	FORMAT(order_date, 'yyyy MMM') AS order_month,
	SUM(sales) AS                     total_sales,
	COUNT(DISTINCT customer_key) AS   total_customers,
	SUM(quantity) AS                  total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy MMM')
ORDER BY FORMAT(order_date, 'yyyy MMM')
;
