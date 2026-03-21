# SQL Queries for BI Tools (Power BI / Tableau)

Use these SQL queries to connect your BI tools to the data models in Snowflake.

## 1. Customer RFM Segmentation Analysis
**Purpose**: Analyze the distribution of customer segments and their relative value.

```sql
SELECT 
    rfm_segment,
    customer_count,
    revenue,
    avg_order_value,
    total_quantity
FROM ANALYTICS_DB.MARTS.customer_segment_metrics
ORDER BY revenue DESC;
```

## 2. Daily Sales Trends
**Purpose**: Track sales growth and order counts over time.

```sql
SELECT 
    date_key,
    order_count,
    customer_count,
    daily_revenue,
    total_quantity
FROM ANALYTICS_DB.MARTS.daily_sales_performance
ORDER BY date_key ASC;
```

## 3. Top Products Analysis
**Purpose**: Rank products by revenue and quantity sold.

```sql
SELECT 
    stock_code,
    description,
    SUM(quantity) as total_quantity,
    SUM(revenue) as revenue
FROM ANALYTICS_DB.MARTS.fact_sales
GROUP BY 1, 2
ORDER BY revenue DESC
LIMIT 20;
```

## 4. Geographic Distribution
**Purpose**: Map sales and customers by country.

```sql
SELECT 
    country,
    COUNT(DISTINCT invoice_no) as total_orders,
    SUM(revenue) as revenue
FROM ANALYTICS_DB.STAGING.stg_ecommerce__orders
GROUP BY 1
ORDER BY revenue DESC;
```
