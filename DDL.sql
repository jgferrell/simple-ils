--
-- BiblioSQL’s Simple ILS
-- Group 23: Kaitlyn Scarborough and Jason Ferrell

DROP TABLE IF EXISTS Item_copies;
DROP TABLE IF EXISTS Catalog_items;
DROP TABLE IF EXISTS People;
DROP TABLE IF EXISTS Branches;
DROP TABLE IF EXISTS Library_systems;

--
--  LIBRARY_SYSTEMS ENTITY TABLE
--  +-------+--------------+------+-----+---------+----------------+
--  | Field | Type         | Null | Key | Default | Extra          |
--  +-------+--------------+------+-----+---------+----------------+
--  | id    | int          | NO   | PRI | NULL    | auto_increment |
--  | code  | varchar(6)   | NO   | UNI | NULL    |                |
--  | name  | varchar(255) | NO   |     | NULL    |                |
--  +-------+--------------+------+-----+---------+----------------+
CREATE TABLE Library_systems (
  id INT NOT NULL AUTO_INCREMENT, 
  code VARCHAR(6) NOT NULL, 
  name VARCHAR(255) NOT NULL,  
  PRIMARY KEY (id),
  UNIQUE KEY (code)
);
--
--  BRANCHES ENTITY TABLE
--  +---------------+--------------+------+-----+---------+----------------+
--  | Field         | Type         | Null | Key | Default | Extra          |
--  +---------------+--------------+------+-----+---------+----------------+
--  | id            | int          | NO   | PRI | NULL    | auto_increment |
--  | parent_system | int          | YES  | MUL | NULL    |                |
--  | code          | varchar(6)   | NO   |     | NULL    |                |
--  | name          | varchar(255) | NO   |     | NULL    |                |
--  | address       | varchar(255) | NO   |     | NULL    |                |
--  +---------------+--------------+------+-----+---------+----------------+
CREATE TABLE Branches (
  id INT NOT NULL AUTO_INCREMENT, 
  parent_system INT NOT NULL, 
  code VARCHAR(6) NOT NULL, 
  name VARCHAR(255) NOT NULL, 
  address VARCHAR(255) NOT NULL, 
  PRIMARY KEY (id), 
  UNIQUE KEY (parent_system, code), 
  FOREIGN KEY (parent_system) REFERENCES Library_systems (id) ON DELETE CASCADE
);
--
--  PEOPLE ENTITY TABLE:
--  +-------------+--------------+------+-----+---------+----------------+
--  | Field       | Type         | Null | Key | Default | Extra          |
--  +-------------+--------------+------+-----+---------+----------------+
--  | id          | int          | NO   | PRI | NULL    | auto_increment |
--  | home_branch | int          | YES  | MUL | NULL    |                |
--  | last_name   | varchar(255) | NO   | MUL | NULL    |                |
--  | first_name  | varchar(255) | YES  |     | NULL    |                |
--  | suffix      | varchar(255) | YES  |     | NULL    |                |
--  +-------------+--------------+------+-----+---------+----------------+
CREATE TABLE People (
  id INT NOT NULL AUTO_INCREMENT, 
  home_branch INT, 
  last_name VARCHAR(255) NOT NULL, 
  first_name VARCHAR(255), 
  suffix VARCHAR(255), 
  PRIMARY KEY (id), 
  UNIQUE KEY (last_name, first_name, suffix), 
  FOREIGN KEY (home_branch) REFERENCES Branches (id) ON DELETE SET NULL
);
--
--  CATALOG_ITEMS ENTITY TABLE:
--  +-------------+--------------+------+-----+---------+----------------+
--  | Field       | Type         | Null | Key | Default | Extra          |
--  +-------------+--------------+------+-----+---------+----------------+
--  | id          | int          | NO   | PRI | NULL    | auto_increment |
--  | author      | int          | YES  | MUL | NULL    |                |
--  | call_number | varchar(255) | NO   | UNI | NULL    |                |
--  | title       | varchar(255) | YES  |     | NULL    |                |
--  +-------------+--------------+------+-----+---------+----------------+
CREATE TABLE Catalog_items (
  id INT NOT NULL AUTO_INCREMENT, 
  author INT, 
  call_number VARCHAR(255) NOT NULL, 
  title VARCHAR(255), 
  PRIMARY KEY (id), 
  UNIQUE KEY (call_number), 
  FOREIGN KEY (author) REFERENCES People (id) ON DELETE SET NULL
);
--
--  ITEM_COPIES INTERSECTION TABLE:
--  +--------------+--------------+------+-----+---------+----------------+
--  | Field        | Type         | Null | Key | Default | Extra          |
--  +--------------+--------------+------+-----+---------+----------------+
--  | id           | int          | NO   | PRI | NULL    | auto_increment |
--  | catalog_item | int          | YES  | MUL | NULL    |                |
--  | home_branch  | int          | YES  | MUL | NULL    |                |
--  | barcode      | varchar(255) | NO   | UNI | NULL    |                |
--  | status       | int          | NO   |     | NULL    |                |
--  | circs        | int          | YES  |     | NULL    |                |
--  +--------------+--------------+------+-----+---------+----------------+
CREATE TABLE Item_copies (
  id INT NOT NULL UNIQUE AUTO_INCREMENT, 
  catalog_item INT NOT NULL, 
  home_branch INT NOT NULL, 
  barcode VARCHAR(255) NOT NULL, 
  status INT NOT NULL, 
  circs INT, 
  PRIMARY KEY (id), 
  UNIQUE KEY (barcode), 
  FOREIGN KEY (catalog_item) REFERENCES Catalog_items (id) ON DELETE CASCADE, 
  FOREIGN KEY (home_branch) REFERENCES Branches (id) ON DELETE CASCADE
);
--
--  LIBRARY_SYSTEMS EXAMPLE DATA:
--  +----+------+----------------------------------+
--  | id | code | name                             |
--  +----+------+----------------------------------+
--  |  1 | SAS  | Sassafras County Public Library  |
--  |  2 | STO  | Stone Creek Public Library       |
--  |  3 | KIL  | Killbuck District Public Library |
--  +----+------+----------------------------------+
INSERT INTO Library_systems (code, name) 
VALUES 
  (
    'SAS', 'Sassafras County Public Library'
  ), 
  (
    'STO', 'Stone Creek Public Library'
  ), 
  (
    'KIL', 'Killbuck District Public Library'
  );
