-- dim_customer: RFM Analysis and Segmentation
-- Based on Python logic from src/etl.py

with orders as (
    select * from {{ ref('stg_ecommerce__orders') }}
),

today_logic as (
    -- In ETL.py: now = df['InvoiceDate'].max() + 1 day
    select dateadd(day, 1, max(invoice_date)) as today_date
    from orders
),

customer_metrics as (
    select
        customer_id,
        datediff(day, max(invoice_date), (select today_date from today_logic)) as recency,
        count(distinct invoice_no)                                             as frequency,
        sum(total_revenue)                                                     as monetary
    from orders
    group by 1
),

rfm_scores as (
    select
        *,
        ntile(5) over (order by recency desc) as r_score,     -- Higher recency (more days) = lower score
        ntile(5) over (order by frequency asc) as f_score,   -- Higher frequency = higher score
        ntile(5) over (order by monetary asc)  as m_score    -- Higher monetary = higher score
    from customer_metrics
)

select
    *,
    case
        when r_score >= 4 and f_score >= 4 then 'Champions'
        when r_score >= 4 then 'Loyal'
        when r_score <= 2 then 'At Risk'
        else 'General'
    end as rfm_segment
from rfm_scores
