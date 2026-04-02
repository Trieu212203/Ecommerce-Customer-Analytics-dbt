-- stg_ecommerce__orders: Clean and standardize e-commerce data
-- Source: raw.e_commerce_data

with source as (
    select * from {{ source('ecommerce', 'e_commerce_data') }}
),

renamed as (
    select
        "invoice_no"                                     as invoice_no,
        "stock_code"                                     as stock_code,
        "description"                                   as description,
        cast(nullif("quantity", '') as integer)         as quantity,
        to_timestamp("invoice_date", 'MM/DD/YYYY HH24:MI') as invoice_date,
        cast(nullif("unit_price", '') as numeric)       as unit_price,
        "customer_id"                                     as customer_id,
        "country"                                        as country,
        (cast(nullif("quantity", '') as numeric) * cast(nullif("unit_price", '') as numeric)) as revenue
    from source
    where "customer_id" is not null and "customer_id" != ''
)

select * from renamed