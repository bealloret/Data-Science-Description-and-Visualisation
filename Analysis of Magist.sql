USE `magist`;


/*1.Locating info about Magist: What is in each table? How big is the data set?*/
SELECT 
    *
FROM
    customers;

SELECT *
FROM products;

SELECT state, count(city)
FROM geo
group by state;

SELECT count(state)
FROM geo;


/*2. Explore the data set: Where are customers located*/
SELECT count(customer_id), state
FROM customers c
LEFT JOIN geo g ON customer_zip_code_prefix=zip_code_prefix
GROUP BY state;


SELECT COUNT(order_id), MAX(order_purchase_timestamp), MIN(order_purchase_timestamp)
FROM orders;/*Is there customer´s growth? What is the time scope of the data set? Is there customer growth over time?*/

SELECT COUNT(order_id), order_status
FROM orders
GROUP BY order_status;

SELECT YEAR(order_purchase_timestamp) AS order_year, MONTH(order_purchase_timestamp) AS order_month, COUNT(order_id)
FROM orders
GROUP BY YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp)
ORDER BY order_year, order_month;

SELECT YEAR(order_purchase_timestamp) as order_year, COUNT(order_id)
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY order_year;


SELECT count(*)
FROM products;/*How many products are offered?*/

SELECT product_category_name, count(*) as product_amount
FROM products
GROUP BY product_category_name
ORDER BY product_amount;

SELECT 
    COUNT(DISTINCT product_id) AS products_count
FROM
    products;

SELECT product_id, count(*) as duplicate_id
FROM products
GROUP BY product_id
HAVING COUNT(*)>1;


SELECT count(distinct(product_category_name))
FROM products;/*Amount of products offered that are different*/

SELECT count(distinct(product_id))
FROM products;

SELECT count(distinct(product_id))
FROM order_items;


SELECT count(order_item_id)
FROM order_items;/*Amount of products sold*/

SELECT count(order_item_id) as count_item, order_purchase_timestamp, price,
CASE 
           WHEN YEAR(order_purchase_timestamp) LIKE 2016 THEN '2016'
           WHEN YEAR(order_purchase_timestamp) LIKE 2017 THEN '2017'
           WHEN YEAR(order_purchase_timestamp) LIKE 2018 THEN '2018'
           ELSE 'no_timestamp'
       END AS year_purchase
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id=o.order_id
GROUP BY order_purchase_timestamp, price
ORDER BY order_purchase_timestamp;/*Amount of products sold over time*/


SELECT *
FROM order_items;

SELECT count(*)
FROM products;

SELECT product_category_name, count(*) as product_amount
FROM products
GROUP BY product_category_name
ORDER BY product_amount;/* What are the categories of products availabe and products sold?*/

SELECT *
FROM order_items oi
LEFT JOIN products p
ON  oi.product_id=p.product_id;

SELECT product_category_name, COUNT(oi.product_id) AS products_count 
FROM order_items oi
LEFT JOIN products p
ON  oi.product_id=p.product_id
GROUP BY product_category_name
ORDER BY products_count;



/*3.Using the CASE function to answer main business questions about Magist: Are tech products being sold by this company? How many? Which ones?*/

SELECT COUNT(oi.product_id) AS products_count,
       product_category_name,
       CASE 
           WHEN product_category_name LIKE 'ele%' THEN 'tech_category'
           WHEN product_category_name LIKE 'info%' THEN 'tech_category'
           WHEN product_category_name LIKE 'pc%' THEN 'tech_category'
           WHEN product_category_name LIKE 'tel%' THEN 'tech_category'
           WHEN product_category_name = 'audio' THEN 'tech_category'
           ELSE 'not_tech'
       END AS big_category
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
GROUP BY product_category_name
ORDER BY big_category;/*Option 1 of Conditions: Creating the category of tech-products*/


SELECT count(*)
FROM order_items;

