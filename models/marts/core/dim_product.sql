-- dim_product: Product dimension
-- Grain: one row per unique product (stock_code)
with products as (
    select stock_code,
        description,
        row_number() over (
            partition by stock_code
            order by invoice_date desc
        ) as rn
    from {{ ref('stg_online_retail__orders') }}
    where stock_code is not null
)
select stock_code,
    description
from products
where rn = 1