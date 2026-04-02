-- product_performance_metrics: Top selling products and their KPIs

with fact_sales as (
    select * from {{ ref('fact_sales') }}
),

product_metrics as (
    select
        stock_code,
        description,
        count(distinct invoice_no) as order_count,
        count(distinct customer_id) as customer_count,
        sum(quantity) as total_quantity,
        sum(revenue) as total_revenue
    from fact_sales
    group by 1, 2
)

select * from product_metrics
order by total_revenue desc
