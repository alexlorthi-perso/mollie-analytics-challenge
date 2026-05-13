WITH org_data AS (
    SELECT
        customer_id,
        acquisition_channel,
        first_payment_date,
        DATE_TRUNC('month', first_payment_date) AS acquisition_month
    FROM {{ ref('stg_organizations') }}
),

first_month_revenue AS (
    SELECT
        p.customer_id,
        SUM(p.revenue) AS month_0_revenue
    FROM {{ ref('int_payments_with_fees') }} p
    LEFT JOIN org_data o USING (customer_id)
    WHERE p.payment_month = DATE_TRUNC('month', o.first_payment_date)
    GROUP BY 1
)

SELECT
    o.acquisition_month,
    o.acquisition_channel,
    COUNT(DISTINCT o.customer_id)                               AS new_customers_registered,
    COUNT(DISTINCT fmr.customer_id)                             AS new_customers_active,
    COUNT(DISTINCT o.customer_id) - 
        COUNT(DISTINCT fmr.customer_id)                         AS inactive_customers,
    ROUND(COUNT(DISTINCT fmr.customer_id)::NUMERIC / 
        NULLIF(COUNT(DISTINCT o.customer_id), 0) * 100, 1)     AS activation_rate_pct,
    10000                                                       AS channel_cost,
    ROUND(10000.0 / 
        NULLIF(COUNT(DISTINCT fmr.customer_id), 0)::NUMERIC, 2) AS cac,
    ROUND(SUM(fmr.month_0_revenue)::NUMERIC / 
        NULLIF(COUNT(DISTINCT fmr.customer_id), 0), 2)          AS avg_month_0_revenue,
    ROUND((10000.0 / NULLIF(COUNT(DISTINCT fmr.customer_id), 0)) /
        NULLIF(SUM(fmr.month_0_revenue) / 
        NULLIF(COUNT(DISTINCT fmr.customer_id), 0), 0)::NUMERIC, 1) AS cac_payback_months
FROM org_data o
LEFT JOIN first_month_revenue fmr 
    ON o.customer_id = fmr.customer_id
GROUP BY 1, 2
ORDER BY 1, 2