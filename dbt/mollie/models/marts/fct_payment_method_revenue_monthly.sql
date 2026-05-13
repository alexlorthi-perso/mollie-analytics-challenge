SELECT
    p.payment_method_id,
    p.payment_month,
    SUM(p.total_transactions)   AS total_transactions,
    SUM(p.total_volume)         AS total_volume,
    SUM(p.revenue)              AS total_revenue
FROM {{ ref('int_payments_with_fees') }} p
GROUP BY 1, 2
ORDER BY 1, 2