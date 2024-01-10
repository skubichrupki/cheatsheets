USE db 
GO

----------------------------------------------
-- SQL DATA TYPES

int
decimal, float,
bit, money,
date, datetime, datetime2

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
CREATE PROCEDURE usp_table_name_upd (@var1 date, @var2 int)
AS
BEGIN
    UPDATE table_name
    SET complete_date = getdate()
    WHERE status_id = @var2 
    AND begin_date = @var1 
END

-- EXECUTION (calling the procedure)
EXEC usp_table_name_upd @var1='01.01.1999', @var2=69

DECLARE @row_count int
EXEC @result = usp_table_name_upd @var1='02.01.1999', @var2=420, @row_count_out = @row_count
SELECT @result as 'result',
@row_count as 'row_count' -- row_count_out needs to be declared in the procedure

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
LEAD(), -- returns data from previous row in partition (PB-Opt OB-Mand)
LAG(), -- returns data from next row in partition (PB-Opt OB-Mand)
FIRST_VALUE(), -- returns first value in ORDERED set (PB-Opt OB-Mand) ROW/RANGE-Opt (like min)
LAST_VALUE(), -- returns last value in ORDERED set (PB-Opt OB-Mand) ROW/RANGE-Opt (like max)
NTILE(),
PERCENT_RANK(),
CUME_DIST(),
-- OVER(PARTITION BY gender, ORDER BY gender RANGE BETWEEN start_boundary AND end_boundary)
-- boundaries
UNBOUNDED PRECEDING, -- first row in partition
UNBOUNDED FOLLOWING, -- last row in partition
'CURRENT' ROW, -- current row
PRECEDING, -- previous row
FOLLOWING -- next row

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
,CAST('420,69' AS decimal(3,2)) AS string_to_decimal 
,CONVERT(varchar(20), birthdate, 11)
,CONVERT(decimal(3,2), '420.69') AS string_to_decimal -- only in sql server
,GETDATE(), GETUTCDATE(), CURRENT_TIMESTAMP, SYSDATETIME(), SYSUTCDATETIME()
,YEAR(@Date), MONTH(@Date), DAY(@Date) 
,DATENAME(DAYOFYEAR, @Date), DATENAME(WEEKDAY, @Date), DATEPART(MONTH, @Date)
,DATEADD(DAY, 14, @Date), DATEDIFF(HOUR, @ins_date, GETDATE())
-- strings
,LEN(@string), CHARINDEX('pizza', 'i like pizza and burgir', 5) -- third parameter is optional, use > 0 or = 0 (in where)
,PATINDEX('%[xwq]%', last_name) -- can use wildcards % _ []
,LOWER(), UPPER()
,LEFT(@mystring, 3), RIGHT(@mystring, 3) -- first/last 3 characters
,LTRIM(@string), RTRIM(@string), TRIM() -- trimming blanks
,REPLACE('I like pizza', 'pizza', 'burgir') -- i like burgir
,SUBSTRING('I like pizza', 7, 5) -- pizza (position, numer of letters)
,CONCAT('string1', 'string2'), CONCAT_WS(' ', 'string1', 'string2') -- in ws you select a separator
,STRING_AGG(first_name, ',' ) WITHIN GROUP (ORDER BY first_name ASC)-- list of strings - useful with GROUP BY (year for example)
,STRING_AGG(CONCAT(first_name, char(13))) -- carriage return
-- mathematical
,ABS(@amount) -- non negative value
,SIGN(@amount) -- return -1,0,1 based if negative
,CEILING(@amount) -- rounds to top
,FLOOR(@amount) -- rounds to bottom
,ROUND(@amount, 2) -- rounds to 2 decimals
,POWER(@amount, 3) -- ^3
,SQUARE(@amount) -- ^2
,SQRT(@amount) -- ^(1/2)

----------------------------------------------
-- USER DEFINED FUNCTIONS
go
CREATE OR ALTER FUNCTION myFunction()
RETURNS int
BEGIN

    RETURN 0
END

go
CREATE OR ALTER FUNCTION myTableFunction(@id int)
RETURNS TABLE AS RETURN (
    SELECT *
    FROM table_name
    WHERE id = @id
)

    






