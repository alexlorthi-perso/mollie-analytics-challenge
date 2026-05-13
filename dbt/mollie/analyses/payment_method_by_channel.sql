SELECT
    o.acquisition_channel,
    p.payment_method_id,
    ROUND(SUM(p.total_volume) / SUM(SUM(p.total_volume)) OVER (PARTITION BY o.acquisition_channel) * 100, 1) AS vol_share_within_channel
FROM int_payments_with_fees p
JOIN stg_organizations o USING (customer_id)
GROUP BY 1, 2
ORDER BY 1, 2