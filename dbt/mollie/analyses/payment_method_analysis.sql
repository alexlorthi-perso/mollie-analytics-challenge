SELECT
    payment_method_id,
    volume_share_pct,
    revenue_share_pct,
    revenue_per_transaction
FROM fct_payment_method_summary
ORDER BY 1