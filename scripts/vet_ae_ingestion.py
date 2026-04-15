import json
from re import search
import requests
import psycopg2
# from datetime import datetime

API_URL =  "https://api.fda.gov/animalandveterinary/event.json?"

DB_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "dbname": "de_warehouse",
    "user": "de_user",
    "password": "de_password",
}

PIPELINE_NAME = "vet_ae_ingestion"
MAX_PAGES = 3
LIMIT = 5

# Get today's date and format it as YYYYMMDD
# FORMATTED_DATE = datetime.today().strftime('%Y%m%d')

def get_watermark(conn):
    cur = conn.cursor()
    cur.execute("""
        SELECT last_loaded_value 
        FROM etl.pipeline_watermark
        WHERE pipeline_name = %s
    """, (PIPELINE_NAME,))

    result = cur.fetchone() 
    cur.close()

    if result is None:
        raise ValueError(f"No watermark row found for pipeline_name={PIPELINE_NAME}")
    
    return result[0]
    
def update_watermark(conn, new_watermark):
    cur = conn.cursor()
    cur.execute("""
        INSERT INTO etl.pipeline_watermark (pipeline_name, last_loaded_value)
        VALUES (%s, %s)
        ON CONFLICT (pipeline_name)
        DO UPDATE SET
            last_loaded_value = EXCLUDED.last_loaded_value
    """, (PIPELINE_NAME, new_watermark))

def fetch_vet_data(skip, limit, watermark):
    query = f"original_receive_date:[{watermark}+TO+20260106]"
    url = f"{API_URL}search={query}&limit={limit}&skip={skip}"
   
    response = requests.get(url, timeout=30)
    response.raise_for_status()
    return response.json()['results']
    
def insert_vet_data_to_db(conn, vet_data):
    if vet_data:
        cur = conn.cursor()
        insert_query = """
            INSERT INTO raw.vet_ae_report (
                unique_aer_id_number, 
                original_receive_date, 
                payload
            )
                VALUES (%s, %s, %s::jsonb)
                ON CONFLICT (unique_aer_id_number) DO NOTHING
            """
        
        inserted_rows = 0

        for report in vet_data:
            cur.execute(insert_query, (report.get("unique_aer_id_number"), report.get("original_receive_date"), json.dumps(report)) ) 

            if cur.rowcount == 1:
                inserted_rows += 1

        return inserted_rows

def main():
    conn = psycopg2.connect(**DB_CONFIG)

    current_watermark = get_watermark(conn)
    max_watermark = current_watermark

    total_fetched = 0
    total_inserted = 0

    print(f"Starting watermark: {current_watermark}")

    try:
        for page in range(MAX_PAGES):
            skip = page * LIMIT

            print(f"\nFetching page {page + 1} (skip={skip})...")

            reports = fetch_vet_data(skip, limit=LIMIT, watermark=current_watermark )
            if not reports:
                print("No more data to fetch. Stopping ingestion")
                break 

            fetched_count = len(reports)
            total_fetched += fetched_count

            inserted_count = insert_vet_data_to_db(conn, reports)
            total_inserted += inserted_count

            # Track max watermark from fetched data
            for report in reports:
                receive_date = report.get("original_receive_date")
                if receive_date and receive_date > max_watermark:
                    max_watermark = receive_date

            conn.commit()

            print(f"Fetched: {fetched_count}")
            print(f"Inserted: {inserted_count}")
            print(f"Skipped (duplicates): {fetched_count - inserted_count}")

        # Only move watermark forward after successful completion of all pages
        if max_watermark > current_watermark:
            update_watermark(conn, max_watermark) 
            conn.commit()
            print(f"\nUpdated watermark from: {current_watermark} to: {max_watermark}")
        else:
            print(f"\nWatermark unchanged: {current_watermark}") 

        print("\n=== Ingestion Summary ===")
        print(f"Total fetched: {total_fetched}")
        print(f"Total inserted: {total_inserted}")
        print(f"Total skipped: {total_fetched - total_inserted}")

    finally:
        conn.close()


if __name__ == "__main__":
    main()
