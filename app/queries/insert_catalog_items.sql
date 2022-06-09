-- insert_catalog_items.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Inserts a new row into Catalog_items table.
--
-- Strings within curly brackets are replaced with user data.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    INSERT 
    INTO
        Catalog_items
        (author, call_number, title) 
    VALUES
        ("{author}", "{call_number}", "{title}");
