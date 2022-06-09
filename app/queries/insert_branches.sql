-- insert_branches.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Inserts a new row into Branches table.
--
-- Strings within curly brackets are replaced with user data.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    INSERT 
    INTO
        Branches
        (parent_system, code, name, address) 
    VALUES
        ({parent}, "{code}", "{name}", "{addr}");
	
