USE db 
GO

----------------------------------------------
-- SQL DATA TYPES

INT
DECIMAL, FLOAT,
BIT, money,
DATE, datetime, datetime2

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

-- NEW VALUES
INSERT INTO table_name
	(description, short_description)
VALUES
	('ASAP', 'ASAP'),
	( 'Earliest Payment Run', 'EPR'),
	( 'Specific Date', 'SD')

-- VALUES FROM other TABLE
INSERT INTO table_name
SELECT * 
FROM og_table_name

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
	AVG(Amount),
    AVG(DISTINCT Amount)

-----------------------------------------------
-- VARIABLES

DECLARE @StartTime TIME
SET @StartTime = '08:00'
-- OR 
DECLARE @StartTime TIME = '08:00'

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
	description VARCHAR(50)
)

-----------------------------------------------
-- PROCEDURES

GO
CREATE PROCEDURE usp_table_name_upd (@var1 DATE, @var2 INT)
AS
BEGIN
    UPDATE table_name
    SET complete_date = getdate()
    WHERE status_id = @var2 
    AND begin_date = @var1 
END

-- EXECUTION (calling the procedure)
EXEC usp_table_name_upd @var1='01.01.1999', @var2=69

DECLARE @row_count INT
EXEC @result = usp_table_name_upd @var1='02.01.1999', @var2=420, @row_count_out = @row_count
SELECT @result AS 'result',
@row_count AS 'row_count' -- row_count_out needs to be declared IN the procedure

-----------------------------------------------
-- TRY / CATCH

BEGIN TRY
	INSERT INTO table_debug (test_flag, DATE)
	VALUES (3, getdate())
	SELECT 'test 1 - success' AS message
	EXEC usp_mdmr_debug @test_id = 1, @test_description = 1
END try
BEGIN catch
	SELECT 'test 1 - failed' AS message
	EXEC usp_mdmr_debug @test_id = 1, @test_description = 0
END CATCH

GO
CREATE PROCEDURE dbo.usp_table_name_upd @Error nvarchar(MAX) = NULL OUTPUT
AS
BEGIN
    BEGIN TRY
        DELETE FROM RideSummary
        WHERE DATE = @DateParm
    END TRY
    BEGIN CATCH
        SET @Error = 
        'Error_Number: '+ CAST(ERROR_NUMBER() AS VARCHAR) 
        + 'Error_Severity: '+ CAST(ERROR_SEVERITY() AS VARCHAR) 
        + 'Error_State: ' + CAST(ERROR_STATE() AS VARCHAR) 
        + 'Error_Message: ' + ERROR_MESSAGE() 
        + 'Error_Line: ' + CAST(ERROR_LINE() AS VARCHAR)
    END CATCH
END

-----------------------------------------------
-- CONTRAINTS

ALTER TABLE table_name
ADD CONSTRAINT check_test_flag CHECK (test_flag IN (0,1))

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
BEGIN
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
        END
END

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

-- DROPING/DISABLING TRIGGERS
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

IF EXISTS 
    (SELECT * 
    FROM Sales.EmpOrders 
    WHERE empid =5)
    BEGIN
        PRINT 'Employee has associated orders';
    END;
ELSE
    BEGIN
        PRINT 'Employee doesnt have ANY associated orders';
    END;

-----------------------------------------------
-- WHILE LOOPS

DECLARE @i INT
SET @i = 1
WHILE @i <= 3
BEGIN
    INSERT INTO table_name (table_id, random_num, ins_datetime)
    VALUES (@i, CAST(rand()*100 AS INT), getdate())
    SET @i = @i + 1
END

-----------------------------------------------
-- WINDOW FUNCTIONS

