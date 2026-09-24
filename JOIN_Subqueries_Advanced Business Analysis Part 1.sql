create table customers(
customer_name varchar(20),
customer_id int primary key,
city varchar(20)
);

create table orders(
order_id int primary key,
customer_id int,
product_id int,
amount int,
status varchar(15),
order_date date
);

create table products(
product_id int primary key,
product_name varchar(20),
category varchar(20),
price int
);

alter table orders
add constraint fk_orders_customers
foreign key (customer_id)
references customers(customer_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);

	INSERT INTO customers (customer_id, customer_name, city)
VALUES
(101, 'Amit', 'Delhi'),
(102, 'Neha', 'Mumbai'),
(103, 'Rahul', 'Delhi'),
(104, 'Priya', 'Bangalore'),
(105, 'Rohan', 'Pune'),
(106, 'Sneha', 'Mumbai'),
(107, 'Vikas', 'Chennai'),
(108, 'Anjali', 'Delhi'),
(109, 'Karan', 'Pune'),
(110, 'Meera', 'Bangalore'),
(111, 'Arjun', 'Hyderabad'),
(112, 'Pooja', 'Chennai');

INSERT INTO products (product_id, product_name, category, price)
VALUES
(201, 'Laptop Pro', 'Electronics', 75000),
(202, 'Smartphone X', 'Electronics', 45000),
(203, 'Headphones', 'Accessories', 5000),
(204, 'Monitor 24', 'Electronics', 15000),
(205, 'Keyboard', 'Accessories', 3000),
(206, 'Office Chair', 'Furniture', 12000),
(207, 'Tablet Air', 'Electronics', 30000),
(208, 'Mouse', 'Accessories', 1500);

INSERT INTO orders 
(order_id, customer_id, product_id, amount, status, order_date)
VALUES
(1001, 101, 201, 75000, 'Completed', '2026-01-05'),
(1002, 101, 203, 5000, 'Completed', '2026-01-10'),
(1003, 102, 202, 45000, 'Completed', '2026-01-12'),
(1004, 102, 204, 15000, 'Cancelled', '2026-01-15'),
(1005, 103, 205, 3000, 'Completed', '2026-01-18'),
(1006, 103, 206, 12000, 'Completed', '2026-01-22'),
(1007, 104, 207, 30000, 'Cancelled', '2026-02-02'),
(1008, 104, 203, 5000, 'Completed', '2026-02-08'),
(1009, 105, 201, 75000, 'Completed', '2026-02-10'),
(1010, 105, 208, 1500, 'Cancelled', '2026-02-14'),
(1011, 106, 202, 45000, 'Completed', '2026-02-18'),
(1012, 106, 203, 5000, 'Completed', '2026-02-20'),
(1013, 107, 206, 12000, 'Cancelled', '2026-02-25'),
(1014, 107, 208, 1500, 'Completed', '2026-03-01'),
(1015, 108, 204, 15000, 'Completed', '2026-03-05'),
(1016, 108, 205, 3000, 'Cancelled', '2026-03-08'),
(1017, 109, 201, 75000, 'Completed', '2026-03-12'),
(1018, 109, 202, 45000, 'Completed', '2026-03-15'),
(1019, 110, 206, 12000, 'Completed', '2026-03-18'),
(1020, 110, 208, 1500, 'Cancelled', '2026-03-20'),
(1021, 111, 207, 30000, 'Completed', '2026-03-22'),
(1022, 111, 203, 5000, 'Cancelled', '2026-03-25'),
(1023, 112, 204, 15000, 'Completed', '2026-03-28'),
(1024, 112, 208, 1500, 'Completed', '2026-03-30'),
(1025, 101, 204, 15000, 'Completed', '2026-04-02'),
(1026, 103, 201, 75000, 'Cancelled', '2026-04-05'),
(1027, 106, 205, 3000, 'Completed', '2026-04-08'),
(1028, 109, 203, 5000, 'Cancelled', '2026-04-10');


/* Q1. Customers above average spending ⭐

Calculate each customer's total order amount. Show only customers whose total spending is greater
than the average customer spending.
Output:
customer_id
customer_name
total_amount*/

select c.customer_id, c.customer_name, sum(o.amount) as total_spending
from customers c 
left join orders o
on c.customer_id=o.customer_id
group by c.customer_id, c.customer_name
having total_spending>(


select avg(total_spending) from
(
select c.customer_id, sum(o.amount) as total_spending
from customers c 
inner join orders o
on c.customer_id=o.customer_id
group by customer_id
) as customer_total
);

/* Q2. Products above average sales ⭐

Calculate total sales for each product. Show only products whose total sales are greater
than the average product sales.

Output:

product_name
category
total_sales*/

select p.product_name, p.category, sum(o.amount) as total_sales
from products p 
left join orders o
on p.product_id=o.product_id
group by p.product_name, p.category
having total_sales>(
select avg(total_sale) from(
select p.product_id, p.product_name, sum(o.amount) total_sale
from products p 
inner join orders o
on p.product_id=o.product_id
group by p.product_id, p.product_name
) as product_total
);

/* Q3. Customers with above-average completed orders

Calculate each customer's number of completed orders. Show customers whose completed-order 
count is greater than the average completed-order count per customer.

Output:

customer_name
completed_orders*/

select c.customer_id, c.customer_name, count(o.customer_id) as completed_orders_placed
from customers c 
left join
orders o 
on c.customer_id=o.customer_id
where o.status='Completed'
group by c.customer_id, c.customer_name
having completed_orders_placed>(

select avg(completed_orders) from
(
select c.customer_id, count(o.customer_id) 'completed_orders' 
from customers c 
inner join orders o
on c.customer_id=o.customer_id
where o.status='Completed'
group by c.customer_id) as total_completed
);

/*Q4. Cities above average revenue

Calculate completed revenue for each city. Show only cities whose revenue is greater 
than the average city revenue.

Output:

city
total_revenue*/

select c.city, sum(o.amount) as avg_revenue 
from customers c 
inner join orders o 
on
c.customer_id= o.customer_id
WHERE o.status = 'Completed'
group by c.city
having avg_revenue>(
select avg(city_total)
from(
select c.city, sum(o.amount) as city_total
from customers c
inner join orders o 
on c.customer_id=o.customer_id
WHERE o.status = 'Completed'
group by c.city) city_revenue);

/* Q5. Products with above-average cancellation rate ⭐
For each product, calculate:
product_name
total_orders
cancelled_orders
cancellation_rate
Then show only products whose cancellation rate is greater than the average cancellation 
rate across all products.*/ 

select p.product_name, count(o.product_id) as total_orders, 
sum(case 
	when o.status='Cancelled' then 1 else 0 end
    ) as cancelled_orders,
sum(case
	when o.status='Cancelled' then 1 else 0 end
    )/ count(o.product_id)*100 as cancellation_rate
from products p 
inner join orders o
on p.product_id=o.product_id
group by p.product_name
having cancellation_rate>(     








select avg(o_cancellation_rate) from(
select sum(case
	when o.status='Cancelled' then 1 else 0 end
    )/ count(o.product_id)*100 as o_cancellation_rate
    from products p 
inner join orders o
on p.product_id=o.product_id
group by p.product_id
)overall_cancelation
);


