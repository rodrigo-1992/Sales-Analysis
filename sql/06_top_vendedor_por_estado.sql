-- Melhor vendedor por estado (RANK particionado por estado)
WITH receita_vendedores AS (
    SELECT  s.seller_id,
            s.seller_state,
            ROUND(SUM(i.total_value), 2) AS receita
    FROM order_items i
    LEFT JOIN sellers s ON i.seller_id = s.seller_id
    GROUP BY s.seller_id, s.seller_state
),
ranked AS (
    SELECT *, RANK() OVER (PARTITION BY seller_state ORDER BY receita DESC) AS pos
    FROM receita_vendedores
)
SELECT seller_id, seller_state, receita, pos
FROM ranked
WHERE pos = 1
ORDER BY receita DESC;