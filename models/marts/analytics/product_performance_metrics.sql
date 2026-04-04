-- product_performance_metrics

with fact_sales as (
    select * from {{ ref('fact_sales') }}
),

dim_product as (
    select * from {{ ref('dim_product') }}
),

product_metrics as (
    select
        f.stock_code,
        p.description,
        count(distinct f.invoice_no)                                    as order_count,
        count(distinct f.customer_id)                                   as customer_count,
        sum(case when f.quantity > 0 then f.quantity else 0 end)        as total_quantity,
        sum(case when f.quantity > 0 then f.revenue else 0 end)         as total_revenue,
        round(avg(f.unit_price)::numeric, 2)                            as avg_unit_price
    from fact_sales f
    left join dim_product p on f.stock_code = p.stock_code
    group by 1, 2
)

select * from product_metrics
order by total_revenue desc