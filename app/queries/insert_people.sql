-- insert_people.sql
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==
--
-- Inserts a new row into People table.
--
-- Strings within curly brackets are replaced with user data.
--
-- ==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==

    INSERT 
    INTO
        People
        (home_branch, last_name, first_name, suffix) 
    VALUES
        ({branch}, "{last}", "{first}", "{suffix}");
	
