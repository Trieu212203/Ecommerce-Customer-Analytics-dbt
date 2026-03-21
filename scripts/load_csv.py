"""
Load E-Commerce CSV data into PostgreSQL.
Usage: python scripts/load_csv.py
"""

import csv
import psycopg2
import os

# Database connection
DB_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "dbname": "ecommerce",
    "user": "dbt_user",
    "password": "dbt_password",
}

CSV_PATH = os.path.join(os.path.dirname(__file__), "..", "data", "raw", "E-Commerce_Data.csv")


def main():
    conn = psycopg2.connect(**DB_CONFIG)
    conn.autocommit = True
    cur = conn.cursor()

    # Create raw schema
    print("Creating schema 'raw'...")
    cur.execute("CREATE SCHEMA IF NOT EXISTS raw;")

    # Create table
    print("Creating table 'raw.e_commerce_data'...")
    cur.execute("DROP TABLE IF EXISTS raw.e_commerce_data;")
    cur.execute("""
        CREATE TABLE raw.e_commerce_data (
            "InvoiceNo"   VARCHAR(50),
            "StockCode"   VARCHAR(50),
            "Description" TEXT,
            "Quantity"     INTEGER,
            "InvoiceDate" VARCHAR(50),
            "UnitPrice"   NUMERIC(10, 2),
            "CustomerID"  VARCHAR(50),
            "Country"     VARCHAR(100)
        );
    """)

    # Load CSV
    print(f"Loading CSV from: {os.path.abspath(CSV_PATH)}")
    with open(CSV_PATH, "r", encoding="ISO-8859-1") as f:
        reader = csv.reader(f)
        header = next(reader)  # skip header
        print(f"Columns: {header}")

        count = 0
        for row in reader:
            try:
                # Handle empty CustomerID
                customer_id = row[6] if row[6].strip() else None
                # Handle empty Quantity/UnitPrice
                quantity = int(row[3]) if row[3].strip() else 0
                unit_price = float(row[5]) if row[5].strip() else 0.0

                cur.execute(
                    """
                    INSERT INTO raw.e_commerce_data
                    ("InvoiceNo", "StockCode", "Description", "Quantity",
                     "InvoiceDate", "UnitPrice", "CustomerID", "Country")
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                    """,
                    (row[0], row[1], row[2], quantity, row[4], unit_price, customer_id, row[7]),
                )
                count += 1
                if count % 50000 == 0:
                    print(f"  Loaded {count:,} rows...")
            except Exception as e:
                print(f"Error on row {count+1}: {row}")
                raise e

    print(f"\n✅ Done! Loaded {count:,} rows into raw.e_commerce_data")

    # Verify
    cur.execute("SELECT COUNT(*) FROM raw.e_commerce_data;")
    print(f"   Verified row count: {cur.fetchone()[0]:,}")

    cur.close()
    conn.close()


if __name__ == "__main__":
    main()
