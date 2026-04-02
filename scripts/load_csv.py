"""
Load online_retail CSV data into PostgreSQL using Copy insert for maximum performance.
"""

import psycopg2
import os

DB_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "dbname": "online_retail",
    "user": "dbt_user",
    "password": "dbt_password",
}

CSV_PATH = os.path.join(os.path.dirname(__file__), "..", "data", "raw", "online_retail_II.csv")


def main():
    conn = psycopg2.connect(**DB_CONFIG)
    conn.autocommit = True
    cur = conn.cursor()

    # Create schema
    print("Creating schema 'raw'...")
    cur.execute("CREATE SCHEMA IF NOT EXISTS raw;")

    # Recreate table 
    # Using VARCHAR(50) to allow ELT fast loading without data casting issues in python
    print("Creating table 'raw.online_retail_data'...")
    cur.execute("DROP TABLE IF EXISTS raw.online_retail_data CASCADE;")
    cur.execute("""
        CREATE TABLE raw.online_retail_data (
            invoice_no   VARCHAR(50),
            stock_code   VARCHAR(50),
            description  TEXT,
            quantity     VARCHAR(50),
            invoice_date VARCHAR(50),
            unit_price   VARCHAR(50),
            customer_id  VARCHAR(50),
            country      VARCHAR(100)
        );
    """)

    # Load CSV with COPY
    abs_csv_path = os.path.abspath(CSV_PATH)
    print(f"Loading CSV from: {abs_csv_path}")

    # copy_expert uses the native COPY FROM STDIN which is magnitudes faster
    with open(CSV_PATH, "r", encoding="ISO-8859-1") as f:
        copy_sql = """
            COPY raw.online_retail_data(invoice_no, stock_code, description, quantity, invoice_date, unit_price, customer_id, country)
            FROM STDIN WITH CSV HEADER DELIMITER ','
        """
        cur.copy_expert(sql=copy_sql, file=f)

    print("CSV loaded successfully via COPY command.")

    # Verify
    cur.execute("SELECT COUNT(*) FROM raw.online_retail_data;")
    print(f"Verified row count: {cur.fetchone()[0]:,}")

    cur.close()
    conn.close()


if __name__ == "__main__":
    main()