SELECT 
	count(DISTINCT product_id) AS n_products
FROM
	order_items;
    


SELECT 
	count(oi.product_id), product_category_name, price
FROM
	order_items oi
LEFT JOIN products p
ON  oi.product_id=p.product_id
GROUP BY price, product_category_name
ORDER BY price DESC;/*What is the price of the products sold?*/

SELECT 
    MIN(price) AS cheapest, 
    MAX(price) AS most_expensive
FROM 
	order_items;
    
    
SELECT
    MIN(payment_value) AS cheapest, 
    MAX(payment_value) AS most_expensive
FROM 
	order_payments op;

SELECT product_category_name,
    MIN(payment_value) AS cheapest, 
    MAX(payment_value) AS most_expensive
FROM 
	order_payments op
LEFT JOIN order_items oi
ON oi.order_id=op.order_id
LEFT JOIN products p
ON oi.product_id=p.product_id
GROUP BY(product_category_name)
ORDER BY most_expensive;

SELECT 
	MAX(payment_value) as highest,
    MIN(payment_value) as lowest
FROM
	order_payments;
    
    
/*4. Refining the Queries: Price filtered by category?*/

SELECT COUNT(oi.product_id) AS products_count, MAX(oi.price) AS highest_price,
       product_category_name,
       CASE 
           WHEN product_category_name LIKE 'ele%' THEN 'tech_category'
           WHEN product_category_name LIKE 'info%' THEN 'tech_category'
           WHEN product_category_name LIKE 'pc%' THEN 'tech_category'
           WHEN product_category_name LIKE 'tel%' THEN 'tech_category'
           WHEN product_category_name = 'audio' THEN 'tech_category'
           ELSE 'not_tech'
       END AS big_category
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
GROUP BY product_category_name
ORDER BY big_category, highest_price;


SELECT oi.order_id, oi.product_id, MAX(oi.price) AS highest_price, MIN(oi.price) AS lowest_price, ROUND(AVG(oi.price),2) AS avg_price,
       product_category_name,
       CASE 
           WHEN product_category_name LIKE 'ele%' THEN 'tech_category'
           WHEN product_category_name LIKE 'info%' THEN 'tech_category'
           WHEN product_category_name LIKE 'pc%' THEN 'tech_category'
           WHEN product_category_name LIKE 'tel%' THEN 'tech_category'
           WHEN product_category_name = 'audio' THEN 'tech_category'
           ELSE 'not_tech'
       END AS big_category
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
GROUP BY product_category_name, oi.product_id, oi.order_id
ORDER BY highest_price DESC, big_category;


SELECT 
    oi.order_id,
    COUNT(oi.product_id) AS products_count, 
    MAX(oi.price) AS highest_price, 
    MIN(oi.price) AS lowest_price, 
    ROUND(AVG(oi.price),2) AS avg_price,
	product_category_name,
    MONTH(order_purchase_timestamp) AS month_purchase,
    YEAR(order_purchase_timestamp) AS year_purchase,
       CASE 
           WHEN product_category_name LIKE 'ele%' THEN 'tech_category'
           WHEN product_category_name LIKE 'info%' THEN 'tech_category'
           WHEN product_category_name LIKE 'pc%' THEN 'tech_category'
           WHEN product_category_name LIKE 'tel%' THEN 'tech_category'
           WHEN product_category_name = 'audio' THEN 'tech_category'
           ELSE 'not_tech'
       END AS big_category
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
INNER JOIN orders o ON oi.order_id=o.order_id
GROUP BY 
   oi.order_id,
   product_category_name, 
   MONTH(order_purchase_timestamp), 
   YEAR(order_purchase_timestamp)
ORDER BY highest_price DESC, big_category;


