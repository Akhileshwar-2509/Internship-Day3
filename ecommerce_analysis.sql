-- ----------------------------------------
-- DROP TABLES (In correct order)
-- ----------------------------------------
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- ----------------------------------------
-- CREATE TABLES
-- ----------------------------------------

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

-- ----------------------------------------
-- INSERT SAMPLE DATA
-- ----------------------------------------

INSERT INTO customers (name, email, country) VALUES
('Alice Johnson', 'alice@example.com', 'USA'),
('Bob Smith', 'bob@example.com', 'Canada'),
('Charlie Lee', 'charlie@example.com', 'India');

INSERT INTO products (name, category, price) VALUES
('Laptop', 'Electronics', 800.00),
('Headphones', 'Accessories', 150.00),
('Smartphone', 'Electronics', 600.00);

INSERT INTO orders (customer_id, product_id, order_date, quantity, order_amount) VALUES
(1, 1, '2024-01-15', 1, 800.00),
(2, 3, '2024-02-20', 2, 1200.00),
(3, 2, '2024-03-10', 1, 150.00);

-- ----------------------------------------
-- SAMPLE ANALYSIS QUERIES
-- ----------------------------------------

-- 1. Customers from India
SELECT * FROM customers WHERE country = 'India';

-- 2. Total and average order amount
SELECT 
    SUM(order_amount) AS total_sales, 
    AVG(order_amount) AS avg_order_value
FROM orders;

-- 3. Order count per customer
SELECT 
    customer_id, 
    COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id;

-- 4. INNER JOIN: Customer orders with product info
SELECT 
    c.name AS customer_name, 
    p.name AS product_name, 
    o.order_date, 
    o.quantity, 
    o.order_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN products p ON o.product_id = p.product_id;

-- 5. Subquery: Customers with above-average order amount
SELECT name FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING AVG(order_amount) > (
        SELECT AVG(order_amount) FROM orders
    )
);

-- 6. Create View: Summary
CREATE OR REPLACE VIEW customer_order_summary AS
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.order_amount) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- View the summary
SELECT * FROM customer_order_summary;

-- 7. Create index on orders
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
