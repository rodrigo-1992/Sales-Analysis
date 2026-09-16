-- Visão geral dos pedidos por status
SELECT  order_status,
        COUNT(DISTINCT order_id) AS pedidos
FROM orders
GROUP BY order_status
ORDER BY pedidos DESC;