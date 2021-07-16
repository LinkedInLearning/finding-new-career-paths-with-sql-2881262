from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql import text

app = Flask(__name__)

# name of your database
database_name = 'products.db'

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + database_name

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True

# this variable, db, will be used for all SQLAlchemy commands
db = SQLAlchemy(app)

# NOTHING BELOW THIS LINE NEEDS TO CHANGE
# this route will test the database connection and nothing more
@app.route('/')
def testdb():
    try:
        sql = 'SELECT COUNT(1) from category'
        db.session.query('1').from_statement(sql).all()
        return '<h1>It works.</h1>'
    except Exception as e:
        # e holds description of the error
        print(e)
        error_text = "<p>The error:<br>" + str(e) + "</p>"
        hed = '<h1>Something is broken.</h1>'
        return hed + error_text

if __name__ == '__main__':
    app.run(debug=True)