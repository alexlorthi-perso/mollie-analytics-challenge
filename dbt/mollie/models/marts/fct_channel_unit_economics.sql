-- Add to a new mart: fct_channel_unit_economics.sql
SELECT
    o.acquisition_channel,
    p.payment_month,
    SUM(p.revenue) / COUNT(DISTINCT p.customer_id) AS revenue_per_customer,
    SUM(p.total_volume) / SUM(p.total_transactions) AS avg_transaction_value,
    SUM(p.total_transactions) / COUNT(DISTINCT p.customer_id) AS transactions_per_customer
FROM {{ ref('int_payments_with_fees') }} p
JOIN {{ ref('stg_organizations') }} o USING (customer_id)
GROUP BY 1, 2
ORDER BY 1, 2