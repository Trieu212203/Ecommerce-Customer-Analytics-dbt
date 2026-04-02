-- fact_sales: Transaction-level fact table for sales
-- Grain: one row per line item
with sales as (
    select *
    from {{ ref('stg_online_retail__orders') }}
)
select invoice_no,
    invoice_date::date as date_key,
    customer_id,
    stock_code,
    description,
    quantity,
    unit_price,
    revenue
from sales