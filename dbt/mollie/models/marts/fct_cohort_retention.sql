-- fct_cohort_retention.sql

WITH cohorts AS (
    SELECT
        o.customer_id,
        DATE_TRUNC('month', o.first_payment_date) AS cohort_month,
        o.acquisition_channel
    FROM {{ ref('stg_organizations') }} o
    WHERE o.first_payment_date >= '2020-01-01'
      AND EXISTS (
        SELECT 1 
        FROM {{ ref('stg_payments') }} p 
        WHERE p.customer_id = o.customer_id
    )
),

cohort_sizes AS (
    SELECT
        cohort_month,
        acquisition_channel,
        COUNT(DISTINCT customer_id) AS cohort_size
    FROM cohorts
    WHERE EXISTS (
        SELECT 1
        FROM {{ ref('stg_payments') }} p
        WHERE p.customer_id = cohorts.customer_id
          AND DATE_TRUNC('month', p.payment_month) = cohorts.cohort_month
    )
    GROUP BY 1, 2
),

activity AS (
    SELECT
        o.customer_id,
        o.cohort_month,
        o.acquisition_channel,
        p.payment_month,
        DATE_PART('month', AGE(p.payment_month, o.cohort_month)) AS months_since_cohort,
        SUM(p.total_transactions) AS total_transactions,
        SUM(p.total_volume)       AS total_volume,
        SUM(
            CASE p.payment_method_id
                WHEN 3  THEN p.total_transactions * 0.29
                WHEN 11 THEN p.total_transactions * 0.25 + p.total_volume * 0.018
                WHEN 17 THEN p.total_transactions * 0.39
                WHEN 19 THEN p.total_transactions * 0.25
            END
        ) AS revenue
    FROM cohorts o
    JOIN {{ ref('stg_payments') }} p USING (customer_id)
    GROUP BY 1, 2, 3, 4, 5
),

cohort_activity AS (
    SELECT
        a.cohort_month,
        a.acquisition_channel,
        a.payment_month,
        a.months_since_cohort,
        COUNT(DISTINCT a.customer_id)  AS active_customers,
        cs.cohort_size,
        ROUND(COUNT(DISTINCT a.customer_id)::NUMERIC / cs.cohort_size, 3) AS retention_rate,
        SUM(a.revenue)                 AS cohort_revenue,
        SUM(a.revenue) / COUNT(DISTINCT a.customer_id) AS revenue_per_active_customer
    FROM activity a
    JOIN cohort_sizes cs 
        ON a.cohort_month = cs.cohort_month 
        AND a.acquisition_channel = cs.acquisition_channel
    GROUP BY 1, 2, 3, 4, cs.cohort_size
)

SELECT * FROM cohort_activity
ORDER BY cohort_month, payment_month