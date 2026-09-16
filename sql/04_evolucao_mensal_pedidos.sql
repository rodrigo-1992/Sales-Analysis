-- Evolução mensal dos pedidos com variação percentual (função de janela LAG)
WITH pedidos_mensais AS (
    SELECT  strftime('%Y-%m', order_purchase_timestamp) AS mes,
            COUNT(*) AS pedidos
    FROM orders
    GROUP BY strftime('%Y-%m', order_purchase_timestamp)
)
SELECT  mes,
        pedidos,
        LAG(pedidos) OVER (ORDER BY mes) AS pedidos_anteriores,
        pedidos - LAG(pedidos) OVER (ORDER BY mes) AS variacao,
        ROUND(100.0 * (pedidos - LAG(pedidos) OVER (ORDER BY mes)) /
        LAG(pedidos) OVER (ORDER BY mes), 2) AS variacao_pct
FROM pedidos_mensais
ORDER BY mes;