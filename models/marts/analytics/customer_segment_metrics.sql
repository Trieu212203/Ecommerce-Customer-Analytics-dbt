with customers as (
    select * from {{ ref('dim_customer') }}
),
segment_customers as (
    select 
        rfm_segment,
        count(customer_id) as total_customers, 
        sum(monetary) as total_revenue,
        sum(frequency) as total_orders,
        sum(monetary) / sum(frequency) as AOV
    from customers	
    group by 1 
)

select * 
from segment_customers