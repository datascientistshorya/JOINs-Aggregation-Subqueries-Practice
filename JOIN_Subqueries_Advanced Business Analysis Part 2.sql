/* Q6. Customers who bought expensive products ⭐
Find customers who purchased at least one product whose price is greater than 
the average price of all products.
Output:
customer_id
customer_name
product_name
price

Avoid duplicate customer-product combinations.*/
select distinct c.customer_id, c.customer_name, p.product_name, p.price
from customers c 
inner join orders o 
on c.customer_id=o.customer_id
inner join products p 
on p.product_id=o.product_id
where p.price> (
select avg(price)
from products);

/*Q7. Highest-spending customer in each city ⭐⭐
Calculate each customer's total spending.
Then identify the customer with the highest total spending within each city.
Output:
city
customer_name
total_amount*/

SELECT 
    c.city,
    c.customer_name,
    SUM(o.amount) AS total_amount
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.city, c.customer_name
HAVING SUM(o.amount) = (
    SELECT MAX(customer_total)
    FROM (
        SELECT 
            c2.city,
            c2.customer_id,
            SUM(o2.amount) AS customer_total
        FROM customers c2
        INNER JOIN orders o2
            ON c2.customer_id = o2.customer_id
        GROUP BY c2.city, c2.customer_id
    ) AS city_customers
    WHERE city_customers.city = c.city
);

/* Q8. Products above their category's average sales ⭐
For each product, calculate its total sales.
Then show only products whose total sales are greater than the average
sales of products within their own category.
Output:
category
product_name
total_sales
*/

SELECT
    p.category,
    p.product_name,
    SUM(o.amount) AS total_sales
FROM products p
INNER JOIN orders o
    ON p.product_id = o.product_id
GROUP BY p.category,p.product_name
HAVING SUM(o.amount) > (
    SELECT AVG(category_product_sales)
    FROM (
        SELECT
            p2.category,
            p2.product_id,
            SUM(o2.amount) AS category_product_sales
        FROM products p2
        INNER JOIN orders o2
            ON p2.product_id = o2.product_id
        WHERE p2.category = p.category
        GROUP BY p2.category, p2.product_id
    ) AS category_sales
);


/*Q9. Customers above the overall cancellation rate ⭐
For each customer, calculate:
total_orders
cancelled_orders
cancellation_rate

Then show only customers whose cancellation rate is greater than the average 
cancellation rate across all customers.
Output:
customer_name
total_orders
cancelled_orders
cancellation_rate*/

SELECT 
    c.customer_name, 
    c.customer_id, 
    COUNT(o.customer_id) AS total_orders, 
    SUM(CASE 
        WHEN o.status = 'Cancelled' THEN 1 
        ELSE 0 
    END) AS cancelled_orders,
    SUM(CASE 
        WHEN o.status = 'Cancelled' THEN 1 
        ELSE 0 
    END) / COUNT(o.customer_id) * 100 AS cancellation_rate
FROM customers c 
INNER JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name, c.customer_id
HAVING cancellation_rate > (
    SELECT AVG(customer_cancellation_rate)
    FROM (
        SELECT 
            c2.customer_name, 
            c2.customer_id,
            SUM(CASE 
                WHEN o2.status = 'Cancelled' THEN 1 
                ELSE 0 
            END) / COUNT(o2.customer_id) * 100 AS customer_cancellation_rate
        FROM customers c2
        INNER JOIN orders o2 
            ON c2.customer_id = o2.customer_id
        GROUP BY c2.customer_name, c2.customer_id
    ) AS overall_cancell
);

/*High-risk + high-spending customers
Find customers who satisfy both conditions:
Cancellation rate ≥ 30%
Total spending > average customer spending
Output
customer_name
total_orders
cancelled_orders
cancellation_rate
total_spending*/
select c.customer_name, count(o.customer_id) as total_orders,
sum(case when o.status='Cancelled' then 1 else 0 end) as cancelled_orders,
sum(case when o.status='Cancelled' then 1 else 0 end)/ count(o.customer_id) *100 as cancellation_rate,
sum(o.amount) as total_spending
from customers c inner join orders o
on c.customer_id=o.customer_id
group by c.customer_name
having cancellation_rate>=30
and sum(o.amount)>
(
       SELECT AVG(customer_total)
       FROM (
           SELECT 
               customer_id,
               SUM(amount) AS customer_total
           FROM orders
           GROUP BY customer_id
       ) AS customer_spending
   );