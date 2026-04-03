"""
Load online_retail XLSX data (2 sheets) into PostgreSQL.
Reads both sheets from online_retail_II.xlsx, concatenates them,
then streams into PostgreSQL via copy_expert for maximum performance.
"""

import io
import os

import pandas as pd
import psycopg2

DB_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "dbname": "online_retail",
    "user": "dbt_user",
    "password": "dbt_password",
}

XLSX_PATH = os.path.join(os.path.dirname(__file__), "..", "data", "raw", "online_retail_II.xlsx")

# Mapping: xlsx column name → target DB column name
COLUMN_MAP = {
    "Invoice":      "invoice_no",
    "StockCode":    "stock_code",
    "Description":  "description",
    "Quantity":     "quantity",
    "InvoiceDate":  "invoice_date",
    "Price":        "unit_price",
    "Customer ID":  "customer_id",
    "Country":      "country",
}


def load_sheets(xlsx_path: str) -> pd.DataFrame:
    """Read all sheets from the xlsx file and concatenate them."""
    xl = pd.ExcelFile(xlsx_path, engine="openpyxl")
    sheets = []
    for sheet in xl.sheet_names:
        print(f"  Reading sheet: '{sheet}'...")
        df = xl.parse(sheet, dtype=str)  # keep everything as string → ELT pattern
        df["_source_sheet"] = sheet
        sheets.append(df)
    return pd.concat(sheets, ignore_index=True)


def main():
    # ── 1. Read XLSX ──────────────────────────────────────────────────────────
    abs_path = os.path.abspath(XLSX_PATH)
    print(f"Reading XLSX from: {abs_path}")
    df = load_sheets(abs_path)

    # Rename to DB column names (drop any extra columns incl. _source_sheet)
    df = df.rename(columns=COLUMN_MAP)
    db_cols = list(COLUMN_MAP.values())
    df = df[db_cols]          # select only the target columns, in order

    # Replace NaN with empty string so COPY handles nulls as empty
    df = df.fillna("")

    print(f"Total rows loaded from all sheets: {len(df):,}")

    # ── 2. Connect to PostgreSQL ──────────────────────────────────────────────
    conn = psycopg2.connect(**DB_CONFIG)
    conn.autocommit = True
    cur = conn.cursor()

    # ── 3. DDL ────────────────────────────────────────────────────────────────
    print("Creating schema 'raw'...")
    cur.execute("CREATE SCHEMA IF NOT EXISTS raw;")

    print("Recreating table 'raw.online_retail_data'...")
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

    # ── 4. Stream data via copy_expert ────────────────────────────────────────
    print("Streaming data to PostgreSQL via COPY...")
    buffer = io.StringIO()
    df.to_csv(buffer, index=False, header=False)
    buffer.seek(0)

    copy_sql = """
        COPY raw.online_retail_data(invoice_no, stock_code, description, quantity,
                                     invoice_date, unit_price, customer_id, country)
        FROM STDIN WITH CSV DELIMITER ','
    """
    cur.copy_expert(sql=copy_sql, file=buffer)

    print("Data loaded successfully.")

    # ── 5. Verify ─────────────────────────────────────────────────────────────
    cur.execute("SELECT COUNT(*) FROM raw.online_retail_data;")
    print(f"Verified row count: {cur.fetchone()[0]:,}")

    cur.close()
    conn.close()


if __name__ == "__main__":
    main()