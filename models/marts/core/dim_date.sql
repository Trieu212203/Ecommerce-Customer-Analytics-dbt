-- dim_date: Date dimension for E-commerce project
-- Grain: one row per calendar date

with date_range as (
    select
        min(invoice_date::date) as start_date,
        max(invoice_date::date) as end_date
    from {{ ref('stg_ecommerce__orders') }}
),

date_spine as (
    select
        dateadd(day, seq4(), start_date) as date_key
    from date_range,
        table(generator(rowcount => 2000))
    where dateadd(day, seq4(), start_date) <= end_date
)

select
    date_key,
    year(date_key)          as year,
    quarter(date_key)       as quarter,
    month(date_key)         as month,
    day(date_key)           as day,
    dayname(date_key)       as day_name,
    monthname(date_key)     as month_name
from date_spine
