SELECT * -- This query selects all the elecments from sales_by_store table
FROM sales_by_store;

SELECT * -- This query selects all the elements from calendar table
FROM Calendar;

SELECT * 
FROM store_lookup; -- This query selects all the elecments from store_lookup table
 

SELECT * -- This query selects all the elecments from product_lookup table
FROM product_lookup; 

SELECT *  -- This query selects all the elecments from customer_lookup table
FROM customer_lookup;

SELECT *  -- This query selects all the elecments from employee_lookup table
FROM employee_lookup;

SELECT * -- This query selects all the elements from food_inventory table
FROM food_inventory;

--------------------------------------------------------------------------------------------------

SELECT days_to_be_sold,  -- This query selects all the elements from food_inventory table grouped by days to be sold
       COUNT(quantity_sold)
FROM  food_inventory
GROUP BY days_to_be_sold
ORDER BY days_to_be_sold DESC;

SELECT MIN(days_to_be_sold) -- This query shows for us the minimim days for a product in a store before selling
FROM food_inventory;

SELECT MAX(days_to_be_sold) -- This query shows for us the maximum days for a product in a store before selling
FROM food_inventory;

SELECT AVG(days_to_be_sold) -- This query shows for us the average days for a product in a store before selling
FROM food_inventory;

ALTER TABLE food_inventory -- We add a column to find the number of days between backed and transaction date
ADD COLUMN days_to_be_sold INT;

UPDATE food_inventory -- We calculate the difference
SET days_to_be_sold = transaction_date - baked_date;

SELECT days_to_be_sold,  -- This query finds the quantity sold after the defined days between backing and transation
       COUNT(sales_by_store.quantity_sold)
FROM sales_by_store
INNER JOIN food_inventory
ON food_inventory.product_id = sales_by_store.product_id
GROUP BY days_to_be_sold
ORDER BY COUNT(sales_by_store.quantity_sold) DESC;

SELECT store_type, store_id -- This query shows the type of each store
FROM store_lookup;

SELECT store_id, store_city -- This query shows the stores by city
FROM store_lookup;

SELECT store_id, store_square_feet -- This query shows the stores by square feet
FROM store_lookup
ORDER BY store_square_feet DESC;

SELECT store_id,  -- This query shows the quantity sold by store
       COUNT(quantity_sold)
FROM food_inventory
GROUP BY store_id;

SELECT store_city,  -- This query shows the quantity sold by city
       COUNT(quantity_sold)
FROM store_lookup
INNER JOIN sales_by_store
ON store_lookup.store_id = sales_by_store.store_id
GROUP BY store_city
ORDER BY COUNT(quantity_sold) DESC;

SELECT week_year,  --Defining busy weeks by store
       store_id,
	   COUNT(quantity_sold)
FROM calendar
INNER JOIN sales_by_store
ON calendar.transaction_date = sales_by_store.transaction_date
GROUP BY week_year, store_id
ORDER BY COUNT(quantity_sold) DESC;

Select transaction_date, -- This query shows us the quantity sold by day and orders the days by the quantity sold
COUNT(quantity_sold) AS quantity_sold
FROM sales_by_store
GROUP BY transaction_date
ORDER BY COUNT(quantity_sold) DESC;

CREATE TABLE quantity_sold_by_day AS( -- This query will create for us a table where we group the dates by the quatity sold
SELECT transaction_date, 
       COUNT(quantity_sold)
FROM sales_by_store
GROUP BY transaction_date);

COPY quantity_sold_by_day -- This query will create for us a csv file that we will use later on for visualisation
TO 'C:\\Users\\Public\\quantity_sold_by_day.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE product_and_sales AS( -- This query will create for us a simpler table to calculate the income by product
SELECT product_lookup.product_id,   
       quantity_sold,
	   unit_price,
	   current_cost
FROM product_lookup 
INNER JOIN sales_by_store 
ON product_lookup.product_id = sales_by_store.product_id );

SELECT * -- This query selects all the elecments from product_and_sales table
FROM product_and_sales;

ALTER TABLE product_and_sales -- This query adds a column to the created table to store the incomes by product
ADD COLUMN diff_cost_price float;

UPDATE product_and_sales -- This query will find the difference between cuurent cost and unit price
SET diff_cost_price = unit_price - current_cost;

