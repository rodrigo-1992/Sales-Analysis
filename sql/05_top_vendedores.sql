-- Ranking dos maiores vendedores por receita (RANK)
WITH receita_vendedores AS (
    SELECT  s.seller_id,
            s.seller_state,
            ROUND(SUM(i.total_value), 2) AS receita
    FROM order_items i
    LEFT JOIN sellers s ON i.seller_id = s.seller_id
    GROUP BY s.seller_id, s.seller_state
)
SELECT  seller_id,
        seller_state,
        receita,
        RANK() OVER (ORDER BY receita DESC) AS rank
FROM receita_vendedores
ORDER BY rank
LIMIT 10;