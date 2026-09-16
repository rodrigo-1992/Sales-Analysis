-- Percentual de entregas no prazo por categoria (mínimo de 50 pedidos)
WITH entregas AS (
    SELECT  o.order_id,
            CASE WHEN date(o.order_delivered_customer_date) <= date(o.order_estimated_delivery_date)
            THEN 1 ELSE 0
            END AS no_prazo
    FROM orders o
    WHERE o.order_delivered_customer_date IS NOT NULL
)
SELECT  pr.product_category_name AS categoria,
        COUNT(DISTINCT e.order_id) AS pedidos,
        ROUND(100.0 * COUNT(DISTINCT CASE WHEN e.no_prazo = 1 THEN e.order_id END) /
            COUNT(DISTINCT e.order_id), 2) AS pct_no_prazo
FROM entregas e
JOIN order_items i ON e.order_id = i.order_id
LEFT JOIN products pr ON i.product_id = pr.product_id
WHERE pr.product_category_name IS NOT NULL
GROUP BY pr.product_category_name
HAVING pedidos >= 50
ORDER BY pct_no_prazo DESC
LIMIT 10;