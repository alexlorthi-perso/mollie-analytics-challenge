-- stg_payments.sql

SELECT
    customer_id,
    payment_month::DATE AS payment_month,
    payment_method_id,
    total_transactions,
    total_volume
FROM {{ ref('payments') }}