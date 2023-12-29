USE db 
GO

----------------------------------------------
-- CREATE TABLE

CREATE TABLE table_name
(
	-- DEFINE columns
	table_ID INT PRIMARY KEY IDENTITY (1,1),
	description VARCHAR(50)
)

-- CREATE TABLE FROM EXISTING TABLE

SELECT *
INTO new_table
FROM existing_table

----------------------------------------------
-- COLUMNS

ALTER TABLE table_name
ADD column_name VARCHAR(50)

ALTER TABLE table_name
DROP COLUMN column_name;

----------------------------------------------
-- INSERT DATA 

INSERT INTO table_name
	(description, short_description)
VALUES
	('ASAP', 'ASAP'),
	( 'Earliest Payment Run', 'EPR'),
	( 'Specific Date', 'SD')

----------------------------------------------
-- UPDATE DATA

UPDATE table_name
SET column_1 = 1
WHERE column_2 < 18

-----------------------------------------------
-- AGGREGATE FUNCTIONS

SELECT
	COUNT(Amount),
	SUM(Amount),
	MAX(Amount),
	MIN(Amount),
	AVG(Amount)

-----------------------------------------------
-- VARIABLES

DECLARE @StartTime AS TIME
SET @StartTime = '08:00'
-- OR 
DECLARE @StartTime AS TIME = '08:00'

-- SET AS SUBQUERY
SET @StartTime = (
    SELECT TOP (1) ROW_INS_UTC_DATE
    FROM table_name
    WHERE Person_ID = 123
)

-- SET AS CAST
SET @StartTime = CAST(ROW_INS_UTC_DATE AS DATETIME) + CAST(@ROW_INS_UTC_TIME AS datetime)

-- TABLE VARIABLE
DECLARE @tmp_table_name TABLE (
	table_ID INT,
	description varchar(50)
)

-----------------------------------------------
-- TRIGGERS

-- AFTER
GO
CREATE TRIGGER tr_myTrigger
ON table_name
AFTER DELETE
AS
BEGIN
	INSERT INTO table_name_deleted (table_id, description, delete_date, delete_user)
	SELECT table_id, description, getdate(), get_suser()
	FROM deleted
    EXEC usp_send_email
END

-- INSTEAD OF
GO
CREATE TRIGGER tr_myTrigger
ON Orders
INSTEAD OF INSERT
AS
	IF EXISTS (SELECT *
			   FROM Products AS p
			   INNER JOIN inserted
               ON inserted.Product = p.Product
			   WHERE p.Quantity < inserted.Quantity)
        BEGIN
            PRINT('You cannot place orders WHEN there IS no product')
        END
	ELSE
        BEGIN
            INSERT INTO Orders (OrderID)
            SELECT OrderID 
            FROM inserted
        END;

-- ON DATABASE
GO
CREATE TRIGGER TrackTableChanges
ON DATABASE
FOR CREATE_TABLE,
	ALTER_TABLE,
	DROP_TABLE
AS
	INSERT INTO TablesChangeLog (EventData, ChangedBy)
    VALUES (EVENTDATA(), USER);

------------------------ DROPING TRIGGERS
GO
DISABLE TRIGGER tr_myTrigger
ON table_name

GO
ENABLE TRIGGER tr_myTrigger
ON table_name

GO
DROP TRIGGER tr_myTrigger

-----------------------------------------------
-- CASE + IF (+ TRIGGERS)

DECLARE @Insert BIT = 0;
DECLARE @Delete BIT = 0;
IF EXISTS (SELECT * FROM inserted) SET @Insert = 1;
IF EXISTS (SELECT * FROM deleted) SET @Delete = 1;
SELECT table_ID
,CASE 
    WHEN @Insert = 1 AND @Delete = 0 THEN 'INSERT'
    WHEN @Insert = 0 AND @Delete = 1 THEN 'DELETE'
    WHEN @Insert = 1 AND @Delete = 1 THEN 'UPDATE'
END AS EVENT

