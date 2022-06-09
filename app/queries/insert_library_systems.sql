-- insert_branches.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Inserts a new row into Library_systems table.
--
-- Strings within curly brackets are replaced with user data.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    INSERT 
    INTO
        Library_systems
        (code, name) 
    VALUES
        ("{code}", "{name}");
	