ALTER TABLE product_and_sales -- This query adds a column to the created table to store the incomes by quantity sold
ADD COLUMN product_income float;

UPDATE product_and_sales -- This query will do the multiplication
SET product_income = diff_cost_price * quantity_sold;

SELECT SUM (product_income) -- The query calculates the sum of all the incomes and products sold (Total income)
FROM product_and_sales;

SELECT product_id,  -- This query shows the product id by product income
       COUNT(product_income)
FROM product_and_sales
GROUP BY product_id
ORDER BY COUNT(product_income) DESC;

SELECT product_type, product_id -- we select the 3 products which have the most income that we found from the previous query
FROM product_lookup
WHERE product_id = 71 
      OR product_id = 50  
	  OR product_id = 59;

SELECT  instore_yn,  -- This query shows the products that are in the store and not in
        COUNT(quantity_sold)
FROM sales_by_store
GROUP BY instore_yn;

SELECT  line_item_id,  -- This query shows the different line items
        COUNT(quantity_sold)
FROM sales_by_store
GROUP BY line_item_id;

SELECT  promo_item_yn,  --This query shows the quantity of product on promo
        COUNT(quantity_sold)
FROM sales_by_store
GROUP BY promo_item_yn;

CREATE TABLE product_sold_by_order AS( -- This query to create a table where we organize the products to know which product is sold the most, the second ...
SELECT product_type,
	   product_group,
	   product_category,
	   COUNT(quantity_sold)
FROM product_lookup
INNER JOIN sales_by_store
ON product_lookup.product_id = sales_by_store.product_id
GROUP BY product_group, product_category, product_type
ORDER BY COUNT(quantity_sold) DESC );

COPY product_sold_by_order -- This query to create a csv file that we will use for visualisation to know which product is sold the most, the second ...
TO 'C:\\Users\\Public\\product_sold_by_order.csv'
DELIMITER ','
CSV HEADER;

SELECT unit_price,  -- This query shows the quantity sold by unit price
       COUNT(quantity_sold)
FROM sales_by_store
GROUP BY unit_price
ORDER BY Count(quantity_sold) DESC;

SELECT current_cost,  -- This query shows the quantity sold by current cost
       COUNT(quantity_sold)
FROM sales_by_store
INNER JOIN product_lookup
ON product_lookup.product_id = sales_by_store.product_id
GROUP BY current_cost
ORDER BY Count(quantity_sold) DESC;

--------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT gender,  -- We group customers according to their gender, we have Male, Female and not specified
       COUNT(customer_id)
FROM customer_lookup
GROUP BY gender;

ALTER TABLE customer_lookup -- We add a column to calculate the age of the customers
ADD COLUMN customer_age INT;

UPDATE customer_lookup
SET customer_age = 2019 - birth_year ; -- Calculate the age of the customers until 2019

SELECT AVG(customer_age) 
FROM customer_lookup; --We found the average customer age = 40.61

SELECT MAX(customer_age) 
FROM customer_lookup; -- maximum customer age = 69

SELECT MIN(customer_age) 
FROM customer_lookup; -- minimum customerage = 18

SELECT COUNT(customer_id) AS young_customers
FROM customer_lookup
WHERE customer_age >= 18 AND customer_age <= 25; -- we found : 437

SELECT COUNT(customer_id) 
FROM customer_lookup
WHERE customer_age >= 26 AND customer_age <= 55; -- we found : 1320

SELECT COUNT(customer_id) AS old_customers
FROM customer_lookup
WHERE customer_age > 55; -- we found : 494

-------------------------------------------------------------------------------------------------------------------------------------------

SELECT the_position,  -- This query chooses us the different positions we can have in the coffeehouse and their quantity
       COUNT(staff_id)
FROM employee_lookup
GROUP BY the_position;

SELECT the_location, -- This query shows the number of employees of each position in all the stores
       COUNT(staff_id) AS staff_in_location
FROM employee_lookup
GROUP BY the_location;

SELECT the_position,  -- This query to know the numberof employees in each store for all different positions that we can find in one store
       the_location,
	   COUNT(staff_id) AS staff_in_location
FROM employee_lookup
GROUP BY the_position,the_location
ORDER BY the_location;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

