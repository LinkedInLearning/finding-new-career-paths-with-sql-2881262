import os
import pymysql
from flask import jsonify, request
import json
from urllib.request import urlopen
import urllib.error

db_user = os.environ.get('CLOUD_SQL_USERNAME')
db_password = os.environ.get('CLOUD_SQL_PASSWORD')
db_name = os.environ.get('CLOUD_SQL_DATABASE_NAME')
db_connection_name = os.environ.get('CLOUD_SQL_CONNECTION_NAME')
acs_api_key = os.environ.get('ACS_KEY')

def open_connection():
    unix_socket = '/cloudsql/{}'.format(db_connection_name)
    try:
        if os.environ.get('GAE_ENV') == 'standard':
            conn = pymysql.connect(user=db_user, password=db_password, 
            unix_socket=unix_socket, db=db_name,
            cursorclass=pymysql.cursors.DictCursor
            )
    except pymysql.MySQLError as e:
        print(e)

    return conn


def get_customers():
    conn = open_connection()
    with conn.cursor() as cursor:
        sql = 'SELECT * FROM customers LIMIT 50;'
        result = cursor.execute(sql)
        customers = cursor.fetchall()

        if result > 0:
            customers_json = jsonify(customers)
        else:
            customers_json = 'No Customers in the Database'
    conn.close()
    return customers_json


def add_state_census(name, pop,code):
    conn = open_connection()
    insert_sql = """INSERT INTO census_state_pop (statename, pop, code) 
    VALUES (%s, %s, %s)"""
    with conn:
        cursor = conn.cursor()
        cursor.execute(insert_sql,(name,pop,code))
    conn.commit()
    conn.close()
    return

def new_census_data():
    try:
        url = "https://api.census.gov/data/2010/dec/sf2?get=NAME,HCT001001&for=state:*"
        response = urlopen(url)
        response_data = json.loads(response.read())
        return response_data
    
    except urllib.error.HTTPError as e:
        print(e.__dict__)
    except urllib.error.URLError as e:
        print(e.__dict__)
    

def load_census_data():
    response =  new_census_data()
    conn = open_connection()
    insert_sql = """INSERT INTO census_state_pop (statename, pop, code) 
    VALUES (%s, %s, %s)"""
    with conn:
        cursor = conn.cursor()
        for i, item in enumerate(response):
            if i > 0:
                name = item[0]
                pop = item[1]
                code = item[2]
                print('Name: ',name,' Population: ',pop, 'Code: ',code)
                cursor.execute(insert_sql,(name,pop,code))
                conn.commit()
    
    
            
            
    
    