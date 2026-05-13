SELECT
    payment_month,
    payment_method_id,
    SUM(total_transactions)                                    AS total_transactions,
    SUM(total_volume)                                          AS total_volume,
    SUM(revenue)                                               AS total_revenue,
    ROUND((SUM(revenue) / NULLIF(SUM(total_transactions), 0))::NUMERIC, 4) AS revenue_per_transaction
FROM {{ ref('int_payments_with_fees') }}
GROUP BY 1, 2
ORDER BY 1, 2