--
--  BRANCHES EXAMPLE DATA:
--  +----+---------------+------+-------------------------+--------------------------------------+
--  | id | parent_system | code | name                    | address                              |
--  +----+---------------+------+-------------------------+--------------------------------------+
--  |  1 |             1 | MAI  | Warsaw (Main)           | 7898 Woodbury Rd, Warsaw, Edon       |
--  |  2 |             1 | ASH  | Ashton Cast Iron Museum | 7462 Dexter City Rd, Ashton, Edon    |
--  |  3 |             2 | ROSA | Rosa's General Store    | 42 Rt 291, Stone Creek, Edon         |
--  |  4 |             3 | RED  | Redoak                  | 5688 Richardson Rd, Blue Creek, Edon |
--  +----+---------------+------+-------------------------+--------------------------------------+
INSERT INTO Branches (
  parent_system, code, name, address
) 
VALUES 
  (
    (
      SELECT 
        id 
      FROM 
        Library_systems 
      WHERE 
        code = 'SAS'
    ), 
    'MAI', 
    'Warsaw (Main)', 
    '7898 Woodbury Rd, Warsaw, Edon'
  ), 
  (
    (
      SELECT 
        id 
      FROM 
        Library_systems 
      WHERE 
        code = 'SAS'
    ), 
    'ASH', 
    'Ashton Cast Iron Museum', 
    '7462 Dexter City Rd, Ashton, Edon'
  ), 
  (
    (
      SELECT 
        id 
      FROM 
        Library_systems 
      WHERE 
        code = 'STO'
    ), 
    'ROSA', 
    'Rosa''s General Store', 
    '42 Rt 291, Stone Creek, Edon'
  ), 
  (
    (
      SELECT 
        id 
      FROM 
        Library_systems 
      WHERE 
        code = 'KIL'
    ), 
    'RED', 
    'Redoak', 
    '5688 Richardson Rd, Blue Creek, Edon'
  );
--
--  PEOPLE EXAMPLE DATA
--  +----+-------------+------------+------------+--------+
--  | id | home_branch | last_name  | first_name | suffix |
--  +----+-------------+------------+------------+--------+
--  |  1 |           1 | Moore      | Chester    | Jr     |
--  |  2 |           2 | Narins     | Rachael    | NULL   |
--  |  3 |        NULL | Lawndale   | NULL       | NULL   |
--  |  4 |           4 | Lapseritis | Jack       | NULL   |
--  +----+-------------+------------+------------+--------+
INSERT INTO People (
  home_branch, last_name, first_name, 
  suffix
) 
VALUES 
  (
    (
      SELECT 
        id 
      FROM 
        Branches 
      WHERE 
        code = 'MAI' 
        AND parent_system =(
          SELECT 
            id 
          FROM 
            Library_systems 
          WHERE 
            code = 'SAS'
        )
    ), 
    'Moore', 
    'Chester', 
    'Jr'
  ), 
  (
    (
      SELECT 
        id 
      FROM 
        Branches 
      WHERE 
        code = 'ASH' 
        AND parent_system =(
          SELECT 
            id 
          FROM 
            Library_systems 
          WHERE 
            code = 'SAS'
        )
    ), 
    'Narins', 
    'Rachael', 
    NULL
  ), 
  (NULL, 'Lawndale', NULL, NULL), 
  (
    (
      SELECT 
        id 
      FROM 
        Branches 
      WHERE 
        code = 'RED' 
        AND parent_system =(
          SELECT 
            id 
          FROM 
            Library_systems 
          WHERE 
            code = 'KIL'
        )
    ), 
    'Lapseritis', 
    'Jack', 
    NULL
  );
