with pricing_with_lag as (
    select 
        customer_id,
        payment_method_id,
        starts_at as pricing_updated_at,
        fixed_rate as new_fixed_rate,
        variable_rate as new_variable_rate,
        lag(fixed_rate) over (partition by customer_id, payment_method_id order by starts_at) as old_fixed_rate,
        lag(variable_rate) over (partition by customer_id, payment_method_id order by starts_at) as old_variable_rate
    from custom_pricing
)

select *
from pricing_with_lag
where old_fixed_rate is not null or old_variable_rate is not null
order by customer_id, payment_method_id, pricing_updated_at desc