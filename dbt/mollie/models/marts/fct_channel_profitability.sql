SELECT
    o.acquisition_channel,
    p.payment_month,
    COUNT(DISTINCT p.customer_id)   AS active_customers,
    SUM(p.total_transactions)       AS total_transactions,
    SUM(p.total_volume)             AS total_volume,
    SUM(p.revenue)                  AS total_revenue,
    SUM(p.revenue) - 10000          AS profit
FROM {{ ref('int_payments_with_fees') }} p
JOIN {{ ref('stg_organizations') }} o USING (customer_id)
GROUP BY 1, 2
ORDER BY 1, 2