SELECT 
   *,
       CASE 
           WHEN product_category_name LIKE 'ele%' THEN 'tech_category'
           WHEN product_category_name LIKE 'info%' THEN 'tech_category'
           WHEN product_category_name LIKE 'pc%' THEN 'tech_category'
           WHEN product_category_name LIKE 'tel%' THEN 'tech_category'
           WHEN product_category_name = 'audio' THEN 'tech_category'
           ELSE 'not_tech'
       END AS big_category
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
INNER JOIN orders o ON oi.order_id=o.order_id;/*Table for Tableau with BIG CATEGORY- Option 1 categorization*/


SELECT 
    *,
       CASE 
		 WHEN(product_category_name LIKE 'ele%' 
			OR product_category_name LIKE 'info%' 
			OR product_category_name LIKE 'pc%' 
			OR product_category_name LIKE 'tel%' 
            OR product_category_name = 'audio') 
            AND price>=500 THEN 'high_category'
		WHEN(product_category_name LIKE 'ele%' 
            OR product_category_name LIKE 'info%' 
            OR product_category_name LIKE 'pc%' 
            OR product_category_name LIKE 'tel%' 
            OR product_category_name = 'audio') 
            AND price<500 THEN "tech_category"
		ELSE 'not_tech'
       END AS big_category
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
INNER JOIN orders o ON oi.order_id=o.order_id
LEFT JOIN order_reviews orev ON orev.order_id=oi.order_id;/*Option 2 of Conditions: Creating the category of tech-products, New high-end-tech-category with price > 500*/


SELECT 
count(order_id) as order_count, 
YEAR(order_purchase_timestamp) as order_year,
MONTH(order_purchase_timestamp) as order_month
FROM orders
GROUP BY order_year, order_month
ORDER BY order_year DESC, order_month DESC;/* Are deliveries on time?*/


select avg(price)
FROM order_items;/*Further business questions: How is the Revenue?*/

select sum(price)
FROM order_items;

select count(order_item_id)
FROM order_items;

SELECT 
    avg(price) as avg_price, sum(price) as sum_price, count(order_item_id) as amount_items,
       CASE 
           WHEN(product_category_name LIKE 'ele%' 
           OR product_category_name LIKE 'info%' 
           OR product_category_name LIKE 'pc%' 
           OR product_category_name LIKE 'tel%' 
           OR product_category_name = 'audio') 
           AND price>=500 THEN 'high_tech_category'
           WHEN(product_category_name LIKE 'ele%' 
           OR product_category_name LIKE 'info%' 
           OR product_category_name LIKE 'pc%' 
           OR product_category_name LIKE 'tel%' 
           OR product_category_name = 'audio') 
           AND price<500 THEN "tech_category"
           ELSE 'not_tech'
       END AS big_category
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
INNER JOIN orders o ON oi.order_id=o.order_id
GROUP BY big_category;



/* 5. Extra skill:Saving an updated table -Merle*/
SET SQL_SAFE_UPDATES = 0; /*Safety mode is off  = 0, and on = 1, at the beginning you have to run this line with 0, and at the end of the change in the table you set it to 1 and run it again*/
SELECT * FROM order_items;

ALTER TABLE order_items /* Add new column for the variable */
ADD big_category VARCHAR(50);

UPDATE order_items oi/* Update the variable*/
LEFT JOIN products p ON oi.product_id = p.product_id
SET big_category = 
       CASE 
           WHEN(product_category_name LIKE 'ele%' 
           OR product_category_name LIKE 'info%' 
           OR product_category_name LIKE 'pc%' 
           OR product_category_name LIKE 'tel%' 
           OR product_category_name = 'audio') 
           AND price>=500 THEN 'high_category'
           WHEN(product_category_name LIKE 'ele%' 
           OR product_category_name LIKE 'info%' 
           OR product_category_name LIKE 'pc%' 
           OR product_category_name LIKE 'tel%' 
           OR product_category_name = 'audio') 
           AND price<500 THEN 'tech_category'
           ELSE 'not_tech'
		END;
      
SET SQL_SAFE_UPDATES = 1;