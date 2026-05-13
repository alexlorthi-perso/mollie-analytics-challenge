-- fct_cohort_retention.sql
-- Cohort retention analysis: tracks how many customers from each acquisition cohort
-- remain active each month, and how much revenue they generate.
-- Used for: retention curve chart, revenue per customer by months since acquisition.

WITH cohorts AS (
    -- One row per customer, with their cohort month (month of first payment)
    -- Filtered to the observation window (Jan-Jun 2020) and customers who actually transacted
    SELECT
        o.customer_id,
        DATE_TRUNC('month', o.first_payment_date) AS cohort_month,
        o.acquisition_channel
    FROM {{ ref('stg_organizations') }} o
    WHERE o.first_payment_date >= '2020-01-01'
      AND o.customer_id IN (SELECT DISTINCT customer_id FROM {{ ref('int_payments_with_fees') }})
),

cohort_sizes AS (
    -- Fixed denominator: only customers who were actually active in their cohort month (month 0)
    -- This ensures retention is 100% at month 0 by definition
    SELECT
        c.cohort_month,
        c.acquisition_channel,
        COUNT(DISTINCT c.customer_id) AS cohort_size
    FROM cohorts c
    JOIN {{ ref('int_payments_with_fees') }} p USING (customer_id)
    WHERE DATE_TRUNC('month', p.payment_month) = c.cohort_month
    GROUP BY 1, 2
),

activity AS (
    -- One row per customer x payment month, with months_since_cohort as the time axis.
    -- Joins all future payment activity back to the customer's cohort.
    SELECT
        c.customer_id,
        c.cohort_month,
        c.acquisition_channel,
        p.payment_month,
        DATE_PART('month', AGE(p.payment_month, c.cohort_month))::INT AS months_since_cohort,
        SUM(p.revenue) AS revenue
    FROM cohorts c
    JOIN {{ ref('int_payments_with_fees') }} p USING (customer_id)
    GROUP BY 1, 2, 3, 4, 5
)

SELECT
    a.cohort_month,
    a.acquisition_channel,
    a.payment_month,
    a.months_since_cohort,
    -- Numerator: customers still active this month from the original cohort
    COUNT(DISTINCT a.customer_id)                                        AS active_customers,
    -- Denominator: fixed size of the cohort at month 0
    cs.cohort_size,
    -- Retention rate: share of original cohort still active (1.0 at month 0 by definition)
    ROUND(COUNT(DISTINCT a.customer_id)::NUMERIC / cs.cohort_size, 3)   AS retention_rate,
    SUM(a.revenue)                                                       AS cohort_revenue,
    -- Revenue per active customer (not per original cohort member)
    ROUND((SUM(a.revenue) / COUNT(DISTINCT a.customer_id))::NUMERIC, 2) AS revenue_per_active_customer
FROM activity a
JOIN cohort_sizes cs
    ON a.cohort_month = cs.cohort_month
    AND a.acquisition_channel = cs.acquisition_channel
GROUP BY 1, 2, 3, 4, cs.cohort_size
ORDER BY 1, 2, 3