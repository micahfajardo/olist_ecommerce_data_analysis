
/* Sellers Analytics: Contain query that ranks the seller by total revenue and review score. 
*/
CREATE OR REPLACE VIEW seller_table AS
WITH SellerPerformance AS (
    SELECT
        s.seller_city,
        s.seller_state,
        s.seller_id,
        SUM(op.payment_value) AS total_revenue,
        AVG(orv.review_score) AS avg_review_score,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        MAX(DATE (o.order_purchase_timestamp)) AS latest_order_date
    FROM sellers s
    JOIN order_items oi ON s.seller_id = oi.seller_id
    JOIN order_info o ON oi.order_id = o.order_id
    JOIN order_payments op ON o.order_id = op.order_id
    LEFT JOIN order_reviews orv ON o.order_id = orv.order_id
    WHERE o.order_status IN ('shipped', 'delivered')
    GROUP BY s.seller_id, s.seller_city, s.seller_state
)
SELECT 
    seller_city,
    seller_state,
    seller_id,
    total_revenue,
    avg_review_score,
    total_orders,
    latest_order_date,
    -- Rank by revenue
    RANK() OVER (ORDER BY total_revenue DESC) as revenue_rank,
    -- Rank by score
    RANK() OVER (ORDER BY avg_review_score DESC) as review_score_rank
FROM SellerPerformance;