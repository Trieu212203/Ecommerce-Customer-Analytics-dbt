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
FROM customer_segment_metrics
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
FROM daily_sales_performance
ORDER BY date_key ASC;
```

## 3. Top Products Analysis
**Purpose**: Rank products by revenue and quantity sold.

```sql
SELECT 
    stock_code,
    description,
    total_quantity,
    total_revenue,
    order_count
FROM product_performance_metrics
ORDER BY total_revenue DESC
LIMIT 20;
```

## 4. Geographic Distribution
**Purpose**: Map sales and customers by country.

```sql
SELECT 
    country,
    total_orders,
    total_customers,
    total_revenue
FROM geographic_sales_metrics
ORDER BY total_revenue DESC;
```
