-- int_payments_with_fees.sql

SELECT
    p.customer_id,
    p.payment_month,
    p.payment_method_id,
    p.total_transactions,
    p.total_volume,
    CASE p.payment_method_id
        WHEN 3  THEN p.total_transactions * 0.29 + p.total_volume * 0
        WHEN 11 THEN p.total_transactions * 0.25 + p.total_volume * 0.018
        WHEN 17 THEN p.total_transactions * 0.39 + p.total_volume * 0
        WHEN 19 THEN p.total_transactions * 0.25 + p.total_volume * 0
    END AS revenue
FROM {{ ref('stg_payments') }} p