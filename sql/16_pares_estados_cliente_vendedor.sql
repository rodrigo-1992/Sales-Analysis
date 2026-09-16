-- Vendas por região: principais pares cliente (estado) x vendedor (estado)
SELECT  c.customer_state AS estado_cliente,
        s.seller_state AS estado_vendedor,
        COUNT(DISTINCT i.order_id) AS pedidos,
        ROUND(COALESCE(SUM(i.total_value), 0), 2) AS receita
FROM order_items i
JOIN orders o ON i.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN sellers s ON i.seller_id = s.seller_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state, s.seller_state
ORDER BY receita DESC
LIMIT 15;