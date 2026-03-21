# E-commerce Analytics dbt Project

This project provides a professional dbt transformation layer for e-commerce transaction data, migrated from a Python-based pipeline.

## Business Context
Analyze sales performance and customer behavior through RFM (Recency, Frequency, Monetary) segmentation.

## Data Lineage
```
RAW (E-Commerce_Data)  →  STAGING (stg_ecommerce__orders)  →  MARTS CORE (dim_customer, dim_date, fact_sales)  →  MARTS ANALYTICS (customer_segment_metrics, daily_sales_performance)
```

## Structure
- `models/staging/`: Initial cleaning and standardization.
- `models/marts/core/`: Dimensions and Fact tables. Includes RFM logic in `dim_customer`.
- `models/marts/analytics/`: Pre-aggregated metrics for reporting.

## Key Metrics
- **RFM Segmentation**: Champions, Loyal, At Risk, General.
- **Revenue**: Calculated as `Quantity * UnitPrice`.
- **Fulfillment**: Order counts and daily revenue growth.
