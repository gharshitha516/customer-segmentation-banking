DROP DATABASE IF EXISTS customer_segmentation;
CREATE DATABASE customer_segmentation;
USE customer_segmentation;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    city VARCHAR(50),
    account_type VARCHAR(20),
    tenure_years INT
);
CREATE TABLE products (
    customer_id INT PRIMARY KEY,
    credit_card ENUM('Y','N'),
    loan_amount DECIMAL(12,2),
    insurance ENUM('Y','N'),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE transactions (
    txn_id INT PRIMARY KEY,
    customer_id INT,
    txn_date DATE,
    amount DECIMAL(12,2),
    category VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
SHOW TABLES;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM customers;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM products;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM transactions;

SELECT 
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM transactions) AS total_transactions;

SELECT 
    MIN(age) AS youngest_customer,
    MAX(age) AS oldest_customer,
    ROUND(AVG(age), 1) AS avg_age
FROM customers;

SELECT 
    city,
    COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

SELECT 
    credit_card,
    COUNT(*) AS customer_count
FROM products
GROUP BY credit_card;

SELECT 
    customer_id,
    SUM(amount) AS total_spend,
    COUNT(*) AS txn_count
FROM transactions
GROUP BY customer_id
ORDER BY total_spend DESC;

SELECT 
    category,
    SUM(amount) AS total_spend
FROM transactions
GROUP BY category
ORDER BY total_spend DESC;

SELECT
    customer_id,
    total_spend,
    CASE
        WHEN total_spend >= 235000 THEN 'High Value'
        WHEN total_spend >= 117750 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS segment
FROM (
    SELECT customer_id, SUM(amount) AS total_spend
    FROM transactions
    GROUP BY customer_id
) t
ORDER BY total_spend DESC;

SELECT 
    customer_id,
    COUNT(*) AS txn_count,
    SUM(amount) AS total_spend
FROM transactions
GROUP BY customer_id
HAVING COUNT(*) > 10
ORDER BY total_spend DESC;

SELECT 
    customer_id,
    total_spend,
    RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
FROM (
    SELECT customer_id, SUM(amount) AS total_spend
    FROM transactions
    GROUP BY customer_id
) t;






