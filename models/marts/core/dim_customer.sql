-- dim_customer: RFM Analysis and Segmentation
-- Based on Python logic from src/etl.py

with orders as (
    select * from {{ ref('stg_online_retail__orders') }}
),

today_logic as (
    -- In ETL.py: now = df['InvoiceDate'].max() + 1 day
    select max(invoice_date) + interval '1 day' as today_date
    from orders
),

customer_metrics as (
    select
        customer_id,
        extract(day from (
            (select today_date from today_logic) - max(invoice_date)
        ))::int                              as recency,
        count(distinct invoice_no)           as frequency,
        sum(revenue)                         as monetary
    from orders
    group by 1
),

rfm_scores as (
    select
        *,
        ntile(5) over (order by recency desc)    as r_score,
        ntile(5) over (order by frequency asc)   as f_score,
        ntile(5) over (order by monetary asc)    as m_score
    from customer_metrics
)

select
    *,
    case
        when r_score >= 4 and f_score >= 4 then 'Champions'
        when r_score >= 4                  then 'Loyal'
        when r_score <= 2                  then 'At Risk'
        else 'General'
    end as rfm_segment
from rfm_scores