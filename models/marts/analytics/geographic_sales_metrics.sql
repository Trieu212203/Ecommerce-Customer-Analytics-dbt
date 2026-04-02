-- geographic_sales_metrics: Aggregate sales by country for visualizations

with staging as (
    select * from {{ ref('stg_online_retail__orders') }}
),

country_metrics as (
    select
        country,
        count(distinct invoice_no) as total_orders,
        count(distinct customer_id) as total_customers,
        sum(quantity) as total_quantity,
        sum(revenue) as total_revenue
    from staging
    group by 1
)

select * from country_metrics
order by total_revenue desc
