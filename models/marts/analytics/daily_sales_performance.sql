-- daily_sales_performance: Daily sales trends

with fact_sales as (
    select * from {{ ref('fact_sales') }}
),

daily_metrics as (
    select
        date_key,
        count(distinct invoice_no)  as order_count,
        count(distinct customer_id) as customer_count,
        sum(total_revenue)          as daily_revenue,
        sum(quantity)               as total_quantity
    from fact_sales
    group by 1
)

select * from daily_metrics
order by date_key desc
