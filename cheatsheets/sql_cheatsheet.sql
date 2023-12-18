USE db
GO

-----------------------------------------------
-- CREATE TABLE
-----------------------------------------------
CREATE TABLE MyApp_Main
(
	-- DEFINE columns
	Table_ID INT PRIMARY KEY IDENTITY (1,1),
	Description VARCHAR(50)
)
-- OR FROM existing TABLE
SELECT *
INTO new_table
FROM existing_table

-----------------------------------------------
--INSERT DATA TO TABLE
-----------------------------------------------
INSERT INTO MyApp_Table
	(Description)
VALUES
	('ASAP'),
	( 'Earliest Payment Run'),
	( 'Specific Date')
--OR
INSERT INTO MyApp_Table
	(Description, ShortDesc)
VALUES
	('ASAP', 'ASAP'),
	( 'Earliest Payment Run', 'EPR'),
	( 'Specific Date', 'SPEC DATE')

-----------------------------------------------
--ADD/REMOVE COLUMN TO TABLE
-----------------------------------------------
ALTER TABLE MyApp_Head
ADD Table_ID VARCHAR(50)

ALTER TABLE Customers
DROP COLUMN ContactName;

-----------------------------------------------
--UPDATE DATA IN A TABLE
-----------------------------------------------
UPDATE MyApp_Table
SET isUnderage = 1
WHERE AGE < 18

-----------------------------------------------
-- AGGREGATE FUNCTIONS
-----------------------------------------------
SELECT
	COUNT(Amount),
	SUM(Amount),
	MAX(Amount),
	MIN(Amount),
	AVG(Amount)

-----------------------------------------------
-- DECLARING VARIABLES
-----------------------------------------------
DECLARE @StartTime AS TIME
SET @StartTime = '08:00'
-- WITHOUT SET
DECLARE @StartTime AS TIME = '08:00'
-- SUBQUERY
DECLARE @StartTime AS DATE
SET @StartTime = (
	SELECT TOP 1
	ROW_INS_UTC_DATE
FROM MyApp_Table
WHERE Person_ID = 123
ORDER BY ROWS_INS_UTC_DATE DESC
)
-- CAST
DECLARE @StartTime AS datetime
SET @StartTime = CAST(@ROW_INS_UTC_DATE AS datetime) + CAST(@ROW_INS_UTC_TIME AS datetime)
-- TABLES
DECLARE @CompleteDates TABLE (
	Main_ID INT,
	CompleteDate datetime
)
-- Now INSERT the VALUES INTO the TABLE variable
INSERT INTO @CompleteDates
	(Main_ID, CompleteDate)
VALUES
	(100, '07/05/1999')
-- OR SELECT
INSERT INTO @CompleteDates
	(Main_ID, CompleteDate)
SELECT DISTINCT 100, CAST (ROW_INS_UTC_DATE AS datetime)
FROM MyApp_Table

-----------------------------------------------
-- TRIGGERS
-----------------------------------------------
-- DML: INSERT, UPDATE, DELETE (data manipulation lang)
-- DDL: CREATE, ALTER, DROP (data definition lang)
-- LOGON: LOGON
-------- behaviours:
-- AFTER,
GO
CREATE TRIGGER TrackRetiredProducts
ON products
AFTER DELETE
AS
	INSERT INTO RetiredProducts (Product, Measure)
	SELECT Product, Measure
	FROM deleted;

-- instead of
GO
CREATE TRIGGER MyApp_InsteadDelete
ON MyApp_Main
INSTEAD OF DELETE
AS
	PRINT('DELETE FROM MyApp_Main IS FORBIDDEN')

------------------------ send email ON insert 
GO
CREATE TRIGGER Sales_AfterInfo
ON Sales
AFTER INSERT
AS
	INSERT INTO ProductsHistory
	(Product, Price, Currency, FirstAdded)
	SELECT Product, Price, Currency, GETDATE()
	FROM inserted;
	EXEC sp_cleansing @Table = 'XD'
	EXEC sp_generateSalesReport 
	EXEC sp_sendNotification

------------------------ JOIN two tables during UPDATE
GO
CREATE TRIGGER [XDXD]
ON sales
AFTER INSERT
AS 
	UPDATE sales -- i guess sales can be replaced BY 'inserted'
	SET sales.amount = sales.quantity * pricing.price
	FROM sales AS sal
	INNER JOIN pricing AS pric 
	ON sal.item = pric.item
	WHERE sal.amount IS NULL

------------------------ CREATE the TRIGGER to log TABLE info
GO
CREATE TRIGGER TrackTableChanges
ON DATABASE
FOR CREATE_TABLE,
	ALTER_TABLE,
	DROP_TABLE
AS
	INSERT INTO TablesChangeLog (EventData, ChangedBy)
    VALUES (EVENTDATA(), USER);

------------------------ ADD a TRIGGER to DISABLE the removal of tables
GO
CREATE TRIGGER PreventTableDeletion
ON DATABASE
FOR DROP_TABLE
AS
	RAISERROR ('You ARE NOT allowed to remove tables FROM this database.', 16, 1);
    -- Revert the statement that removes the TABLE
    ROLLBACK;

