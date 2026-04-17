#Create Database
CREATE DATABASE supply_chain_project;
USE supply_chain_project;

#Create Table 
CREATE TABLE supply_data(
	product_type VARCHAR(50),
    sku VARCHAR(20),
    price FLOAT,
    availability INT,
    number_of_products_sold INT,
    revenue_generated FLOAT,
    customer_demographics VARCHAR(50),
    stock_levels INT,
    lead_times INT,
    order_quantities INT,
    shipping_times INT,
    shipping_carrier VARCHAR(50),
    shipping_costs FLOAT,
    supplier_name VARCHAR(50),
    location VARCHAR(50),
    lead_time INT,
    production_volumes INT,
    manufacturing_lead_time INT,
    manufacturing_costs FLOAT,
    inspection_results VARCHAR(50),
    defect_rates FLOAT,
    transportation_modes VARCHAR(50),
    routes VARCHAR(50),
	costs FLOAT
);

#View Data
SELECT * FROM supply_data LIMIT 10;


#Check Missing Values
SELECT *FROM supply_data
WHERE price IS NULL
OR stock_levels IS NULL
OR number_of_products_sold IS NULL;
   
#Remove Duplicates
CREATE TABLE clean_supply AS
SELECT DISTINCT * FROM supply_data;

# Handle Negative / Wrong Values
DELETE FROM clean_supply
WHERE number_of_products_sold < 0
OR stock_levels < 0;
   
# Handle Missing Supplier
UPDATE clean_supply
SET supplier_name = 'Unknown'
WHERE supplier_name IS NULL;

#Demand Analysis
SELECT 
sku,
SUM(number_of_products_sold) AS total_demand,
AVG(number_of_products_sold) AS avg_demand
FROM clean_supply
GROUP BY sku;

#Overstock Detection
SELECT 
sku,
stock_levels,
number_of_products_sold
FROM clean_supply
WHERE stock_levels > number_of_products_sold * 2;

#Stockout Risk
SELECT 
sku,
stock_levels,
number_of_products_sold
FROM clean_supply
WHERE stock_levels < number_of_products_sold;

#Supplier Performance
SELECT 
supplier_name,
AVG(lead_time) AS avg_lead_time,
AVG(defect_rates) AS avg_defects
FROM clean_supply
GROUP BY supplier_name;

#Cost Analysis
SELECT 
transportation_modes,
AVG(costs) AS avg_transport_cost
FROM clean_supply
GROUP BY transportation_modes;

# 6.6 Dead Stock (VERY IMPORTANT)
SELECT 
 sku
FROM clean_supply
GROUP BY sku
HAVING SUM(number_of_products_sold) = 0;

# FINAL DATA EXTRACTION 
SELECT 
    sku,
    product_type,
    price,
    availability,
    number_of_products_sold,
    stock_levels,
    lead_time,
    supplier_name,
    transportation_modes,
    costs
FROM clean_supply;