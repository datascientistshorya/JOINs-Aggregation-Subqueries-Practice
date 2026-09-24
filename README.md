# SQL Business Analysis — JOINs, Aggregation & Subqueries

## Project Overview

This project is a practical SQL business-analysis exercise designed to strengthen query-writing skills by working with a small relational e-commerce database.

Rather than solving isolated SQL syntax problems, the exercise focuses on answering **real-world business questions** such as:

* Which customers spend more than the average customer?
* Which products generate above-average sales?
* Which customers complete more orders than average?
* Which cities generate above-average completed revenue?
* Which products have unusually high cancellation rates?

The objective is to move from simply **writing SQL queries** to using SQL to **analyze business performance, identify patterns, and support data-driven decisions**.

---

## Motive of the Exercise

The main motive is to develop practical SQL skills that are required in real-world **Data Analyst, Business Analyst, Web Analyst, and Data Science** roles.

In business environments, analysts rarely receive a question such as:

> "Write a JOIN query."

Instead, they receive questions such as:

> "Which customers are generating more revenue than average?"

> "Which products have unusually high cancellation rates?"

Answering these questions requires combining multiple SQL concepts in a logical sequence.

This exercise therefore focuses on developing the ability to:

1. Understand relationships between database tables.
2. Combine data using JOINs.
3. Aggregate data at the correct business level.
4. Calculate business metrics.
5. Compare individual entities against overall benchmarks.
6. Use subqueries to create dynamic benchmarks.
7. Translate business questions into structured SQL logic.

---

# Database Structure

The exercise uses three related tables representing a simplified e-commerce business.

### 1. `customers`

Stores customer-level information.

| Column          | Description                         |
| --------------- | ----------------------------------- |
| `customer_id`   | Unique identifier for each customer |
| `customer_name` | Customer's name                     |
| `city`          | Customer's city                     |

**Primary Key:** `customer_id`

---

### 2. `orders`

Stores transaction-level information.

| Column        | Description                                 |
| ------------- | ------------------------------------------- |
| `order_id`    | Unique identifier for each order            |
| `customer_id` | Customer associated with the order          |
| `product_id`  | Product associated with the order           |
| `amount`      | Revenue/value of the order                  |
| `status`      | Order status such as Completed or Cancelled |
| `order_date`  | Date on which the order was placed          |

**Primary Key:** `order_id`

**Foreign Keys:**

* `customer_id` → `customers.customer_id`
* `product_id` → `products.product_id`

---

### 3. `products`

Stores product-level information.

| Column         | Description                        |
| -------------- | ---------------------------------- |
| `product_id`   | Unique identifier for each product |
| `product_name` | Product name                       |
| `category`     | Product category                   |
| `price`        | Product price                      |

**Primary Key:** `product_id`

---

# Table Relationships

The database follows a simple relational structure:

```text
CUSTOMERS
   │
   │ customer_id
   ▼
ORDERS
   │
   │ product_id
   ▼
PRODUCTS
```

The important relationships are:

```sql
customers.customer_id = orders.customer_id

orders.product_id = products.product_id
```

These relationships allow customer, transaction, and product information to be analyzed together.

---

# Business Questions — Q1 to Q5

## Q1 — Customers Above Average Total Spending

Identify customers whose **total spending is greater than the average customer spending**.

### Business Purpose

This helps identify customers who contribute more revenue than the typical customer.

### SQL Concepts

* `JOIN`
* `GROUP BY`
* `SUM()`
* Subquery
* `AVG()`
* Aggregate-level comparison
* `HAVING`

### Key Learning

The important concept here is that the comparison is not between individual orders and an average order.

Instead:

```text
Orders
   ↓
Customer-level total spending
   ↓
Average of customer-level spending
   ↓
Compare each customer against that benchmark
```

This introduces the concept of **aggregation followed by benchmarking**.

---

## Q2 — Products Above Average Total Sales

Identify products whose **total sales are greater than the average product sales**.

### Business Purpose

This helps determine which products are generating sales above the overall product-level benchmark.

### SQL Concepts

* `JOIN`
* `GROUP BY`
* `SUM()`
* Subqueries
* `AVG()`
* `HAVING`
* Product-level aggregation

### Key Learning

This question reinforces an important analytical pattern:

> **Calculate a metric at entity level → calculate the average of that metric → compare entities against the benchmark.**

The entity in this case is the **product**.

---

## Q3 — Customers Above Average Completed-Order Count

Identify customers whose number of **Completed orders is greater than the average completed-order count**.

### Business Purpose

Revenue alone does not tell the complete story.

A customer may have high spending because of one expensive purchase, while another customer may place many smaller orders.

This question therefore focuses on **order frequency**.

### SQL Concepts

* `JOIN`
* Conditional filtering
* `COUNT()`
* `GROUP BY`
* Subqueries
* `AVG()`
* `HAVING`
* Completed-order analysis

### Key Learning

This question develops the ability to create metrics based on a specific business condition:

```sql
status = 'Completed'
```

It also reinforces the difference between:

* Total orders
* Completed orders
* Order frequency
* Average order count

---

## Q4 — Cities Above Average Completed Revenue

Identify cities whose **completed-order revenue is greater than the average completed revenue across cities**.

### Business Purpose

This allows the business to understand geographic revenue performance.

Instead of analyzing customers individually, the analysis is performed at the **city level**.

