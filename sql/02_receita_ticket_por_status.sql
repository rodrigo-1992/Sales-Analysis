-- Receita e ticket médio por status do pedido
SELECT  o.order_status,
        COUNT(DISTINCT o.order_id) AS pedidos,
        ROUND(SUM(p.payment_value), 2) AS receita_total,
        ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS ticket_medio
FROM orders o
LEFT JOIN order_payments p ON o.order_id = p.order_id
GROUP BY o.order_status
ORDER BY receita_total DESC;