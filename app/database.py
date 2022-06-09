#########################################################################
# Flask/MySQL interface:
#  * flask_mysqldb: https://flask-mysqldb.readthedocs.io/en/latest
#  * MySQLdb: https://mysqlclient.readthedocs.io/user_guide.html
#########################################################################
from flask_mysqldb import MySQL  # flask_mysqldb is a wrapper for MYSQLdb
import app.local_settings as dbconf # database settings of local deployment
from os import path, pardir
from app.logging import Log

config = {
    "MYSQL_HOST": dbconf.host,
    "MYSQL_USER": dbconf.user,
    "MYSQL_PASSWORD": dbconf.password,
    "MYSQL_DB": dbconf.dbname,
    "MYSQL_CURSORCLASS": 'DictCursor'
}

query_dir = path.join(path.dirname(__file__), 'queries')

def log(func_name, *args):
    Log.print('database', func_name, *args)

class Database(MySQL):
    def __init__(self, app=None):
        super().__init__(app)
        self.buffer = ''
        
    def select(self, filename: str, where: str = '', where_formatter:
              dict = {}):
        """Loads a SELECT statement into the buffer from the queries
        directory, executes, and returns the selected rows.
        """
        log('select', 'Executing fetch on: ' +\
              filename, where, where_formatter)
        self.buffer = ''
        self.load_query_to_buffer('select_' + filename)
        if where:
            self.where(where, where_formatter)
        log('select', 'buffer to be executed:', self.buffer)
        return self.fetch()

    def fetch(self):
        """Executes buffer and returns selected rows."""
        with self.connect as conn:
            with conn.cursor() as cursor:
                cursor.execute(self.buffer)
                return cursor.fetchall()

    def where(self, filename: str, formatter: dict = {}) -> None:
        """Loads a WHERE statement from the queries directory, formats
        it (if formatter is provided), and inserts it into the buffer.
        """
        filepath = _query_file_path('where_' + filename)
        log('where', 'Loading file', filepath)
        with open(filepath) as sqlfile:
            where_buffer = _clean_sql_lines(sqlfile.readlines())
        if formatter:
            where_buffer = where_buffer.format(**formatter)
        log('where', 'loaded to pre-buffer:', where_buffer)
        self.buffer = self.buffer.replace('/* WHERE */', where_buffer)
        log('where', 'buffer modified:', self.buffer)


    def insert(self, filename: str, formatter: dict = {}) -> None:
        """Loads an INSERT statement into the buffer from the queries
        directory, formats it (if formatter is provided), and executes
        it.
        """
        log('insert', 'Executing insert on:', filename,
              formatter)
        self.buffer = ''
        self.load_query_to_buffer('insert_' + filename)
        if formatter:
            self.buffer = self.buffer.format(**formatter)
        log('insert', 'buffer to be executed:', self.buffer)
        self.execute()

    def update(self, filename: str, where: str = '', formatter: dict = {}) -> None:
        log('update', 'Executing update on:', filename,
              formatter)
        self.buffer = ''
        self.load_query_to_buffer('update_' + filename)
        if where:
            self.where(where)
        if formatter:
            self.buffer = self.buffer.format(**formatter)
        log('update', 'buffer to be executed:', self.buffer)
        self.execute()

    def delete(self, filename: str, where: str, where_formatter: dict = {}) -> int:
        log('delete', 'Executing delete on:', filename, where,
              where_formatter)
        self.buffer = ''
        self.load_query_to_buffer('delete_' + filename)
        self.where(where, where_formatter)
        log('delete', 'buffer to be executed:', self.buffer)
        return self.execute()        

    def execute(self) -> int:
        """Executes the current buffer, commits any changes, clears
        the buffer and returns results.
        """        
        with self.connect as conn:
            with conn.cursor() as cursor:
                result = cursor.execute(self.buffer)
                conn.commit()
                return result

    def load_query_to_buffer(self, filename: str) -> None:
        """Loads a file from the queries directory into the buffer."""
        filepath = _query_file_path(filename)
        log('load_query_to_buffer', 'Loading file', filepath)
        self.load(filepath)

    def load(self, filepath: str) -> None:
        """Loads a file to the buffer."""
        with open(filepath) as sqlfile:
            self.buffer = _clean_sql_lines(sqlfile.readlines())
        log('load_query_to_buffer', 'loaded to buffer:', self.buffer)
        
    def reset(self):
        """Resets the database to the example values."""
        fp = path.dirname(__file__)
        fp = path.join(fp, pardir)
        fp = path.abspath(fp)
        fp = path.join(fp, 'DDL.sql')
        self.load(fp)
        tmp_buffer = self.buffer.split(';')
        for cmd in tmp_buffer:
            if not cmd.strip():
                continue
            self.buffer = cmd     
            self.execute()


def _clean_sql_lines(sql: list) -> str:
    out = ''
    for line in sql:
        if line[:2] != '--' and line.strip():
            out += ' ' + line.strip()
    return out

def _query_file_path(filename: str) -> str:
    return path.join(query_dir, filename + '.sql')
