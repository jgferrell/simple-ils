-- select_catalog_items.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Returns rows from Catalog_items table in ascending order by call
-- number.
--
-- Conducts a join between Catalog_items table and People table, so
-- that we can display the author's name instead of their ID number.
--
-- Returns rows of branch information with the following keys: id,
-- call_number, title, author
--
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    SELECT
        Catalog_items.id,
        Catalog_items.call_number,
        Catalog_items.title,
        CONCAT_WS(" ",
                  People.first_name,
                  People.last_name,
                  People.suffix
	) AS author,
	Catalog_items.author as author_id
    FROM
        Catalog_items 
    LEFT JOIN
        People             
            ON Catalog_items.author=People.id
    /* WHERE */
    ORDER BY Catalog_items.call_number ASC;
