-- select_people.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Returns rows from People table in ascending order by the person's
-- last name.
--
-- Returns rows of personal information with the following keys: id,
-- first_name, last_name, suffix, full_name, home_branch_id,
-- home_branch_code.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    SELECT
        People.id,
	    People.first_name,
	    People.last_name,
	    People.suffix,
	    People.home_branch AS home_branch_id,
        CONCAT_WS(" ",
            People.first_name,
            People.last_name,
            People.suffix
        ) AS full_name,
        CONCAT_WS("-",
            Library_systems.code,
            Branches.code
        ) AS home_branch_code,
		CONCAT_WS(": ",
            Library_systems.name,
            Branches.name
        ) AS home_branch_name
    FROM
        People  
    LEFT JOIN
        Branches 
            ON People.home_branch=Branches.id  
    LEFT JOIN
        Library_systems 
            ON Branches.parent_system=Library_systems.id
    /* WHERE */
    ORDER BY
        People.last_name ASC;
