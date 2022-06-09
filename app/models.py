from app import db

class DatabaseEntity:
    """Creates a Python model of SQL database table."""
    def __init__(self, tablename: str, reqdata=None):
        self.__attributes = {}
        db.buffer = 'DESC ' + tablename
        coldata = db.fetch()
        for row in coldata:
            setattr(self, row['Field'], None)
        if reqdata is not None:
            for attr in reqdata:
                setattr(self, attr, reqdata.get(attr))
    
class ItemCopy(DatabaseEntity):
    """
    ITEM_COPIES INTERSECTION TABLE:
    +--------------+--------------+------+-----+---------+----------------+
    | Field        | Type         | Null | Key | Default | Extra          |
    +--------------+--------------+------+-----+---------+----------------+
    | id           | int          | NO   | PRI | NULL    | auto_increment |
    | catalog_item | int          | YES  | MUL | NULL    |                |
    | home_branch  | int          | YES  | MUL | NULL    |                |
    | barcode      | varchar(255) | NO   | UNI | NULL    |                |
    | status       | int          | NO   |     | NULL    |                |
    | circs        | int          | YES  |     | NULL    |                |
    +--------------+--------------+------+-----+---------+----------------+
    """
    def __init__(self, reqdata=None):
        super().__init__('Item_copies', reqdata)

class Empty:
    """An empty data structure for J2 template processing."""
    def __init__(self):
        pass

    def __getitem__(self, key):
        return ''
    