SELECT
ROW_NUMBER(),
RANK(),
DENSE_RANK(),
LEAD(), -- returns data FROM previous ROW IN PARTITION (PB-Opt OB-Mand)
LAG(), -- returns data FROM NEXT ROW IN PARTITION (PB-Opt OB-Mand)
FIRST_VALUE(), -- returns FIRST VALUE IN ORDERED SET (PB-Opt OB-Mand) ROW/RANGE-Opt (LIKE MIN)
LAST_VALUE(), -- returns last VALUE IN ORDERED SET (PB-Opt OB-Mand) ROW/RANGE-Opt (LIKE MAX)
NTILE(),
PERCENT_RANK(),
CUME_DIST(),
-- OVER(PARTITION BY gender, ORDER BY gender RANGE BETWEEN start_boundary AND end_boundary)
-- boundaries
UNBOUNDED PRECEDING, -- FIRST ROW IN PARTITION
UNBOUNDED FOLLOWING, -- last ROW IN PARTITION
'CURRENT' ROW, -- current ROW
PRECEDING, -- previous ROW
FOLLOWING -- NEXT ROW

-----------------------------------------------
-- CTE

WITH cte AS (
    SELECT num_ID
    ,num
    ,lag(num) OVER(ORDER BY ID) AS prev_num
    ,lead(num) OVER(ORDER BY ID) AS next_num
    FROM Logs
)

SELECT num AS three_in_row_num
FROM cte
WHERE num = prev_num
AND num = next_num

----------------------------------------------
-- SQL SYSTEM FUNCTIONS

SELECT
--dates
CAST(GETDATE() AS nvarchar(50)) AS string_date
,CAST('420,69' AS DECIMAL(3,2)) AS string_to_decimal 
,CONVERT(VARCHAR(20), birthdate, 11)
,CONVERT(DECIMAL(3,2), '420.69') AS string_to_decimal -- only IN SQL server
,GETDATE(), GETUTCDATE(), CURRENT_TIMESTAMP, SYSDATETIME(), SYSUTCDATETIME()
,YEAR(@Date), MONTH(@Date), DAY(@Date) 
,DATENAME(DAYOFYEAR, @Date), DATENAME(WEEKDAY, @Date), DATEPART(MONTH, @Date)
,DATEADD(DAY, 14, @Date), DATEDIFF(HOUR, @ins_date, GETDATE())
-- strings
,LEN(@string), CHARINDEX('pizza', 'i LIKE pizza AND burgir', 5) -- third parameter IS optional, USE > 0 OR = 0 (IN WHERE)
,PATINDEX('%[xwq]%', last_name) -- can USE wildcards % _ []
,LOWER(), UPPER()
,LEFT(@mystring, 3), RIGHT(@mystring, 3) -- first/last 3 characters
,LTRIM(@string), RTRIM(@string), TRIM() -- trimming blanks
,REPLACE('I LIKE pizza', 'pizza', 'burgir') -- i LIKE burgir
,SUBSTRING('I LIKE pizza', 7, 5) -- pizza (position, numer of letters)
,CONCAT('string1', 'string2'), CONCAT_WS(' ', 'string1', 'string2') -- IN ws you SELECT a separator
,STRING_AGG(first_name, ',' ) WITHIN GROUP (ORDER BY first_name ASC)-- list of strings - useful WITH GROUP BY (YEAR for example)
,STRING_AGG(CONCAT(first_name, CHAR(13))) -- carriage RETURN
-- mathematical
,ABS(@amount) -- non negative VALUE
,SIGN(@amount) -- RETURN -1,0,1 based IF negative
,CEILING(@amount) -- rounds to TOP
,FLOOR(@amount) -- rounds to bottom
,ROUND(@amount, 2) -- rounds to 2 decimals
,POWER(@amount, 3) -- ^3
,SQUARE(@amount) -- ^2
,SQRT(@amount) -- ^(1/2)

----------------------------------------------
-- USER DEFINED FUNCTIONS
GO
CREATE OR ALTER FUNCTION myFunction()
RETURNS INT
BEGIN
    RETURN 0
END

GO
CREATE FUNCTION dbo.myFunction(@var1 INT)
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT @var1 * 42
    ) 
END 

GO
ALTER FUNCTION myTableFunction(@id INT)
RETURNS TABLE AS RETURN (
    SELECT *
    FROM table_name
    WHERE ID = @id
)




    





