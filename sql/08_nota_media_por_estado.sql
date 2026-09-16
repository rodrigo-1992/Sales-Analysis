-- Nota média das avaliações por estado do cliente (mínimo de 30 avaliações)
SELECT  c.customer_state AS estado,
        ROUND(AVG(r.review_score), 2) AS nota_media,
        COUNT(DISTINCT r.review_id) AS avaliacoes
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id
GROUP BY c.customer_state
HAVING avaliacoes >= 30
ORDER BY nota_media DESC;