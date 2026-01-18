/*
--------------------------------------------------------------------------------
 CUSTOMER ANALYTICS MASTER VIEW
 This view handles segmentation, geography, purchase date, and payment behavior according to customers for Tableau interactive dashboard.
---------------------------------------------------------------------------------
*/

CREATE OR REPLACE VIEW dashboard_customer_analytics AS
WITH customer_stats AS (
    -- Aggregate customer and order tables according to unique customer for segmentation
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS frequency,
        AVG(p.payment_value) AS avg_budget,
        -- Recency: Days since the last order in the entire dataset
        DATEDIFF('2018-09-03', MAX(o.order_purchase_timestamp)) AS recency
    FROM customers AS c
    INNER JOIN order_info AS o ON c.customer_id = o.customer_id
    INNER JOIN order_payments AS p ON o.order_id = p.order_id
    WHERE o.order_status IN ('delivered', 'shipped') -- only customers with successful orders and payments
    GROUP BY c.customer_unique_id
),
segments AS (
    -- customer segmentaion according to frequency and average budget
    SELECT 
        customer_unique_id,
        recency,
        frequency,
        avg_budget,
        CASE 
            WHEN frequency > 3 AND avg_budget >= 150 THEN 'Premium Customers' -- High F, High B
            WHEN frequency > 3 AND avg_budget < 150 THEN 'Loyal Customers' -- High F, Low B
            WHEN frequency = 1 AND avg_budget >= 150 THEN 'High-Value Prospect Customers' -- Low F, High B
            WHEN frequency = 1 AND avg_budget BETWEEN 50 AND 149 THEN 'Standard Prospect' -- Low F, Moderate B
            ELSE 'Low-Value/One-Time Customers' -- Low F, Low B
        END AS customer_segment
    FROM customer_stats
)
-- Shows final table that summarizes customer and order information for Tableau interactivity
SELECT 
    o.order_id,
    o.order_purchase_timestamp,
    DATE(o.order_purchase_timestamp) AS order_day,
    o.order_status,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    p.payment_type,
    p.payment_installments,
    p.payment_value,
    s.customer_segment,
    s.recency,
    s.frequency AS total_customer_orders,
    -- Label Customers as New or Returning
    CASE WHEN s.frequency > 1 THEN 'Returning' ELSE 'New' END AS purchase_type
FROM order_info AS o
INNER JOIN order_payments AS p ON o.order_id = p.order_id
INNER JOIN customers AS c ON o.customer_id = c.customer_id
INNER JOIN segments AS s ON c.customer_unique_id = s.customer_unique_id
WHERE o.order_status IN ('delivered', 'shipped');