------------------------ INTERESTING SECURITY TRIGGER
GO
CREATE TRIGGER OrdersAudit
ON Orders
AFTER INSERT, UPDATE, DELETE
AS
	DECLARE @Insert BIT = 0;
	DECLARE @Delete BIT = 0;
	IF EXISTS (SELECT * FROM inserted) SET @Insert = 1;
	IF EXISTS (SELECT * FROM deleted) SET @Delete = 1;
	INSERT INTO TablesAudit (TableName, EventType, UserAccount, EventDate)
	SELECT 'Orders' AS TableName
	       ,CASE WHEN @Insert = 1 AND @Delete = 0 THEN 'INSERT'
				 WHEN @Insert = 1 AND @Delete = 1 THEN 'UPDATE'
				 WHEN @Insert = 0 AND @Delete = 1 THEN 'DELETE'
				 END AS EVENT
		   ,ORIGINAL_LOGIN() AS UserAccount
		   ,GETDATE() AS EventDate;
------------------------ ANOTHER FUNKY TRIGGER
GO
ALTER TRIGGER ConfirmStock
ON Orders
INSTEAD OF INSERT
AS
	IF EXISTS (SELECT *
			   FROM Products AS p
			   INNER JOIN inserted AS i ON i.Product = p.Product
			   WHERE p.Quantity < i.Quantity)
	BEGIN
		RAISERROR ('You cannot place orders WHEN there IS no stock for the order''s product.', 16, 1);
	END
	ELSE
	BEGIN
		INSERT INTO Orders (OrderID, Customer, Product, Price, Currency, Quantity, WithDiscount, Discount, OrderDate, TotalAmount, Dispatched)
		SELECT OrderID, Customer, Product, Price, Currency, Quantity, WithDiscount, Discount, OrderDate, TotalAmount, Dispatched 
		FROM inserted;
	END;

------------------------ DROPING TRIGGERS
GO
DISABLE TRIGGER tr_updateMyAppTable -- ON TABLE lvl
ON MyAppTable

GO
ENABLE TRIGGER tr_updateMyAppTable -- ON TABLE lvl
ON MyAppTable

GO
DISABLE TRIGGER tr_showTableChanges
ON DATABASE

GO
DROP TRIGGER tr_updateMyAppTable -- ON TABLE lvl

GO
DROP TRIGGER tr_showTableChanges
ON ALL SERVER

------------------------ Check trigger executions log
SELECT * FROM sys.dm_exec_trigger_stats

-----------------------------------------------
-- WHILE LOOPS
-----------------------------------------------
 DECLARE @x INT = 1
 while @x <= 3
 BEGIN
	 INSERT INTO db_test.dbo.zzz_ms_tmp (tmp_id, randomNum, insert_datetime)
	 VALUES (@x, CAST(rand()*100 AS INT), getdate())
	 SET @x = @x + 1
END

-----------------------------------------------
-- SYSTEM STUFF / SERVER / DATABASE (triggers)
-----------------------------------------------
-- VIEW all triggers ON DATABASE
SELECT * 
FROM sys.triggers

SELECT *
FROM sys.server_triggers 
--- VIEW body of triggers
SELECT OBJECT_DEFINITION (OBJECT_ID('MyApp_InsteadDelete'))

-- get info about triggers on server
SELECT *
FROM sys.server_triggers

SELECT *
FROM sys.trigger_event_types

-- ultimate trigger check
select *
from sys.triggers as t
inner join sys.trigger_events as te on te.object_id = t.object_id
left outer join sys.objects as o on o.object_id = t.parent_id


-----------------------------------------------
-- CASE
-----------------------------------------------
SELECT
(CASE 
    WHEN x < 3 THEN result1
    WHEN y LIKE '%xd' THEN result2
    ELSE result3
END) AS result_column

-----------------------------------------------
-- WINDOWS FUNCTIONS (OVER)
-----------------------------------------------
-- ranking
SELECT
ROW_NUMBER(), -- NOT require ORDER BY
rank(),
dense_rank(),
-- analytical
lead(),
lag(),
ntile(),
first_value(),
last_value(),
nth_value(),
-- distrib
percent_rank(),
cume_dist(),
-- aggregate - dont require ORDER BY
AVG(),
COUNT(),
MAX(),
MIN(),
SUM()

-----------------------------------------------
-- IF, ELSE
-----------------------------------------------
IF OBJECT_ID('HR.Employees') IS NULL --this OBJECT EXISTS
	BEGIN
		PRINT 'The OBJECT does NOT exist';
	END
ELSE
	BEGIN
		PRINT 'The OBJECT exists';
	END;
---
IF EXISTS (SELECT * FROM Sales.EmpOrders WHERE empid =5)
	BEGIN
		PRINT 'Employee has associated orders';
	END;

-----------------------------------------------
-- CTE, LEAD, LAG -> num = prev_num = next_num
-----------------------------------------------
WITH cte AS (
  SELECT 
  ID
  ,num
  ,lag(num)
    OVER(ORDER BY ID) AS prev_num
  ,lead(num)
    OVER(ORDER BY ID) AS next_num
  FROM 
    Logs
)
SELECT DISTINCT
  num AS ConsecutiveNums
FROM 
  cte
WHERE 
  num = prev_num
  AND num = next_num
  --1,468,120
-- git test