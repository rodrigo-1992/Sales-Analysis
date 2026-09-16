-- Resumo dos segmentos RFM (Recência x Valor monetário)
WITH base AS (
    SELECT  o.customer_id,
            MAX(o.order_purchase_timestamp) AS ultima_compra,
            COUNT(DISTINCT o.order_id) AS frequencia,
            ROUND(COALESCE(SUM(p.payment_value), 0), 2) AS monetario
    FROM orders o
    LEFT JOIN order_payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY o.customer_id
),
referencia AS (
    SELECT MAX(ultima_compra) AS data_ref FROM base
),
rfm AS (
    SELECT  b.customer_id,
            CAST(julianday(r.data_ref) - julianday(b.ultima_compra) AS INTEGER) AS recencia_dias,
            b.frequencia,
            b.monetario
    FROM base b
    CROSS JOIN referencia r
),
segmentos AS (
    SELECT  customer_id,
            frequencia,
            monetario,
            CASE WHEN recencia_dias <= 30 THEN 4
                 WHEN recencia_dias <= 90 THEN 3
                 WHEN recencia_dias <= 180 THEN 2
                 ELSE 1 END AS score_r,
            CASE WHEN frequencia >= 5 THEN 4
                 WHEN frequencia >= 3 THEN 3
                 WHEN frequencia >= 2 THEN 2
                 ELSE 1 END AS score_f,
            CASE WHEN monetario >= 1000 THEN 4
                 WHEN monetario >= 300 THEN 3
                 WHEN monetario >= 100 THEN 2
                 ELSE 1 END AS score_m
    FROM rfm
)
SELECT  segmento,
        clientes,
        ROUND(100.0 * clientes / SUM(clientes) OVER (), 2) AS pct_clientes,
        receita,
        receita_media,
        pedidos,
        ROUND(receita * 100.0 / SUM(receita) OVER (), 2) AS pct_receita
FROM (
    SELECT  CASE
                WHEN score_r >= 3 AND score_m >= 3 THEN 'Ativos de alto valor'
                WHEN score_r >= 3 AND score_m <= 2 THEN 'Ativos de baixo valor'
                WHEN score_r = 2 AND score_m >= 3 THEN 'Semi-ativos de alto valor'
                WHEN score_r = 2 AND score_m <= 2 THEN 'Semi-ativos de baixo valor'
                WHEN score_r = 1 AND score_m >= 3 THEN 'Inativos de alto valor (em risco)'
                ELSE 'Inativos de baixo valor'
            END AS segmento,
            COUNT(*) AS clientes,
            ROUND(SUM(monetario), 2) AS receita,
            ROUND(AVG(monetario), 2) AS receita_media,
            SUM(frequencia) AS pedidos
    FROM segmentos
    GROUP BY CASE
                WHEN score_r >= 3 AND score_m >= 3 THEN 'Ativos de alto valor'
                WHEN score_r >= 3 AND score_m <= 2 THEN 'Ativos de baixo valor'
                WHEN score_r = 2 AND score_m >= 3 THEN 'Semi-ativos de alto valor'
                WHEN score_r = 2 AND score_m <= 2 THEN 'Semi-ativos de baixo valor'
                WHEN score_r = 1 AND score_m >= 3 THEN 'Inativos de alto valor (em risco)'
                ELSE 'Inativos de baixo valor'
             END
) t
ORDER BY receita DESC;