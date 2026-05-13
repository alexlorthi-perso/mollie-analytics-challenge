with active_pricing as (
    select
        p.payment_id,
        p.total_volume,
        coalesce(cp.fixed_rate, dp.fixed_rate) as fixed_rate,
        coalesce(cp.variable_rate, dp.variable_rate) as variable_rate
    from payments p

    -- join custom pricing if it was active on the payment date
    left join custom_pricing cp
        on p.customer_id = cp.customer_id
        and p.payment_method_id = cp.payment_method_id
        and p.payment_date >= cp.starts_at
        and (p.payment_date < cp.ends_at or cp.ends_at is null)

    -- fall back to default pricing if no custom pricing matched
    left join default_pricing dp
        on p.payment_method_id = dp.payment_method_id
        and p.payment_date >= dp.starts_at
        and (p.payment_date < dp.ends_at or dp.ends_at is null)
)

select
    payment_id,
    total_volume,
    fixed_rate                            as total_fixed_fee,
    total_volume * variable_rate          as total_variable_fee,
    fixed_rate + (total_volume * variable_rate) as total_fee
from active_pricing