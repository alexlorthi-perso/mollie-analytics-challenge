-- Assumption: channel = 1 is sales-assisted, channel = 2 is organic
-- channel 1 = 163 orgs (small, sales team), channel 2 = 9,935 (organic)
SELECT
    customer_id,
    first_payment_date::DATE AS first_payment_date,
    CASE WHEN channel = 1 THEN 'sales' ELSE 'organic' END AS acquisition_channel
FROM {{ ref('organizations') }}