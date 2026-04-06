# 🛒 E-Commerce Customer Analytics

End-to-end data pipeline for analyzing e-commerce transactions and customer behavior using **dbt** and **PostgreSQL**, delivering business-ready data for Power BI dashboards.

---

## 🎯 Objectives

* Customer segmentation using RFM (Recency, Frequency, Monetary)
* Revenue and sales trend analysis
* Identify high-value and at-risk customers

---

## 🏗️ Architecture

Raw CSV → Python → PostgreSQL → dbt (Staging → Mart) → Power BI

---

## 📊 Data Modeling

**Star Schema**

* **fact_sales** – transactional data (order-line level)
* **dim_customer** – customer + RFM segmentation
* **dim_product**, **dim_date**, **dim_country**

**Analytics Tables**

* `customer_segment_metrics`
* `daily_sales_performance`
* `product_performance_metrics`
* `geographic_sales_metrics`

> Optimized for direct use in BI tools.

---

## 🏛️ Data Layers (Medallion)

* **Bronze**: Raw CSV → PostgreSQL (`raw`)
* **Silver**: Clean & standardize (`stg_online_retail__orders`)
* **Gold**: Star schema + business metrics (`marts`)

---
## Architecture

text
```
Ecommerce-Customer-Analytics-dbt/
├── models/
│   ├── staging/                    # Silver layer (clean & standardize)
│   │   ├── _staging_sources.yml    # Source definitions + tests
│   │   └── stg_online_retail__orders.sql
│   └── marts/
│       ├── core/                   # Gold layer (star schema)
│       │   ├── dim_country.sql
│       │   ├── dim_customer.sql
│       │   ├── dim_date.sql
│       │   ├── dim_product.sql
│       │   └── fact_sales.sql
│       └── analytics/              # Gold layer (pre-aggregated)
│           ├── customer_segment_metrics.sql
│           └── monthly_sales_performance.sql
│           └── geographic_sales_metrics.sql
│           └── product_performance.sql
├── notebooks/
│   ├── 01.raw_data_exploration.ipynb
│   └── 02.data_quality.ipynb
├── bi/                  # Business Intelligence
├── data/                # Raw CSV data files
│   └──  raw/ # Raw CSV data files
├── scripts/             # Python scripts for data ingestion
├── dbt_project.yml      # dbt project configuration
├── docker-compose.yml   # Docker services (Postgres)
```

## 🔗 Data Lineage

```mermaid
graph LR
    %% ======================
    %% Bronze Layer
    %% ======================
    subgraph Bronze [RAW Layer]
        A[(raw.online_retail_data)]
    end

    %% ======================
    %% Silver Layer
    %% ======================
    subgraph Silver [STAGING Layer]
        B[[stg_online_retail__orders]]
        A --> B
    end

    %% ======================
    %% Gold - Core
    %% ======================
    subgraph Gold_Core [MARTS - Core]
        C[[dim_customer]]
        D[[dim_date]]
        E[[dim_product]]
        F[[dim_country]]
        G[[fact_sales]]

        B --> C
        B --> D
        B --> E
        B --> F
        B --> G
    end

    %% ======================
    %% Gold - Analytics
    %% ======================
    subgraph Gold_Analytics [MARTS - Analytics]
        H[[customer_segment_mtrcs ]]
        I[[monthly_sales_performance ]]
        J[[product_performance_mtrcs]]
        K[[geographic_sales_mtrcs ]]

        %% dependencies
        C --> H
        G --> H

        D --> I
        G --> I

        E --> J
        G --> J

        F --> K
        G --> K
    end

    %% ======================
    %% Styling
    %% ======================
    classDef raw fill:#cd7f32,stroke:#333,stroke-width:2px,color:#fff;
    classDef stg fill:#c0c0c0,stroke:#333,stroke-width:2px,color:#111;
    classDef mart fill:#ffd700,stroke:#333,stroke-width:2px,color:#111;

    class A raw;
    class B stg;
    class C,D,E,F,G mart;
    class H,I,J,K mart;
```

---

## 📊 Dashboard (Power BI)

*In progress*

Planned:

* Revenue trends
* RFM segmentation
* Top customers
* Sales by country

---

## 💡 Insights

Planned:

* Customer segmentation behavior
* Revenue contribution by segments
* Seasonal trends

---

