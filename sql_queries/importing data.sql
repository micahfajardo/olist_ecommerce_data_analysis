/*
--------------------------------------------------------------------------------
 This query quickly imports large datasets into mysql through local infile
---------------------------------------------------------------------------------
*/
SET GLOBAL local_infile = 1;
create database olist_data;
USE olist_data;

-- Create tables for the olist_data database
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);
CREATE TABLE order_info (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME, 
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);
CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);
CREATE TABLE order_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT
);
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_dimension_cm3 INT
);
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

-- Load csv files to the tables in sql
LOAD DATA LOCAL INFILE 'C:/Users/user/Documents/Data Science Trainings/Brazillian E-commerce/for sql import/customers_updated.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Documents/Data Science Trainings/Brazillian E-commerce/for sql import/olist_orders_dataset.csv'
INTO TABLE order_info
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status, @v_purch, @v_appr, @v_carr, @v_cust, @v_est)
SET -- turns empty strings to null values
    order_purchase_timestamp = NULLIF(@v_purch, ''),
    order_approved_at = NULLIF(@v_appr, ''),
    order_delivered_carrier_date = NULLIF(@v_carr, ''),
    order_delivered_customer_date = NULLIF(@v_cust, ''),
    order_estimated_delivery_date = NULLIF(@v_est, '');

LOAD DATA LOCAL INFILE 'C:/Users/user/Documents/Data Science Trainings/Brazillian E-commerce/for sql import/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, order_item_id, product_id, seller_id, @v_shipping_limit, price, freight_value)
SET -- turns empty strings to null values
    shipping_limit_date = NULLIF(@v_shipping_limit, '');

LOAD DATA LOCAL INFILE 'C:/Users/user/Documents/Data Science Trainings/Brazillian E-commerce/for sql import/olist_order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Documents/Data Science Trainings/Brazillian E-commerce/for sql import/order_reviews_updated.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Documents/Data Science Trainings/Brazillian E-commerce/for sql import/products_updated.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/Documents/Data Science Trainings/Brazillian E-commerce/for sql import/sellers_updated.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

