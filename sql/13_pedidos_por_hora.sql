-- Sazonalidade: pedidos por hora do dia
SELECT  hora,
        pedidos,
        ROUND(100.0 * pedidos / SUM(pedidos) OVER (), 2) AS pct_pedidos
FROM (
    SELECT  order_purchase_hour AS hora,
            COUNT(*) AS pedidos
    FROM orders
    WHERE order_status = 'delivered'
    GROUP BY order_purchase_hour
)
ORDER BY hora;