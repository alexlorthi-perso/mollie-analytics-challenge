-- fct_payment_method_summary.sql

WITH totals AS (
    SELECT
        SUM(total_volume)  AS grand_total_volume,
        SUM(revenue)       AS grand_total_revenue
    FROM {{ ref('int_payments_with_fees') }}
)

SELECT
    p.payment_method_id,
    SUM(p.total_transactions)                                                       AS total_transactions,
    SUM(p.total_volume)                                                             AS total_volume,
    SUM(p.revenue)                                                                  AS total_revenue,
    ROUND((SUM(p.total_volume)  / t.grand_total_volume  * 100)::NUMERIC, 1)         AS volume_share_pct,
    ROUND((SUM(p.revenue)       / t.grand_total_revenue * 100)::NUMERIC, 1)         AS revenue_share_pct,
    ROUND((SUM(p.revenue) / NULLIF(SUM(p.total_transactions), 0))::NUMERIC, 2)      AS revenue_per_transaction

FROM {{ ref('int_payments_with_fees') }} p
CROSS JOIN totals t
GROUP BY p.payment_method_id, t.grand_total_volume, t.grand_total_revenue
ORDER BY 1