# Internship-Day3
# 🧠 Internship Day 3 — SQL for Data Analysis using PostgreSQL

This project contains SQL queries and outputs for analyzing a sample **E-commerce dataset** using PostgreSQL. It covers table creation, data insertion, and SQL-based data analysis using joins, aggregates, subqueries, views, and indexing.

---

## 📁 Files Included

- `ecommerce_analysis.sql` – Contains SQL code for table creation, inserts, and analysis queries.
- Output screenshots – Provided below for each step.

---

## 📦 1. Create Tables

```sql
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10, 2)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    order_date DATE,
    quantity INT,
    order_amount NUMERIC(10, 2)
);
```
[![Create Tables](https://github.com/Akhileshwar-2509/Internship-Day3/blob/main/Screenshot%202025-04-10%20113230.png)]

```sql

-- Insert into customers
INSERT INTO customers (name, email, country) VALUES
('Alice Johnson', 'alice@example.com', 'USA'),
('Bob Smith', 'bob@example.com', 'Canada'),
('Charlie Lee', 'charlie@example.com', 'India');

-- Insert into products
INSERT INTO products (name, category, price) VALUES
('Laptop', 'Electronics', 800.00),
('Headphones', 'Accessories', 150.00),
('Smartphone', 'Electronics', 600.00);

-- Insert into orders
INSERT INTO orders (customer_id, product_id, order_date, quantity, order_amount) VALUES
(1, 1, '2024-01-15', 1, 800.00),
(2, 3, '2024-02-20', 2, 1200.00),
(3, 2, '2024-03-10', 1, 150.00);
```
[![Insert Values](https://github.com/Akhileshwar-2509/Internship-Day3/blob/main/Screenshot%202025-04-10%20113249.png)]


🔍 Question 1: List customers from India
```sql

SELECT * FROM customers WHERE country = 'India';

```
[![Question 1](https://github.com/Akhileshwar-2509/Internship-Day3/blob/main/Screenshot%202025-04-10%20113308.png)]

📊 Question 2: Total & Average Order Amount
```sql
SELECT 
    SUM(order_amount) AS total_sales, 
    AVG(order_amount) AS avg_order_value
FROM orders;
```
[![Question 2](https://github.com/Akhileshwar-2509/Internship-Day3/blob/main/Screenshot%202025-04-10%20113322.png)]


📦 Question 3: Number of Orders Per Customer
```sql
SELECT 
    customer_id, 
    COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id;
```
[![Question 3](https://github.com/Akhileshwar-2509/Internship-Day3/blob/main/Screenshot%202025-04-10%20113334.png)]


🔗 Question 4: Join Customers, Orders, Products
```sql
SELECT 
    c.name AS customer_name, 
    p.name AS product_name, 
    o.order_date, 
    o.quantity, 
    o.order_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id;
```
[![Question 4](https://github.com/Akhileshwar-2509/Internship-Day3/blob/main/Screenshot%202025-04-10%20113347.png)]

📈 Question 5: Customers with Above-Average Orders
```sql
SELECT name FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING AVG(order_amount) > (
        SELECT AVG(order_amount) FROM orders
    )
);
```
[![Question 5](https://github.com/Akhileshwar-2509/Internship-Day3/blob/main/Screenshot%202025-04-10%20113359.png)]

🪟 Question 6: Create View for Summary
```sql
CREATE OR REPLACE VIEW customer_order_summary AS
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.order_amount) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

SELECT * FROM customer_order_summary;
```
[![Question 6](https://github.com/Akhileshwar-2509/Internship-Day3/blob/main/Screenshot%202025-04-10%20113414.png)]


⚡ Question 7: Index for Query Optimization
```sql
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
```

[![Question 7](https://github.com/Akhileshwar-2509/Internship-Day3/blob/main/Screenshot%202025-04-10%20113427.png)]

🧠 Summary
In this project, we:

Designed and populated a PostgreSQL e-commerce database.

Analyzed data using SQL queries.

Used views, subqueries, aggregate functions, and indexing.

Practiced real-world data extraction and reporting.