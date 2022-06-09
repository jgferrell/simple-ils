-- select_item_copies.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Returns rows from Item_copies table in ascending order by the
-- item's home branch and then barcode.
--
-- Conducts two joins: first between Item_copies and Branches, so we
-- can get the branch code and the parent system id; second between
-- Branches and Library systems, so that we can get the parent system
-- code.
--
-- Returns rows of branch information with the following keys: id,
-- barcode, status, circs, catalog_items, home_branch_code, and
-- home_branch_name.
--
-- The column home_branch_code contains the full system code of the
-- item's home branch (i.e., the branch code preceded by the parent
-- system code). The column home_branch_name contains the name of the
-- item's home branch preceded by the name of the branch's parent
-- system.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    SELECT
        Item_copies.id,
        Item_copies.barcode,
        Item_copies.status,
        Item_copies.circs,
        Item_copies.catalog_item,
	Item_copies.home_branch AS home_branch_id,
        CONCAT_WS("-",
            Library_systems.code,
            Branches.code
        ) AS home_branch_code,
        CONCAT_WS(": ",
            Library_systems.name,
            Branches.name
        ) AS home_branch_name 
    FROM
        Item_copies 
    LEFT JOIN
        Catalog_items 
            ON Item_copies.catalog_item=Catalog_items.id 
    LEFT JOIN
        Branches 
            ON Item_copies.home_branch=Branches.id 
    LEFT JOIN
        Library_systems 
            ON Branches.parent_system=Library_systems.id
    /* WHERE */
    ORDER BY home_branch_code, Item_copies.barcode ASC;
