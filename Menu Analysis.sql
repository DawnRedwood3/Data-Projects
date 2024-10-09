USE restaurant_db

-- -------------------------- PART 1 : menu  ------------------------------------------
-- 1) checking out the items on the menu
SELECT * FROM menu_items
SELECT COUNT(DISTINCT item_name) FROM menu_items

-- 2) finding min and max prices
-- cheapest item: edamame
SELECT * FROM menu_items
ORDER BY price

-- most expensive item: shrimp scampi
SELECT * FROM menu_items
ORDER BY price DESC

-- 3) number of italian dishes on the menu: 9
SELECT Count(item_name),category FROM menu_items
GROUP By category

-- 4) finding most and least expensive italian dish: cheapest--> Spahgetti,priciest-->Shrimp Scampi
SELECT item_name, category, price FROM menu_items
WHERE category like 'italian'
ORDER BY price

-- 5) how many dishes are in each category? avg price of each category?
-- american 6,10 - mexican 9,11.8 - asian 8,13.5 -italian 9,16.75
SELECT category, count(item_name) as no_items, avg(price) as avg_price FROM menu_items
group by category
order by avg_price

-- --------------------------  PART 2: orders  ------------------------------------------
-- Explore order tables: --------------
-- 1) find date range: 2023-01-01 to 2023-03-31
SELECT MIN(order_date), MAX(order_date) FROM order_details

-- 2) how many orders and how many items were ordered within this range?
SELECT count(order_id) as no_orders, count(DISTINCT order_id) as no_items FROM order_details

-- 3) which order had the most number of items?
SELECT order_id, count(item_id) as no_item_per_order FROM order_details
GROUP BY order_id
ORDER BY no_item_per_order DESC

-- 4) how many orders had more than 12 items? 20
SELECT COUNT(*) From
(SELECT order_id, count(item_id) as no_item_per_order FROM order_details
GROUP BY order_id
HAVING no_item_per_order>12
ORDER BY no_item_per_order DESC) AS no_orders

-- --------------------------   PART 3: analyzing customer behavior ----------------------------
-- 1) combine the order and menu tables:
SELECT * FROM order_details
SELECT * FROM menu_items

SELECT * 
FROM order_details as od LEFT JOIN menu_items as mi
	ON mi.menu_item_id = od.item_id

-- 2) What were the least and most ordered items? What categories were they in?
-- chicken tacos-Mexican are the least ordered and Hamburgers-American the most ordered. 
SELECT item_id, item_name, category, price, count(*) as no_ordrs
FROM order_details as od LEFT JOIN menu_items as mi
	ON mi.menu_item_id = od.item_id
GROUP BY item_id
ORDER BY no_ordrs

-- 3) What were the top 5 orders that spent the most money?
SELECT order_id, sum(price) as total_price
FROM order_details as od LEFT JOIN menu_items as mi
	ON mi.menu_item_id = od.item_id
GROUP BY order_id
ORDER BY total_price DESC
LIMIT 5

-- 4) View the details of the highest spend order. Which specific items were purchased?
-- So Italian was their top category.
SELECT *
FROM order_details as od LEFT JOIN menu_items as mi
	ON mi.menu_item_id = od.item_id
WHERE order_id=440
ORDER BY category

SELECT category, COUNT(item_id) as no_items FROM
(SELECT *
FROM order_details as od LEFT JOIN menu_items as mi
	ON mi.menu_item_id = od.item_id
WHERE order_id=440
ORDER BY category) as top_ordr
GROUP BY category

-- 5) View the details of the top 5 highest spend orders
-- Italian dishes are ordered a lot in these orders.
SELECT order_id, category, COUNT(item_id) as no_items
FROM order_details as od LEFT JOIN menu_items as mi
	ON mi.menu_item_id = od.item_id
WHERE order_id IN (440,2075,1957,330,2675)
GROUP BY order_id, category
