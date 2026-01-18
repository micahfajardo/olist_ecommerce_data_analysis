
/* Logistics Efficiency Analytics: contain queries used to report the logistics efficiency of the orders 
and report peak hours and peak days to be used to improve logistics efficiency
*/

-- Query that list how many days it take from order of purchase to delivery day
CREATE OR REPLACE VIEW logistics_efficiency AS
SELECT 
    o.order_id,
    o.customer_id,
    o.order_status,
    DATEDIFF(order_approved_at, order_purchase_timestamp) AS days_to_approve,
    DATEDIFF(order_delivered_carrier_date, order_approved_at) AS days_to_carrier,
    DATEDIFF(order_delivered_customer_date, order_delivered_carrier_date) AS transit_days,
    DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) AS actual_delivery_days,
    DATEDIFF(order_estimated_delivery_date, order_purchase_timestamp) AS estimated_delivery_days,
    CASE 
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On-Time'
        ELSE 'Late'
    END AS delivery_status,
    DATEDIFF(order_delivered_carrier_date, shipping_limit_date) AS seller_delay_days,
    CASE 
        WHEN order_delivered_carrier_date <= shipping_limit_date THEN 'On-Time'
        ELSE 'Late'
    END AS seller_shipping_status
FROM order_info o
-- Subquery to join rows of multiple items from one order
LEFT JOIN (
    SELECT order_id, MAX(shipping_limit_date) as shipping_limit_date
    FROM order_items
    GROUP BY order_id
) i ON o.order_id = i.order_id
WHERE order_status = 'delivered';

CREATE OR REPLACE VIEW peak_seasons AS
-- Query for peak hours and days
SELECT 
    -- extract hour when order is made
    HOUR(order_purchase_timestamp) AS purchase_hour,
      -- extract day of the week when order is made
    DAYNAME(order_purchase_timestamp) AS purchase_day,
    COUNT(o.order_id) AS total_orders
FROM order_info o
LEFT JOIN order_payments p ON o.order_id = p.order_id
GROUP BY purchase_hour, purchase_day
ORDER BY purchase_hour;