

--CREATE THE ORDER_DETAILS TABLE

CREATE TABLE order_details (
  order_details_id SMALLINT NOT NULL,
  order_id SMALLINT NOT NULL,
  order_date DATE,
  order_time TIME,
  item_id SMALLINT,
  PRIMARY KEY (order_details_id)
);

--CREATE THE MENU_ITEMS TABLE

CREATE TABLE menu_items (
  menu_item_id SMALLINT NOT NULL,
  item_name VARCHAR(45),
  category VARCHAR(45),
  price DECIMAL(5,2),
  PRIMARY KEY (menu_item_id)
);

--INSERT THE DATA INTO ORDER_DETAILS TABLE


bulk insert order_details
 from 'C:\Dharane\Maven Analytics\Restaurant+Orders+MySQL\order_details_table.csv'
 WITH (
  FIELDTERMINATOR = ',',
  ROWTERMINATOR = '\n',
  FIRSTROW = 1
)

--INSERT THE DATA INTO ORDER_DETAILS TABLE


INSERT INTO menu_items VALUES (101, 'Hamburger', 'American', 12.95),
(102, 'Cheeseburger', 'American', 13.95),
(103, 'Hot Dog', 'American', 9),
(104, 'Veggie Burger', 'American', 10.5),
(105, 'Mac & Cheese', 'American', 7),
(106, 'French Fries', 'American', 7),
(107, 'Orange Chicken', 'Asian', 16.5),
(108, 'Tofu Pad Thai', 'Asian', 14.5),
(109, 'Korean Beef Bowl', 'Asian', 17.95),
(110, 'Pork Ramen', 'Asian', 17.95),
(111, 'California Roll', 'Asian', 11.95),
(112, 'Salmon Roll', 'Asian', 14.95),
(113, 'Edamame', 'Asian', 5),
(114, 'Potstickers', 'Asian', 9),
(115, 'Chicken Tacos', 'Mexican', 11.95),
(116, 'Steak Tacos', 'Mexican', 13.95),
(117, 'Chicken Burrito', 'Mexican', 12.95),
(118, 'Steak Burrito', 'Mexican', 14.95),
(119, 'Chicken Torta', 'Mexican', 11.95),
(120, 'Steak Torta', 'Mexican', 13.95),
(121, 'Cheese Quesadillas', 'Mexican', 10.5),
(122, 'Chips & Salsa', 'Mexican', 7),
(123, 'Chips & Guacamole', 'Mexican', 9),
(124, 'Spaghetti', 'Italian', 14.5),
(125, 'Spaghetti & Meatballs', 'Italian', 17.95),
(126, 'Fettuccine Alfredo', 'Italian', 14.5),
(127, 'Meat Lasagna', 'Italian', 17.95),
(128, 'Cheese Lasagna', 'Italian', 15.5),
(129, 'Mushroom Ravioli', 'Italian', 15.5),
(130, 'Shrimp Scampi', 'Italian', 19.95),
(131, 'Chicken Parmesan', 'Italian', 17.95),
(132, 'Eggplant Parmesan', 'Italian', 16.95);

--TASK - 1
 --1.1 View the menu_items table and write a query to find the number of items on the menu

 SELECT COUNT(*) FROM menu_items

  --1.2 What are the least and most expensive items on the menu?


 --SOUTION - 1 (USING SIMPLE QUERY TO FETCH THE SPECIFIC COLUMNS)
 
 SELECT TOP 1 ITEM_NAME, PRICE AS MIN_PRICE FROM menu_items ORDER BY PRICE  ASC
 SELECT TOP 1 ITEM_NAME, PRICE AS MAX_PRICE FROM menu_items ORDER BY PRICE  DESC

 --SOLUTTION - 2 ( USING SUB QUERY TO FETCH ALL THE COLUMN)

  SELECT * FROM menu_items WHERE PRICE = ( SELECT MIN(PRICE) FROM menu_items) 
  SELECT * FROM menu_items WHERE PRICE = ( SELECT MAX(PRICE) FROM menu_items) 

-- 1.3 How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?

SELECT COUNT(*) FROM menu_items WHERE category = 'Italian'
SELECT TOP 1 * FROM menu_items WHERE category = 'Italian' ORDER BY PRICE, item_name ASC
SELECT TOP 1 * FROM menu_items WHERE category = 'Italian' ORDER BY PRICE DESC


-- 1. 4 How many dishes are in each category? What is the average dish price within each category?

SELECT AVG(PRICE) AS AVG_PRICE,COUNT(CATEGORY) AS COUNT_CATEGORY,CATEGORY FROM menu_items GROUP BY CATEGORY


--TASK - 2
--2.1 View the order_details table. What is the date range of the table?

SELECT MIN(ORDER_DATE) AS MIN_RAGE, MAX(ORDER_DATE) AS MAX_RANGE FROM order_details 

--2.2 How many orders were made within this date range? 


SELECT COUNT(DISTINCT order_id) FROM order_details WHERE order_date BETWEEN '2023-01-01' AND '2023-03-31'

--2.3How many items were ordered within this date range?
 SELECT COUNT(*) AS TOTAL_ORDERS FROM order_details WHERE order_date BETWEEN '2023-01-01' AND '2023-03-31'

 --2.4 Which orders had the most number of items?
    
SELECT Order_id ,COUNT(ITEM_ID) AS COUNT_ITEMS FROM order_details GROUP BY ORDER_ID ORDER BY COUNT(ITEM_ID) DESC

--2.5 How many orders had more than 12 items?

SELECT COUNT(*) FROM (
  SELECT Order_id ,COUNT(ITEM_ID) AS COUNT_ITEMS FROM order_details GROUP BY ORDER_ID HAVING COUNT(ITEM_ID) > 12 ) AS NUM_ORDERS


--TASK - 3

-- 3.1 Combine the menu_items and order_details tables into a single table

SELECT * FROM order_details
SELECT * FROM menu_items

SELECT * FROM order_details AS A
  LEFT JOIN menu_items AS B ON
A.item_id = B.menu_item_id

--3.2 What were the least and most ordered items? What categories were they in?

SELECT TOP 1 item_name,CATEGORY,COUNT(order_details_id) AS COUNTS FROM order_details AS A
  LEFT JOIN menu_items AS B ON
A.item_id = B.menu_item_id
 GROUP BY ITEM_NAME,CATEGORY ORDER BY COUNTS ASC

 
SELECT TOP 1 item_name,CATEGORY,COUNT(order_details_id) AS COUNTS FROM order_details AS A
  LEFT JOIN menu_items AS B ON
A.item_id = B.menu_item_id
 GROUP BY ITEM_NAME,CATEGORY ORDER BY COUNTS DESC


--3.3 What were the top 5 orders that spent the most money?

SELECT TOP 5 ORDER_ID,SUM(PRICE) AS TOTAL_PRICE FROM order_details AS A
  LEFT JOIN menu_items AS B ON
A.item_id = B.menu_item_id
 GROUP BY order_id ORDER BY TOTAL_PRICE DESC





--3.4 View the details of the highest spend order. Which specific items were purchased?

SELECT category, COUNT(ITEM_ID) AS NUM_ITEMS FROM order_details AS A
  LEFT JOIN menu_items AS B ON
A.item_id = B.menu_item_id
WHERE order_id = 440
 GROUP BY category

 --3.5 View the details of the top 5 highest spend orders
SELECT category, COUNT(ITEM_ID) AS NUM_ITEMS FROM order_details AS A
  LEFT JOIN menu_items AS B ON
A.item_id = B.menu_item_id
WHERE order_id IN (440,
2075,
1957,
330,
2675 )
 GROUP BY category
