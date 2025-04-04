-- 1. List all customers who have made purchases of more than $80.

SELECT DISTINCT Users.user_id, Users.name, Users.email
FROM Users
INNER JOIN Orders ON Users.user_id = Orders.user_id
WHERE Orders.total_amount > 80;

-- 2. Retrieve all orders placed in the last 280 days along with the customer name and email.

SELECT Orders.order_id, Orders.order_date, Users.name, Users.email
FROM Orders
INNER JOIN Users ON Orders.user_id = Users.user_id
WHERE DATEDIFF(CURDATE(), Orders.order_date) <= 280;

-- 3. Find the average product price for each category.

SELECT category, AVG(price) AS avg_price
FROM Products
GROUP BY category;

-- 4. List all customers who have purchased a product from the category Electronics.

SELECT Users.user_id, Users.name, Users.email, Products.category
FROM Users
JOIN Orders ON Users.user_id = Orders.user_id
JOIN OrderDetails ON Orders.order_id = OrderDetails.order_id
JOIN Products ON OrderDetails.product_id = Products.product_id
WHERE Products.category = 'Electronics';

-- 5. Find the total number of products sold and the total revenue generated for each product.

SELECT Products.product_id, Products.name, 
    SUM(OrderDetails.quantity) AS total_products_sold, 
    SUM(OrderDetails.quantity * Products.price) AS total_revenue
FROM OrderDetails
JOIN Products ON OrderDetails.product_id = Products.product_id
GROUP BY Products.product_id, Products.name;

-- 6. Update the price of all products in the Books category, increasing it by 10%. Query.

-- Disable safe update mode for this session
SET SQL_SAFE_UPDATES = 0;

UPDATE Products
SET price = ROUND(price * 1.10, 2)
WHERE category = 'Books';

SELECT * FROM Products WHERE category = 'Books';

-- 7. Remove all orders that were placed before 2020.

DELETE FROM Orders
WHERE order_date < '2020-01-01';

-- 8.Write a query to fetch the order details, including customer name, product name, and quantity, 
-- for orders placed on 2024-05-01.

SELECT Users.name, Products.name, OrderDetails.quantity, Orders.order_date
FROM Orders
JOIN Users ON Orders.user_id = Users.user_id
JOIN OrderDetails ON Orders.order_id = OrderDetails.order_id
JOIN Products ON OrderDetails.product_id = Products.product_id
WHERE Orders.order_date='2024-05-01';

-- 9. Fetch all customers and the total number of orders they have placed.

SELECT Users.user_id, Users.name,
    COUNT(Orders.order_id) AS total_orders
FROM Users
LEFT JOIN Orders ON Users.user_id = Orders.user_id
GROUP BY Users.user_id, Users.name;

-- 10. Retrieve the average rating for all products in the Electronics category.

select * from Products;

ALTER TABLE Products ADD COLUMN Rating INT;

UPDATE Products 
SET Rating = CASE 
    WHEN product_id = 1 THEN 4
    WHEN product_id = 2 THEN 4
    WHEN product_id = 3 THEN 3
    WHEN product_id = 4 THEN 5
    WHEN product_id = 5 THEN 2
END
WHERE product_id IN (1, 2, 3, 4, 5);

SELECT category, ROUND(AVG(Rating), 2) AS average_rating
FROM Products
WHERE category = 'Electronics';

-- 11.List all customers who purchased more than 1 units of any product, including the product name and total quantity purchased.

SELECT Users.user_id, Users.name, Products.name AS Product_name, 
    SUM(OrderDetails.quantity) AS total_quantity_purchased
FROM OrderDetails
JOIN Orders ON OrderDetails.order_id = Orders.order_id
JOIN Users ON Orders.user_id = Users.user_id
JOIN Products ON OrderDetails.product_id = Products.product_id
GROUP BY Users.user_id, Users.name, Products.name
HAVING SUM(OrderDetails.quantity) > 1;

-- 12. Find the total revenue generated by each category along with the category name.

SELECT Products.category, 
    ROUND(SUM(Products.price * OrderDetails.quantity), 2) AS total_revenue
FROM OrderDetails
JOIN Products ON OrderDetails.product_id = Products.product_id
GROUP BY Products.category;