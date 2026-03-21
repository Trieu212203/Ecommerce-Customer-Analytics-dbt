-- dim_country: Country dimension
-- Grain: one row per unique country

with countries as (
    select distinct country
    from {{ ref('stg_ecommerce__orders') }}
    where country is not null
)

select
    row_number() over (order by country) as country_id,
    country
from countries