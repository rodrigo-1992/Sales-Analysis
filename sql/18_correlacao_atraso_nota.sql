-- Satisfação: correlação de Pearson entre atraso (dias) e nota da avaliação
WITH entregas AS (
    SELECT  o.order_id,
            CAST(julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date) AS INTEGER) AS atraso_dias
    FROM orders o
    WHERE o.order_delivered_customer_date IS NOT NULL
)
SELECT  ROUND(
            (SUM(e.atraso_dias * r.review_score) - SUM(e.atraso_dias) * SUM(r.review_score) / COUNT(*)) /
            (SQRT(SUM(e.atraso_dias * e.atraso_dias) - SUM(e.atraso_dias) * SUM(e.atraso_dias) / COUNT(*)) *
             SQRT(SUM(r.review_score * r.review_score) - SUM(r.review_score) * SUM(r.review_score) / COUNT(*))),
            4) AS correlacao_atraso_nota,
        COUNT(*) AS n_avaliacoes
FROM entregas e
JOIN order_reviews r ON e.order_id = r.order_id
WHERE r.review_score IS NOT NULL;