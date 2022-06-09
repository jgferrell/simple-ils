-- where_item_copies_id.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Used in conjunction with select_item_copies.sql to search for
-- copies of a particular catalog item.
--
-- Strings within curly brackets are replaced with user data.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    WHERE Item_copies.id={id}
