import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port=5432,
    dbname="de_warehouse",
    user="de_user",
    password="de_password",
)
cur = conn.cursor()
cur.execute("select * from public.stg_hello;")
print(cur.fetchall())
cur.close()
conn.close()
