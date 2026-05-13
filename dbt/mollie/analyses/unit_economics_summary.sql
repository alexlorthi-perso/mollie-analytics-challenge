-- Average CAC across the period per channel
SELECT
    acquisition_channel,
	10000*6/sum(new_customers_registered) as avg_cac,
    ROUND(AVG(avg_month_0_revenue), 2)  AS avg_month_0_revenue
FROM fct_customer_acquisition
GROUP BY 1