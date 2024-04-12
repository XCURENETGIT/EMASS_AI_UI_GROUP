DELIMITER $$
DROP PROCEDURE IF EXISTS ALTER_TB;
CREATE PROCEDURE `ALTER_TB`(IN my_table varchar(50), IN col_name varchar (50), IN sql_query varchar (200))
BEGIN
    IF (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = my_table AND COLUMN_NAME = col_name AND TABLE_SCHEMA = 'EMASSAI')=0 THEN
        BEGIN
            SET @ddl = sql_query;
            PREPARE STMT FROM @ddl;
            EXECUTE STMT;
        END;
    END IF;
END
$$
DELIMITER ;