-- select_branches.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Returns rows from Branches table in ascending order by the branch's
-- full system code (i.e., the branch code preceded by parent system's
-- code).
--
-- Conducts a join between Branches table and Library_systems table,
-- so that we can display human-readable information about each
-- branch's parent system.
--
-- Returns rows of branch information with the following keys: id,
-- code, name, address, parent_system_code, parent_system_name, and
-- full_code.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    SELECT
        Branches.id,
        Library_systems.code AS parent_system_code,
        Library_systems.name AS parent_system_name,
        Branches.code,
        Branches.name,
        Branches.address,
        CONCAT_WS(
            "-",
            Library_systems.code,
            Branches.code
        ) AS full_code
    FROM
        Branches         
    LEFT JOIN
        Library_systems         
            ON Branches.parent_system=Library_systems.id
    /* WHERE */
    ORDER BY
        full_code ASC;
