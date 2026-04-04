-- geographic_sales_metrics

with fact_sales as (
    select * from {{ ref('fact_sales') }}
),

stg as (
    select distinct invoice_no, country
    from {{ ref('stg_online_retail__orders') }}
),

country_metrics as (
    select
        s.country,
        count(distinct f.invoice_no)                                    as total_orders,
        count(distinct f.customer_id)                                   as total_customers,
        sum(case when f.quantity > 0 then f.quantity else 0 end)        as total_quantity,
        sum(case when f.quantity > 0 then f.revenue else 0 end)         as total_revenue,
        round(
            sum(case when f.quantity > 0 then f.revenue else 0 end)::numeric
            / nullif(count(distinct f.invoice_no), 0), 2
        )                                                               as avg_order_value
    from fact_sales f
    left join stg s on f.invoice_no = s.invoice_no
    group by 1
),

with_pct as (
    select
        *,
        round(
            total_revenue / nullif(sum(total_revenue) over (), 0) * 100, 2
        )                                                               as revenue_pct
    from country_metrics
)

select * from with_pct
order by total_revenue desc