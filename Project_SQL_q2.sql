-- Question 2
-- How many liters of milk and kilograms of bread can be purchased for the first and last comparable periods in the available price and wage data?

WITH purchasing_power as(
	SELECT avg(cpay.value) AS avg_payroll,
		round(avg(cp.value)::numeric, 2) AS avg_price,
		cpc.name AS product_name,
		round(avg(cpay.value)::numeric / avg(cp.value)::numeric) AS product_per_payroll,
		cpay.payroll_year AS year
	FROM czechia_payroll AS cpay 
	LEFT JOIN czechia_price AS cp 
		ON cpay.payroll_year = date_part('year', cp.date_from)
	LEFT JOIN czechia_price_category AS cpc 
		ON cp.category_code = cpc.code
	WHERE cpay.value_type_code = '5958'
		AND cpay.calculation_code = 200
		AND cpay.industry_branch_code IS NULL 
		AND cpay.payroll_year IN (2006, 2018)
		AND cp.category_code = 111301
		AND cp.region_code IS NULL 
	GROUP BY cpay.payroll_year,
		cpc.name
		)
SELECT *,
	round(((product_per_payroll - LAG(product_per_payroll) OVER (PARTITION BY product_name ORDER BY year))
		/ lag(product_per_payroll) OVER (PARTITION BY product_name ORDER BY year)) * 100, 2)
		AS percentage_change
FROM purchasing_power
-- Shows how many bread it is possible to buy for average payroll in 2006 and 2018 and how it changed over the years.

WITH purchasing_power as(
	SELECT avg(cpay.value) AS avg_payroll,
		round(avg(cp.value)::numeric, 2) AS avg_price,
		cpc.name AS product_name,
		round(avg(cpay.value)::numeric / avg(cp.value)::numeric) AS product_per_payroll,
		cpay.payroll_year AS year
	FROM czechia_payroll AS cpay 
	LEFT JOIN czechia_price AS cp 
		ON cpay.payroll_year = date_part('year', cp.date_from)
	LEFT JOIN czechia_price_category AS cpc 
		ON cp.category_code = cpc.code
	WHERE cpay.value_type_code = '5958'
		AND cpay.calculation_code = 200
		AND cpay.industry_branch_code IS NULL 
		AND cpay.payroll_year IN (2006, 2018)
		AND cp.category_code = 114201
		AND cp.region_code IS NULL 
	GROUP BY cpay.payroll_year,
		cpc.name
		)
SELECT *,
	round(((product_per_payroll - LAG(product_per_payroll) OVER (PARTITION BY product_name ORDER BY year))
		/ lag(product_per_payroll) OVER (PARTITION BY product_name ORDER BY year)) * 100, 2)
		AS percentage_change
FROM purchasing_power
-- Shows how many milk it is possible to buy for average payroll in 2006 and 2018 and how it changed over the years.