-- Vendas por região: receita por estado do cliente
SELECT  c.customer_state AS estado,
        COUNT(DISTINCT o.order_id) AS pedidos,
        ROUND(COALESCE(SUM(p.payment_value), 0), 2) AS receita
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY receita DESC;