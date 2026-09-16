-- Satisfação: nota média da avaliação por faixa de atraso de entrega
WITH entregas AS (
    SELECT  o.order_id,
            CAST(julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date) AS INTEGER) AS atraso_dias
    FROM orders o
    WHERE o.order_delivered_customer_date IS NOT NULL
),
faixas AS (
    SELECT  r.review_score,
            CASE
                WHEN e.atraso_dias <= 0 THEN 'No prazo'
                WHEN e.atraso_dias <= 3 THEN 'Atraso 1-3 dias'
                WHEN e.atraso_dias <= 10 THEN 'Atraso 4-10 dias'
                ELSE 'Atraso > 10 dias'
            END AS faixa_atraso
    FROM entregas e
    LEFT JOIN order_reviews r ON e.order_id = r.order_id
    WHERE r.review_score IS NOT NULL
)
SELECT  faixa_atraso,
        COUNT(*) AS pedidos,
        ROUND(AVG(review_score), 2) AS nota_media,
        ROUND(MIN(review_score), 2) AS nota_min,
        ROUND(MAX(review_score), 2) AS nota_max
FROM faixas
GROUP BY faixa_atraso
ORDER BY nota_media DESC;