----------------------------------------------
-- transactions

START TRANSACTION;
SAVEPOINT my_savepoint;
ROLLBACK TO my_savepoint;
COMMIT;

----------------------------------------------
-- procedure / while loop

DELIMITER //
CREATE PROCEDURE example_while_loop(IN n int)
BEGIN
    DECLARE i INT DEFAULT 0;

    WHILE i < n DO

    END WHILE;
    
END //
DELIMITER ;

CALL example_while_loop();


----------------------------------------------
-- exporting db 

& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump" -u skubi -p tda > tda_backup.sql
