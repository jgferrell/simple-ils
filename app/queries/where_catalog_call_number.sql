-- where_catalog_call_number.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Used in conjunction with select_catalog_items.sql to search values
-- in the Catalog_items.call_number column.
--
-- Strings within curly brackets are replaced with user data.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    WHERE Catalog_items.call_number LIKE "%{query}%"
