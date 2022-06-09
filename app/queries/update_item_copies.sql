-- update_item_copies.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Updates selected rows in the Item_copies table.
--
-- Strings within curly brackets are replaced with user data.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    UPDATE
        Item_copies 
    SET
        barcode="{barcode}",
        status={status},
        circs={circs},
	home_branch={home_branch},
        catalog_item={catalog_item}
    /* WHERE */;
