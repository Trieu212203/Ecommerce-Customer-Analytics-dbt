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
        generate_series(start_date, end_date, interval '1 day')::date as date_key
    from date_range
)

select
    date_key,
    extract(year from date_key)::int      as year,
    extract(quarter from date_key)::int   as quarter,
    extract(month from date_key)::int     as month,
    extract(day from date_key)::int       as day,
    to_char(date_key, 'Day')              as day_name,
    to_char(date_key, 'Month')            as month_name
from date_spine
