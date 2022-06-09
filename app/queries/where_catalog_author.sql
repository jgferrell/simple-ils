-- where_catalog_author.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Used in conjunction with select_catalog_items.sql to search
-- concatenation of authors' first name, last name, and suffix.
--
-- Strings within curly brackets are replaced with user data.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    HAVING author LIKE "%{query}%"
