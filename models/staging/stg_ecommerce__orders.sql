-- stg_ecommerce__orders: Clean and standardize e-commerce data
-- Source: RAW.E_COMMERCE_DATA

with source as (
    select * from {{ source('ecommerce', 'E_COMMERCE_DATA') }}
),

renamed as (
    select
        InvoiceNo                       as invoice_no,
        StockCode                       as stock_code,
        Description                     as description,
        cast(Quantity as integer)       as quantity,
        cast(InvoiceDate as timestamp)  as invoice_date,
        cast(UnitPrice as decimal)      as unit_price,
        CustomerID                      as customer_id,
        Country                         as country,
        
        -- derived metrics
        (cast(Quantity as decimal) * cast(UnitPrice as decimal)) as total_revenue
    from source
    where CustomerID is not null -- Filter out guest checkouts if needed
)

select * from renamed
