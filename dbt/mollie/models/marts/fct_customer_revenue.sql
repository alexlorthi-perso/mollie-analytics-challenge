SELECT
    p.customer_id,
    o.acquisition_channel,
    SUM(p.total_transactions)   AS total_transactions,
    SUM(p.total_volume)         AS total_volume,
    SUM(p.revenue)              AS total_revenue
FROM {{ ref('int_payments_with_fees') }} p
JOIN {{ ref('stg_organizations') }} o USING (customer_id)
GROUP BY 1, 2
ORDER BY 5 DESC
LIMIT 20