-- daily_sales_performance: Daily sales trends

with fact_sales as (
    select * from {{ ref('fact_sales') }}
),

monthly_metrics as (
    select
        date_trunc('month', date_key)::date         as month_key,
        extract(year from date_key)::int            as year,
        extract(month from date_key)::int           as month,
        to_char(date_key, 'Mon YYYY')               as month_label,
        count(distinct invoice_no)                  as order_count,
        count(distinct customer_id)                 as customer_count,
        sum(revenue)                                as monthly_revenue,
        sum(quantity)                               as total_quantity,
        round(sum(revenue) /
            nullif(count(distinct invoice_no), 0), 2) as avg_order_value
    from fact_sales
    group by 1, 2, 3, 4
)

select * from monthly_metrics
order by month_key desc
