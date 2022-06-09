-- select_library_systems.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Returns rows from Library_systems table in ascending order by their
-- human-readable system code.
--
-- Returns rows of with the following keys: id, code, name.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    SELECT
        id,
        code,
        name 
    FROM
        Library_systems 
    ORDER BY
        code ASC;
