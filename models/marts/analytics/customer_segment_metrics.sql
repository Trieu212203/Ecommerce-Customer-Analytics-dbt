-- customer_segment_metrics: Aggregate metrics by RFM segment

with customers as (
    select * from {{ ref('dim_customer') }}
),

fact_sales as (
    select * from {{ ref('fact_sales') }}
),

segment_metrics as (
    select
        c.rfm_segment,
        count(distinct c.customer_id)           as customer_count,
        sum(f.total_revenue)                    as total_revenue,
        avg(f.total_revenue)                    as avg_order_value,
        sum(f.quantity)                         as total_quantity
    from customers c
    left join fact_sales f
        on c.customer_id = f.customer_id
    group by 1
)

select * from segment_metrics
order by total_revenue desc
