-- stg_online_retail__orders: Clean and standardize online_retail data
-- Source: raw.online_retail_data

with source as (
    select distinct * from {{ source('online_retail', 'online_retail_data') }}
),

clean_source as (
    select
        "invoice_no"                                     as invoice_no,
        "stock_code"                                     as stock_code,
        "description"                                    as description,
        cast(nullif("quantity", '') as integer)          as quantity,
        to_timestamp("invoice_date", 'MM/DD/YYYY HH24:MI') as invoice_date,
        cast(nullif("unit_price", '') as numeric)        as unit_price,
        "customer_id"                                    as customer_id,
        "country"                                        as country
    from source
    where "customer_id" is not null and "customer_id" != ''
),

renamed as (
    select
        invoice_no,
        stock_code,
        description,
        quantity,
        invoice_date,
        unit_price,
        customer_id,
        case
            when country = 'EIRE' then 'Ireland'
            when country = 'RSA' then 'Republic of South Africa'
            else country
        end as country,
        (quantity * unit_price) as revenue
    from clean_source
    where unit_price >= 0
      and quantity > 0
      and stock_code !~ '^[A-Za-z]+$'
)

select * from renamed