--
--  CATALOG_ITEMS EXAMPLE DATA:
--  +----+--------+-----------------+------------------------------------------------+
--  | id | author | call_number     | title                                          |
--  +----+--------+-----------------+------------------------------------------------+
--  |  1 |      1 | CD 100.01, v1   | Sasquatch Secrets, Vol. 1                      |
--  |  2 |      2 | COOKBOOK 231.04 | Cast Iron: The Ultimate Cookbook               |
--  |  3 |      3 | CD 100.2319     | Sasquatch Rock                                 |
--  |  4 |      4 | BK 2018.231     | The Psychic Sasquatch and Their UFO Connection |
--  +----+--------+-----------------+------------------------------------------------+
INSERT INTO Catalog_items (author, call_number, title) 
VALUES 
  (
    (
      SELECT 
        id 
      FROM 
        People 
      WHERE 
        last_name = 'Moore' 
        AND first_name = 'Chester' 
        AND suffix = 'Jr'
    ), 
    'CD 100.01, v1', 
    'Sasquatch Secrets, Vol. 1'
  ), 
  (
    (
      SELECT 
        id 
      FROM 
        People 
      WHERE 
        last_name = 'Narins' 
        AND first_name = 'Rachael' 
        AND suffix IS NULL
    ), 
    'COOKBOOK 231.04', 
    'Cast Iron: The Ultimate Cookbook'
  ), 
  (
    (
      SELECT 
        id 
      FROM 
        People 
      WHERE 
        last_name = 'Lawndale' 
        AND first_name IS NULL 
        AND suffix IS NULL
    ), 
    'CD 100.2319', 
    'Sasquatch Rock'
  ), 
  (
    (
      SELECT 
        id 
      FROM 
        People 
      WHERE 
        last_name = 'Lapseritis' 
        AND first_name = 'Jack' 
        AND suffix IS NULL
    ), 
    'BK 2018.231', 
    'The Psychic Sasquatch and Their UFO Connection'
  );
--
--  ITEM_COPIES EXAMPLE DATA:
--  +----+--------------+-------------+-----------+--------+-------+
--  | id | catalog_item | home_branch | barcode   | status | circs |
--  +----+--------------+-------------+-----------+--------+-------+
--  |  1 |            4 |           1 | 100013234 |    100 |    23 |
--  |  2 |            4 |           1 | 100013235 |    200 |    41 |
--  |  3 |            4 |           4 | A23973    |    100 |    39 |
--  |  4 |            2 |           2 | 100023414 |    100 |    92 |
--  +----+--------------+-------------+-----------+--------+-------+
INSERT INTO Item_copies (
  catalog_item, home_branch, barcode, 
  status, circs
) 
VALUES 
  (
    (
      SELECT 
        id 
      FROM 
        Catalog_items 
      WHERE 
        call_number = 'BK 2018.231'
    ), 
    (
      SELECT 
        id 
      FROM 
        Branches 
      WHERE 
        code = 'MAI' 
        AND parent_system =(
          SELECT 
            id 
          FROM 
            Library_systems 
          WHERE 
            code = 'SAS'
        )
    ), 
    '100013234', 
    100, 
    23
  ), 
  (
    (
      SELECT 
        id 
      FROM 
        Catalog_items 
      WHERE 
        call_number = 'BK 2018.231'
    ), 
    (
      SELECT 
        id 
      FROM 
        Branches 
      WHERE 
        code = 'MAI' 
        AND parent_system =(
          SELECT 
            id 
          FROM 
            Library_systems 
          WHERE 
            code = 'SAS'
        )
    ), 
    '100013235', 
    200, 
    41
  ), 
  (
    (
      SELECT 
        id 
      FROM 
        Catalog_items 
      WHERE 
        call_number = 'BK 2018.231'
    ), 
    (
      SELECT 
        id 
      FROM 
        Branches 
      WHERE 
        code = 'RED' 
        AND parent_system =(
          SELECT 
            id 
          FROM 
            Library_systems 
          WHERE 
            code = 'KIL'
        )
    ), 
    'A23973', 
    100, 
    39
  ), 
  (
    (
      SELECT 
        id 
      FROM 
        Catalog_items 
      WHERE 
        call_number = 'COOKBOOK 231.04'
    ), 
    (
      SELECT 
        id 
      FROM 
        Branches 
      WHERE 
        code = 'ASH' 
        AND parent_system =(
          SELECT 
            id 
          FROM 
            Library_systems 
          WHERE 
            code = 'SAS'
        )
    ), 
    '100023414', 
    100, 
    92
  );
