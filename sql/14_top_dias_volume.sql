-- Sazonalidade: top dias de maior volume de pedidos (picos)
SELECT  date(order_purchase_timestamp) AS dia,
        order_purchase_weekday AS dia_semana,
        COUNT(*) AS pedidos
FROM orders
WHERE order_status = 'delivered'
GROUP BY date(order_purchase_timestamp)
ORDER BY pedidos DESC
LIMIT 10;