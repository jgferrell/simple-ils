-- where_catalog_title.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Used in conjunction with select_catalog_items.sql to search values
-- in the Catalog_items.title column.
--
-- Strings within curly brackets are replaced with user data.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    WHERE Catalog_items.title LIKE "%{query}%"
