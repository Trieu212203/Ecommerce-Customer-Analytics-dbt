-- customer_segment_metrics: Aggregate metrics by RFM segment

with customers as (
    select * from {{ ref('dim_customer') }}
),

fact_sales as (
    select * from {{ ref('fact_sales') }}
),

invoice_revenue as (
    select
        customer_id,
        invoice_no,
        sum(revenue) as invoice_revenue
    from fact_sales
    group by 1, 2
),

segment_metrics as (
    select
        c.rfm_segment,
        count(distinct c.customer_id)               as customer_count,
        sum(f.revenue)                              as revenue,
        avg(ir.invoice_revenue)                     as avg_order_value,
        sum(f.quantity)                             as total_quantity
    from customers c
    left join fact_sales f
        on c.customer_id = f.customer_id
    left join invoice_revenue ir
        on c.customer_id = ir.customer_id
    group by 1
)

select * from segment_metrics
order by revenue desc