### SQL Concepts

* `JOIN`
* Conditional aggregation
* `CASE`
* `SUM()`
* `GROUP BY`
* Subqueries
* `AVG()`
* `HAVING`
* Revenue analysis

### Key Learning

This question combines several SQL techniques to create a business metric:

```text
City
  ↓
Completed orders
  ↓
Completed revenue
  ↓
Average city revenue
  ↓
Compare cities against benchmark
```

This is an important step toward **business-level analytical SQL**.

---

## Q5 — Products Above Average Cancellation Rate

Identify products whose **cancellation rate is greater than the average product cancellation rate**.

The analysis considers:

* Total orders
* Cancelled orders
* Cancellation rate

### Business Purpose

High sales do not necessarily mean healthy business performance.

A product may generate substantial orders while also experiencing a high cancellation rate.

This question therefore introduces **quality/risk metrics alongside volume metrics**.

### SQL Concepts

* `JOIN`
* `COUNT()`
* `SUM()`
* Conditional aggregation
* `CASE`
* `GROUP BY`
* Percentage calculation
* Subqueries
* `AVG()`
* `HAVING`
* Business-risk classification logic

### Cancellation Rate

The basic metric is:

```text
Cancellation Rate =
Cancelled Orders / Total Orders × 100
```

The important analytical challenge is that the average should be calculated from **product-level cancellation rates**, rather than simply dividing total cancelled orders by total orders across the entire database.

This distinction is important in real-world analytics.

---

# SQL Techniques Being Practiced

## 1. JOINs

Used to combine information from related tables.

Examples:

```sql
customers
JOIN orders
```

and

```sql
orders
JOIN products
```

This develops the ability to work with relational databases rather than analyzing isolated tables.

---

## 2. GROUP BY

Used to aggregate data at the required business level.

Examples:

```text
GROUP BY customer
GROUP BY product
GROUP BY city
```

The key skill is choosing the **correct level of aggregation** for the business question.

---

## 3. Aggregate Functions

The exercise uses functions such as:

```sql
SUM()
COUNT()
AVG()
```

These are fundamental for calculating:

* Revenue
* Number of orders
* Completed orders
* Cancelled orders
* Average performance

---

## 4. CASE Expressions

`CASE` allows SQL to perform conditional business logic.

For example:

```sql
CASE
    WHEN status = 'Cancelled' THEN 1
    ELSE 0
END
```

This enables conditional metrics such as cancelled-order counts and cancellation rates.

---

## 5. HAVING

`HAVING` is used to filter **aggregated results**.

For example, after calculating total spending for every customer, `HAVING` can be used to retain only customers whose spending exceeds a benchmark.

This reinforces the distinction between:

```text
WHERE  → filters rows before aggregation

HAVING → filters groups after aggregation
```

---

## 6. Subqueries

Subqueries are particularly important in Q1–Q5.

They allow the query to calculate a dynamic benchmark such as:

```text
Average customer spending
Average product sales
Average completed orders
Average city revenue
Average product cancellation rate
```

The result of the subquery then becomes the benchmark against which individual entities are compared.

---

# Analytical Pattern Being Mastered

A major pattern repeated throughout Q1–Q5 is:

```text
Raw Data
   ↓
JOIN related tables
   ↓
Filter relevant records
   ↓
GROUP BY business entity
   ↓
Calculate metric
   ↓
Calculate benchmark
   ↓
Compare entity against benchmark
   ↓
Identify above/below-average performance
```

This is more important than memorizing individual queries because the same pattern can be applied to many business problems.

---

# What I Am Learning / Mastering

Through this checkpoint, I am strengthening the following SQL and analytical skills:

### SQL Skills

* Writing multi-table queries
* INNER JOIN
* Understanding primary and foreign-key relationships
* `GROUP BY`
* `SUM()`
* `COUNT()`
* `AVG()`
* `CASE`
* Conditional aggregation
* `HAVING`
* Nested subqueries
* Aggregate comparisons
* Percentage calculations

### Analytical Skills

* Customer-level analysis
* Product-level analysis
* City-level analysis
* Revenue analysis
* Order-frequency analysis
* Cancellation analysis
* Benchmarking
* Performance comparison
* Business-metric construction
* Translating business questions into SQL

---

# Business Analytics Perspective

The purpose of these exercises goes beyond SQL syntax.

The same techniques can be applied to real business datasets to answer questions such as:

* Which customers are high-value?
* Which products drive revenue?
* Which markets perform above average?
* Where are cancellations concentrated?
* Which customer segments have unusual behavior?
* Which products require further investigation?

This builds the foundation for moving from:

> **"I know SQL."**

to:

> **"I can use SQL to investigate a business problem."**

---

# Project Goal

The long-term goal of this SQL practice is to develop **job-ready analytical SQL proficiency**.

The focus is not only on getting the correct output, but also on understanding:

1. **Why the query works**
2. **Why a particular JOIN is required**
3. **Why aggregation is performed at a specific level**
4. **How business metrics are calculated**
5. **How subqueries create dynamic benchmarks**
6. **How SQL results can be interpreted from a business perspective**

This checkpoint is therefore part of a broader progression from **SQL fundamentals → analytical SQL → real-world business problem solving**.

---

## Connect With Me

**LinkedIn:** www.linkedin.com/in/shorya-bisht-a20144349
