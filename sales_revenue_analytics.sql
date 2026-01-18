/*
--------------------------------------------------------------------------------
 SALES AND REVENUE ANALYTICS 
 These views handle sales and revenue per product category, state,and year for Tableau interactive dashboard. This also includes
 forecasted sales and revenue for the next 12 months. 
---------------------------------------------------------------------------------
*/
CREATE OR REPLACE VIEW sales_revenue_table AS
SELECT 
    DATE(o.order_purchase_timestamp) AS order_date,
    o.order_id,
    p.product_id,
    p.product_category_name,
    c.customer_city,
    c.customer_state,
    o.order_status,
    SUM(oi.price) AS total_revenue,-- Revenue per order
    COUNT(oi.order_item_id) AS units_sold-- Counts unit sold per order
FROM order_info o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE p.product_category_name IS NOT NULL 
  AND o.order_status IN ('delivered', 'shipped')
GROUP BY 
    o.order_id, product_id
ORDER BY total_revenue DESC, units_sold DESC;
 
 -- Query for daily sales and revenue per product category
CREATE OR REPLACE VIEW daily_sales_revenue AS
SELECT 
    DATE(o.order_purchase_timestamp) AS order_date,
    p.product_category_name,
     -- Total Revenue per day
    SUM(oi.price + oi.freight_value) AS total_revenue,
    -- Total Sales per day
    COUNT(oi.order_item_id) AS total_units_sold,
    -- Total orders per day 
    COUNT(DISTINCT o.order_id) AS order_volume
FROM ORDER_INFO o
JOIN ORDER_ITEMS oi ON o.order_id = oi.order_id
JOIN PRODUCTS p ON oi.product_id = p.product_id
WHERE o.order_status IN ('delivered', 'shipped')
GROUP BY order_date, p.product_category_name
ORDER BY order_date DESC;

-- Query for total orders and cancelled orders
CREATE OR REPLACE VIEW cancellation_rate AS
SELECT 
    DATE(order_purchase_timestamp) AS order_date, 
    COUNT(order_id) AS total_orders,
    SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) AS canceled_orders,
    (SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END)*100/COUNT(order_id)) as rate
FROM order_info
GROUP BY order_date
ORDER BY order_date DESC;

