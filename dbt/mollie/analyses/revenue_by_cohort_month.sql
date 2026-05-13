SELECT
    months_since_cohort,
    acquisition_channel,
    ROUND((SUM(cohort_revenue) / SUM(active_customers))::NUMERIC, 2) AS avg_rev_per_customer
FROM fct_cohort_retention
GROUP BY 1, 2
ORDER BY 1, 2