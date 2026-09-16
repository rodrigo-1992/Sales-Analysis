-- Retenção de clientes por coorte (mês da primeira compra)
WITH pedidos_delivered AS (
    SELECT  o.customer_id,
            o.order_id,
            CAST(strftime('%Y%m', o.order_purchase_timestamp) AS INTEGER) AS mes_compra
    FROM orders o
    WHERE o.order_status = 'delivered'
),
primeiras_compra AS (
    SELECT  customer_id,
            MIN(mes_compra) AS mes_coorte
    FROM pedidos_delivered
    GROUP BY customer_id
),
base AS (
    SELECT  c.mes_coorte,
            c.customer_id,
            p.mes_compra - c.mes_coorte AS retencao_mes
    FROM primeiras_compra c
    JOIN pedidos_delivered p USING (customer_id)
),
tamanho_coorte AS (
    SELECT  mes_coorte,
            COUNT(DISTINCT customer_id) AS coorte_tamanho
    FROM base
    WHERE retencao_mes = 0
    GROUP BY mes_coorte
)
SELECT  printf('%d-%02d', t.mes_coorte / 100, t.mes_coorte % 100) AS mes_coorte,
        b.retencao_mes,
        COUNT(DISTINCT b.customer_id) AS clientes_ativos,
        t.coorte_tamanho,
        ROUND(100.0 * COUNT(DISTINCT b.customer_id) / t.coorte_tamanho, 1) AS pct_retencao
FROM base b
JOIN tamanho_coorte t ON b.mes_coorte = t.mes_coorte
GROUP BY b.mes_coorte, b.retencao_mes
ORDER BY b.mes_coorte, b.retencao_mes;