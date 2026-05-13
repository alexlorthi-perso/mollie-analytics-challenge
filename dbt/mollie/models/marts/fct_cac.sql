WITH new_customers AS (
    SELECT
        DATE_TRUNC('month', first_payment_date) AS cohort_month,
        acquisition_channel,
        COUNT(DISTINCT customer_id)             AS new_customers
    FROM {{ ref('stg_organizations') }}
    WHERE first_payment_date BETWEEN '2020-01-01' AND '2020-06-30'
    GROUP BY 1, 2
),

revenue_per_customer AS (
    SELECT
        o.acquisition_channel,
        pwf.payment_month,
        SUM(pwf.revenue) / COUNT(DISTINCT pwf.customer_id) AS avg_monthly_revenue_per_customer
    FROM {{ ref('int_payments_with_fees') }} pwf
    JOIN {{ ref('stg_organizations') }} o USING (customer_id)
    GROUP BY 1, 2
),

-- Use the last month as the most representative revenue per customer
latest_rpc AS (
    SELECT
        acquisition_channel,
        avg_monthly_revenue_per_customer
    FROM revenue_per_customer
    WHERE payment_month = '2020-06-01'
)

SELECT
    nc.cohort_month,
    nc.acquisition_channel,
    nc.new_customers,
    10000                                                    AS channel_cost,
    ROUND(10000.0 / nc.new_customers, 2)                    AS cac,
    ROUND(lr.avg_monthly_revenue_per_customer::numeric, 2)  AS avg_monthly_rev_per_customer,
    ROUND(((10000.0 / nc.new_customers) / 
        lr.avg_monthly_revenue_per_customer)::NUMERIC, 2) AS cac_payback_months
FROM new_customers nc
JOIN latest_rpc lr USING (acquisition_channel)
ORDER BY 1, 2