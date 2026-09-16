-- Sazonalidade: pedidos por dia da semana
SELECT  dia_semana,
        pedidos,
        ROUND(100.0 * pedidos / SUM(pedidos) OVER (), 2) AS pct_pedidos
FROM (
    SELECT  order_purchase_weekday AS dia_semana,
            COUNT(*) AS pedidos
    FROM orders
    WHERE order_status = 'delivered'
    GROUP BY order_purchase_weekday
)
ORDER BY pedidos DESC;