from flask import Flask, jsonify, request, render_template
from db import get_customers, open_connection, load_census_data

app = Flask(__name__)


@app.route('/', methods=['GET'])
def customers():
    conn = open_connection()
    with conn.cursor() as cursor:
        sql = 'SELECT * FROM customers LIMIT 10;'
        result = cursor.execute(sql)
        customers = cursor.fetchall()
 
    return render_template('index.html', data=customers)

@app.route('/states/')
def states():
    load_census_data()
    conn = open_connection()
    with conn.cursor() as cursor:
        sql = 'SELECT * FROM census_state_pop;'
        result = cursor.execute(sql)
        states = cursor.fetchall()
    return render_template('states.html', data=states)

    
@app.route('/api/customers/')
def customersJSON():
    if request.method == 'POST':
        if not request.is_json:
            return jsonify({"msg":"Missing JSON in request"}), 400
        # Here I could add a function to add a customer
    return get_customers()
    

if __name__ == '__main__':
    app.run()