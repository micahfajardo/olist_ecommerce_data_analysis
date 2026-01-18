/*
--------------------------------------------------------------------------------
 CUSTOMER ANALYTICS MASTER VIEW
 This view handles segmentation, geography, purchase date, and payment behavior according to customers for Tableau interactive dashboard.
---------------------------------------------------------------------------------
*/

CREATE OR REPLACE VIEW dashboard_customer_analytics AS
WITH customer_stats AS (
    -- Aggregate data by unique customer
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(p.payment_value) AS total_monetary,
        -- Recency: Days since the last order in the entire dataset
        DATEDIFF('2018-09-03', MAX(o.order_purchase_timestamp)) AS recency
    FROM customers AS c
    INNER JOIN order_info AS o ON c.customer_id = o.customer_id
    INNER JOIN order_payments AS p ON o.order_id = p.order_id
    WHERE o.order_status IN ('delivered', 'shipped')
    GROUP BY c.customer_unique_id
),
-- determines the distribution of the data on frequncy and budget
quartiles AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY frequency ASC) AS f_score,   -- 4 is most frequent
        NTILE(4) OVER (ORDER BY total_monetary ASC) AS m_score -- 4 is highest spender
    FROM customer_stats
),
segments AS (
    SELECT *,
        CASE 
            WHEN f_score >= 3 AND m_score >= 3 THEN 'Loyal Premium Customers'  -- High F, High M
            WHEN f_score >= 3 AND m_score < 3 THEN 'Loyal Low-Budget Customers'      -- High F, Low M
            WHEN f_score < 3 AND m_score >= 3 THEN 'Premium One-time Buyers'      -- Low F, High M
            ELSE 'Low-Value One-time Buyers' -- Low F, Low M                
        END AS customer_segment
    FROM quartiles
)
-- Shows final table that summarizes customer and order information for Tableau interactivity
SELECT 
    o.order_id,
    o.order_purchase_timestamp,
    DATE(o.order_purchase_timestamp) AS order_day,
    o.order_status,
    c.customer_city,
    c.customer_state,
    p.payment_type,
    p.payment_installments,
    p.payment_value,
    s.customer_unique_id,
    s.customer_segment,
    s.recency,
    s.frequency AS total_customer_orders,
    s.total_monetary,
    s.f_score,
    s.m_score,
    CASE WHEN s.frequency > 1 THEN 'Returning' ELSE 'New' END AS customer_type
FROM order_info AS o
INNER JOIN order_payments AS p ON o.order_id = p.order_id
INNER JOIN customers AS c ON o.customer_id = c.customer_id
INNER JOIN segments AS s ON c.customer_unique_id = s.customer_unique_id
WHERE o.order_status IN ('delivered', 'shipped');
