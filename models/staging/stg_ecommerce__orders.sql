-- stg_ecommerce__orders: Clean and standardize e-commerce data
-- Source: raw.e_commerce_data

with source as (
    select * from {{ source('ecommerce', 'e_commerce_data') }}
),

renamed as (
    select
        "InvoiceNo"                                     as invoice_no,
        "StockCode"                                     as stock_code,
        "Description"                                   as description,
        cast("Quantity" as integer)                      as quantity,
        to_timestamp("InvoiceDate", 'MM/DD/YYYY HH24:MI') as invoice_date,
        cast("UnitPrice" as numeric)                     as unit_price,
        "CustomerID"                                     as customer_id,
        "Country"                                        as country,
        -- derived metric
        (cast("Quantity" as numeric) * cast("UnitPrice" as numeric)) as revenue
    from source
    where "CustomerID" is not null
)

select * from renamed