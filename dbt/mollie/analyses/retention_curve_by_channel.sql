SELECT
    months_since_cohort,
    acquisition_channel,
    ROUND(AVG(retention_rate) * 100, 1) AS avg_retention_pct
FROM fct_cohort_retention
WHERE NOT (acquisition_channel = 'sales' AND months_since_cohort >= 4)
GROUP BY 1, 2
ORDER BY 1, 2