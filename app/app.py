from flask import Flask, request, render_template, jsonify
import psycopg2
import os

app = Flask(__name__, template_folder='../templates')

def get_db_connection():
    conn = psycopg2.connect(
        host=os.environ.get('DB_HOST', 'localhost'),
        database=os.environ.get('DB_NAME', 'personsearch'),
        user=os.environ.get('DB_USER', 'postgres'),
        password=os.environ.get('DB_PASSWORD', 'postgres'),
        port=os.environ.get('DB_PORT', '5432')
    )
    return conn

@app.route('/health')
def health_check():
    return 'OK', 200

@app.route('/', methods=['GET'])
def index():
    search_query = request.args.get('search_query', '').strip()
    results = None
    
    if search_query != '':
        results = []
        try:
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute('SELECT name, age, email, phone, address FROM persons WHERE name ILIKE %s', ('%' + search_query + '%',))
            rows = cur.fetchall()
            for row in rows:
                results.append({
                    'name': row[0],
                    'age': row[1],
                    'email': row[2],
                    'phone': row[3],
                    'address': row[4]
                })
            cur.close()
            conn.close()
        except Exception as e:
            print(f"Database error: {e}")
            results = []

    return render_template('index.html', results=results, search_query=search_query)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
