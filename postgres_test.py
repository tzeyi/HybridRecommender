import psycopg2

try:
    conn = psycopg2.connect(
        dbname="mydatabase",
        user="postgres",
        # password="your_password",
        host="localhost",
        port="5432"
    )
    cursor = conn.cursor()
    cursor.execute("SELECT version();")
    print(cursor.fetchone())
    cursor.close()
    conn.close()
except Exception as e:
    print("Error:", e)
