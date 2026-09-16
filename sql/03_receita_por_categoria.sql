-- Receita por categoria de produto (Top 10)
WITH receita_por_categoria AS (
    SELECT  pr.product_category_name AS categoria,
            ROUND(SUM(i.total_value), 2) AS receita,
            COUNT(DISTINCT i.order_id) AS pedidos
    FROM order_items i
    LEFT JOIN products pr ON i.product_id = pr.product_id
    GROUP BY pr.product_category_name
)
SELECT  categoria,
        receita,
        ROUND(receita / pedidos, 2) AS ticket_medio_categoria
FROM receita_por_categoria
ORDER BY receita DESC
LIMIT 10;