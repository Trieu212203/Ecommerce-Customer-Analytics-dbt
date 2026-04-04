The pipeline transforms raw transactional data into a structured data warehouse using **dbt** and **PostgreSQL**, and delivers business-ready datasets for visualization in Power BI.

### 🎯 Key Objectives
- Segment customers using RFM analysis (Recency, Frequency, Monetary)
- Track revenue trends and sales performance over time
- Identify high-value and at-risk customers

---

## 🏗️ Data Pipeline Architecture

Raw CSV → Python (EDA & Ingestion) → PostgreSQL → dbt (Staging → Mart) → Power BI Dashboard

---

## 📂 Repository Structure

```text
Ecommerce-Customer-Analytics-dbt/
├── models/
│   ├── staging/                    
│   │   ├── _staging_sources.yml    
│   │   └── stg_online_retail__orders.sql
│   └── marts/
│       ├── core/                   
│       │   ├── dim_country.sql
│       │   ├── dim_customer.sql
│       │   ├── dim_date.sql
│       │   ├── dim_product.sql
│       │   └── fact_sales.sql
│       └── analytics/              
│           ├── customer_segment_metrics.sql
│           └── daily_sales_performance.sql
├── bi/                  
├── data/                
│   └── raw/             
├── scripts/             
├── dbt_project.yml      
├── docker-compose.yml

```
🏛 Data Architecture (Medallion Approach)

The project follows the Medallion Architecture to ensure data quality and clear separation of transformation layers.

🥉 Bronze Layer (Raw Data)
Raw transactional CSV files ingested into PostgreSQL
Data is loaded using high-performance COPY commands
Schema: raw
🥈 Silver Layer (Staging & Cleansing)
Standardize column names and data types
Handle null values and data inconsistencies
Model: stg_online_retail__orders
🥇 Gold Layer (Data Mart)
Core Models (Star Schema)
fact_sales – transactional sales data (grain: order line)
dim_customer – customer attributes + RFM segmentation
dim_product – product details
dim_date – calendar dimension
dim_country – geographic dimension
Analytics Models (Business-ready)
customer_segment_metrics – customer distribution by segment
daily_sales_performance – revenue trends over time
product_performance_metrics – product-level performance
geographic_sales_metrics – revenue by country

These models are optimized for direct consumption in BI tools without additional transformation.

🔗 Data Lineage
📊 Dashboard (Power BI)

The interactive dashboard is currently under development.

It will include:

Revenue trends over time
Customer segmentation (RFM)
Top customers by revenue
Geographic sales distribution

📌 Dashboard screenshots and .pbix file will be added in the next update.

💡 Key Insights

Insights will be updated after completing the Power BI dashboard.

Planned analysis includes:

Customer segmentation behavior (RFM)
Revenue contribution by customer groups
Seasonal sales trends
Identification of high-value and at-risk customers
🚧 Project Status
✅ Data ingestion (Python + PostgreSQL)
✅ Data transformation (dbt)
✅ Data modeling (Star schema)
🚧 Dashboard development (Power BI)
⏳ Business insights & reporting
