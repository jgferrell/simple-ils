-- where_item_copies_are_catitem.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Used in conjunction with select_item_copies.sql to search for
-- copies of a particular catalog item.
--
-- Strings within curly brackets are replaced with user data.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    WHERE Item_copies.catalog_item={catalog_id}
