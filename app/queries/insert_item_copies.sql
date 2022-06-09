-- insert_item_copies.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Inserts a new row into Item_copies table.
--
-- Strings within curly brackets are replaced with user data.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    INSERT 
    INTO
        Item_copies
        (catalog_item, home_branch, barcode, status, circs)
    VALUES
    	({catalog_item}, {home_branch}, "{barcode}", {status}, {circs});
