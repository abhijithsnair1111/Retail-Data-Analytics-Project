/*
---------------------------------------------------------------------
Dimensions Exploration
---------------------------------------------------------------------

Script Purpose:
	Explore the Dimensional values inside the tables. Understand the
	cardinality of such values for futurecategorization

Method:
	Use DISTINCT function to unique values

---------------------------------------------------------------------
*/



-- Retrieve a list of unique values from dimension columns in Customers table (eg: Country)
SELECT DISTINCT
	country
FROM gold.dim_customers
;

-- Retrieve a list of unique values from dimension columns in Products table
SELECT DISTINCT
	category,
	subcategory,
	maintenance
FROM gold.dim_products
ORDER BY
	category,
	subcategory,
	maintenance
;
