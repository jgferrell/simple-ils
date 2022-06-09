#########################################################################
# FLASK MODULES
#########################################################################
from flask import Flask
# flask_boostrap -- https://bootstrap-flask.readthedocs.io/en/stable/basic/
from flask_bootstrap import Bootstrap

#########################################################################
# FLASK/DATABASE INTEGRATION
#########################################################################
from app.database import Database, config as dbconf

#########################################################################
# FIRE UP THE APP
#########################################################################
app = Flask(__name__)
# MYSQL database connection info
for setting, value in dbconf.items():
    app.config[setting] = value
db = Database(app)
# FLASK-WTF configuration
app.config['SECRET_KEY'] = '4vQqt2COxVMGuGplS0X66gBLt6YnA69u'
Bootstrap(app)  # required by Flask-Bootstrap

from app import views
