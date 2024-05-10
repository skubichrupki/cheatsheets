### DDL
#### CREATE TABLE
``` sql
CREATE TABLE table_name (
table_ID INT PRIMARY KEY IDENTITY (1,1),
description VARCHAR(50) NOT NULL DEFAULT('empty') 
)
```

#### CREATE TABLE FROM EXISTING TABLE
``` sql
SELECT *
INTO new_table
FROM existing_table
```

#### ALTER
``` sql
ALTER TABLE table_name
ADD column_name VARCHAR(50)
DROP COLUMN column_name;
```

#### CONTRAINTS
``` sql
ALTER TABLE table_name
ADD CONSTRAINT check_test_flag CHECK (test_flag IN (0,1))
ALTER TABLE table_name DROP CONSTRAINT constraint_name;
```

#### DROP
``` sql
DROP TABLE table_name;
DROP VIEW table_v_name;
DROP PROCEDURE procedure_name;
DROP INDEX index_name ON table_name;
DROP SCHEMA schema_name;
``` 

#### FOREIGN KEYS
``` sql
ALTER TABLE table_name 
ADD CONSTRAINT main_person FOREIGN KEY (person_id) REFERENCES table_person (person_ID);
``` 

### DATA TYPES
``` sql
TINYINT, SMALLINT, INT, BIGINT  (1,2,4,8 bytes)
,FLOAT
,DECIMAL(5,2)
,NUMERIC(10,5), 
BIT (0,1) 
,MONEY
,DATE, TIME
,DATETIME (precision to 3ms), SMALLDATETIME (precision to 
,DATETIME2
,TABLE
,UNIQUEIDENTIFIER
,CURSOR
``` 

### VARIABLES
``` sql
DECLARE @StartTime TIME = '08:00'
DECLARE @StartTime TIME
SET @StartTime = '08:00'
SET @StartTime = CAST(ROW_INS_UTC_DATE AS DATETIME) + CAST(@ROW_INS_UTC_TIME AS datetime)

-- assign the value from record to variable
SET @LastOrder = (
    SELECT TOP (1) created_on
    FROM order WHERE isActive = 1 ORDER BY created_on DESC
) 

DECLARE @tmp_table_name TABLE (
    table_ID INT,
    description VARCHAR(50)
)
``` 

### DML
#### INSERT 
``` sql
INSERT INTO table_name
    (description, short_description)
VALUES
    ('ASAP', 'ASAP'),
    ( 'Earliest Payment Run', 'EPR'),
    ( 'Specific Date', 'SD')
``` 

#### VALUES FROM EXISTING TABLE
``` sql
INSERT INTO table_name
SELECT * 
FROM og_table_name
``` 

### UPDATE
``` sql
UPDATE table_name
SET column_1 = 1
WHERE column_2 < 18
``` 

### JOINS
``` sql
FROM sys.views as v
INNER JOIN sys.sql_modules as m
ON m.object_id = v.object_id
``` 

### UNIONS
``` sql
SELECT query2
FROM query2
UNION
SELECT query2
FROM query2
EXCEPT
SELECT query3
FROM query3

UNION ALL, 
INTERSECT, 
EXCEPT
``` 

### PROCEDURES
``` sql
GO
CREATE PROCEDURE usp_table_name_upd (@var1 DATE, @var2 INT)
AS
BEGIN
    UPDATE table_name
    SET complete_date = getdate()
    WHERE status_id = @var2 
    AND begin_date = @var1 
END

EXEC usp_table_name_upd @var1='01.01.1999', @var2=69

DECLARE @row_count INT
EXEC @result = usp_table_name_upd @var1='02.01.1999', @var2=420, @row_count_out = @row_count
SELECT @result AS 'result'
``` 

### TRY / CATCH ERRORS
``` sql
BEGIN TRY
    INSERT INTO table_debug (test_flag, DATE)
    VALUES (3, getdate())
    SELECT 'test 1 - success' AS message
    EXEC usp_table_debug @test_id = 1, @test_description = 1
END TRY
BEGIN catch
    SELECT 'test 1 - failed' AS message
    EXEC usp_table_debug @test_id = 1, @test_description = 0
END CATCH

GO
CREATE PROCEDURE dbo.usp_table_name_upd
@DateParm DATE;
AS
BEGIN
    BEGIN TRY
        DELETE FROM RideSummary
        WHERE DATE = @DateParm
    END TRY
    BEGIN CATCH
        SELECT
        ERROR_MESSAGE()
        ,CAST(ERROR_NUMBER() AS VARCHAR)
        ,CAST(ERROR_SEVERITY() AS VARCHAR) 
        ,CAST(ERROR_STATE() AS VARCHAR)
        ,CAST(ERROR_LINE() AS VARCHAR)
        ,ERROR_PROCEDURE()
    END CATCH
END
``` 

### ERRORS
``` sql   
-- levels: 0-10: info, 11-16: CONSTRAINT violations etc, 17-24: software, fatal errors
-- 11-19 ARE catchable, >= 20 cant be catched  
``` 

### TRIGGERS
#### AFTER
``` sql
GO
CREATE TRIGGER tr_afterTrigger ON table_name AFTER DELETE
AS
BEGIN
    INSERT INTO table_name_deleted (table_id, description, delete_date, delete_user)
    SELECT table_id, description, getdate(), get_suser()
    FROM deleted
    EXEC usp_send_email
END
``` 

#### INSTEAD OF 
``` sql
GO
CREATE TRIGGER tr_insteadOfTrigger ON table_name INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM Products AS p
            INNER JOIN inserted ON inserted.Product = p.Product
            WHERE p.Quantity < inserted.Quantity)
        BEGIN
            PRINT('not enough product to insert order')
        END
    ELSE
        BEGIN
            INSERT INTO Orders (OrderID)
            SELECT OrderID 
            FROM inserted
        END
END
``` 

#### ON DATABASE
``` sql
CREATE TRIGGER TrackTableChanges
ON DATABASE
FOR CREATE_TABLE,
    ALTER_TABLE,
    DROP_TABLE
AS
    INSERT INTO TablesChangeLog (EventData, ChangedBy)
    VALUES (EVENTDATA(), USER);
``` 

#### ENABLE / DISABLE 
``` sql
DISABLE TRIGGER tr_myTrigger ON table_name
ENABLE TRIGGER tr_myTrigger ON table_name
DROP TRIGGER tr_myTrigger
``` 

### IF EXISTS
``` sql
IF EXISTS (SELECT * FROM inserted) SET @Insert = 1;
IF EXISTS (SELECT * FROM deleted) SET @Delete = 1;
``` 

### IF ELSE
``` sql
IF EXISTS 
    (SELECT * 
    FROM Sales.Employee 
    WHERE Employee_ID IS NOT NULL)
    BEGIN
        PRINT 'null ID values in table';
    END;
ELSE
    BEGIN
        PRINT 'no null ID values in table';
    END;
``` 

### CASE
``` sql
DECLARE @Insert BIT = 0;
DECLARE @Delete BIT = 0;

    SELECT table_ID
    ,CASE 
        WHEN @Insert = 1 AND @Delete = 0 THEN 'INSERT'
        WHEN @Insert = 0 AND @Delete = 1 THEN 'DELETE'
        WHEN @Insert = 1 AND @Delete = 1 THEN 'UPDATE'
    END AS event
```   

### WHILE LOOPS
``` sql
DECLARE @i INT
SET @i = 1
WHILE @i <= 3
BEGIN
    INSERT INTO table_name (table_id, random_num, created_on)
    VALUES (@i, CAST(RAND()*100 AS INT), GETDATE())
    SET @i = @i + 1
END
``` 

### CTE
``` sql
WITH cte AS (
    SELECT num_ID
    ,num
    ,lag(num) OVER(ORDER BY ID) AS prev_num
    ,lead(num) OVER(ORDER BY ID) AS next_num
    FROM Logs
    WHERE condition1 > 10
)

SELECT num AS three_in_row_num (DELETE)
FROM cte
WHERE num = prev_num
AND num = next_num
``` 

### SYSTEM FUNCTIONS
#### WINDOW FUNCTIONS
``` sql
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

UNBOUNDED PRECEDING, -- all rows from the beginning of the partition up to the current row.
UNBOUNDED FOLLOWING, -- all rows from the current row to the end of the partition.
PRECEDING, -- includes a specified number of rows before the current row.
FOLLOWING -- includes a specified number of rows after the current row.
``` 

#### AGGREGATE
``` sql
COUNT(Amount),
SUM(Amount),
MAX(Amount),
MIN(Amount),
AVG(Amount),
AVG(DISTINCT Amount)
``` 

#### DATES 
``` sql
CAST(GETDATE() AS nvarchar(50)) AS string_date
,CAST('420,69' AS DECIMAL(3,2)) AS string_to_decimal 
,CONVERT(VARCHAR(20), birthdate, 11)
,TRY_CONVERT(VARCHAR(20), birthdate, 11) -- nulls the values that didnt work in convert
,CONVERT(DECIMAL(3,2), '420.69') AS string_to_decimal -- only IN SQL server
,PARSE(birthdate AS DATE USING de-de)

,GETDATE()
,GETUTCDATE(), CURRENT_TIMESTAMP
,SYSDATETIME(), SYSUTCDATETIME()
,YEAR(@Date), MONTH(@Date), DAY(@Date) 
,DATEPART(DAYOFYEAR, @Date)
,DATENAME(WEEKDAY, @Date)
,DATEADD(DAY, 14, @Date)
,DATEDIFF(HOUR, @ins_date, GETDATE())

,FORMAT(@Date, 'd', 'pl-PL'), FORMAT(@Date, 'dd-MM-YYYY'), FORMAT(123456, '###-###')
,FORMAT(CAST('2018-01-01 14:00' AS datetime2), N'HH:mm') -- 14:00
``` 

#### STRINGS
``` sql
,LEN(@string)
,CHARINDEX('pizza', 'i LIKE pizza AND burgir', 5) -- third parameter IS optional, USE > 0 OR = 0 (IN WHERE)
,PATINDEX('%[xwq]%', last_name) -- can USE wildcards % _ []
,LOWER(@mystring)
,UPPER(@mystring)
,LEFT(@mystring, 3) -- last 3 characters
,RIGHT(@mystring, 3) -- first 3 characters
,LTRIM(@string)
,RTRIM(@string)
,TRIM() -- trimming blanks
,REPLACE('I LIKE pizza', 'pizza', 'burgir') -- i LIKE burgir
,SUBSTRING('I LIKE pizza', 7, 5) -- pizza (position, numer of letters)
,CONCAT('string1', 'string2'), CONCAT_WS(' ', 'string1', 'string2') -- IN ws you SELECT a separator
,STRING_AGG(first_name, ',' ) WITHIN GROUP (ORDER BY first_name ASC) -- list of strings - useful WITH GROUP BY (YEAR for example)
,STRING_AGG(CONCAT(first_name, CHAR(13))) -- carriage RETURN
``` 

#### MATH 
``` sql
,ABS(@amount) -- non negative VALUE
,SIGN(@amount) -- RETURN -1,0,1 based IF negative
,CEILING(@amount) -- rounds to TOP
,FLOOR(@amount) -- rounds to bottom
,ROUND(@amount, 2) -- rounds to 2 decimals
,POWER(@amount, 3) -- ^3
,SQUARE(@amount) -- ^2
,SQRT(@amount) -- ^(1/2)
,RAND() -- random FROM 0-1, can also be used IN ORDER BY to RETURN random ROWS
``` 

### USER DEFINED FUNCTIONS
``` sql
CREATE OR ALTER FUNCTION myFunction()
RETURNS INT
BEGIN
    RETURN 0
END

CREATE FUNCTION dbo.myFunction(@var1 INT)
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT @var1 * 42
    ) 
END 

ALTER FUNCTION myTableFunction(@id INT)
RETURNS TABLE AS RETURN (
    SELECT *
    FROM table_name
    WHERE ID = @id
)
``` 

### VIEWS
``` sql
CREATE VIEW high_scores AS
SELECT * FROM REVIEWS
WHERE score > 9;

DROP VIEW table_v_main
``` 

#### VIEW VIEWS
``` sql
SELECT * 
FROM information_schema.views

SELECT *
FROM sys.views as v
INNER JOIN sys.sql_modules as m
ON m.object_id = v.object_id
``` 

### TRANSACTIONS
``` sql
BEGIN TRANSACTION my_tran
    DELETE FROM [AdventureWorks2022].[Sales].[Customer]
    WHERE CustomerID = 4

ROLLBACK TRANSACTION my_tran
COMMIT TRANSACTION my_tran
``` 

### INDEXES
``` sql
GO
CREATE VIEW sales_by_region WITH SCHEMABINDING
AS
SELECT region, SUM(sales_amount) AS sales_amount_sum
FROM sales_table
GROUP BY region

GO
CREATE UNIQUE CLUSTERED INDEX IX_sales_by_region
ON sales_by_region (region)
``` 

### PARTITIONING (postgre)
``` sql
CREATE TABLE table_name (
    table_ID INT PRIMARY KEY IDENTITY (1,1),
    ins_date DATE NOT NULL
)
PARTITION BY RANGE (ins_date)
CREATE TABLE table_name_2018 
PARTITION OF table_name (
    FOR VALUES FROM ('01-01-2018') TO ('31-12-2018')
)
CREATE TABLE table_name_2019 
PARTITION OF table_name (
    FOR VALUES IN ('2019');
)
CREATE INDEX ON table_name ('ins_date')
``` 

### MERGE
``` sql
MERGE db_test.dbo.TableName AS TARGET
USING db_test.dbo.TableName_tmp AS source
ON target.Code_ID = source.Code_ID
WHEN MATCHED THEN
    UPDATE
    SET target.Description = source.Description
WHEN NOT MATCHED THEN
    INSERT (Code_ID, Description)
    VALUES (source.Code_ID, source.Description);
``` 

### CHECK TABLE LOG
``` sql
SELECT *
FROM sys.tables AS tables
INNER JOIN sys.dm_db_index_usage_stats AS usage
ON tables.object_id = usage.object_id
WHERE database_id = DB_ID()
AND name LIKE 'myTable'
``` 

#### APPLY
``` sql
-- apply the result of the subquery (in this case, a single-row result) to each row from table_name. 
FROM table_name
CROSS APPLY (
    SELECT my_date = DATEADD(DAY, 7, GETDATE())
) AS my_date_applied
``` 

### open JSON file in SQL view
``` sql
Select JSON_line
FROM my_view as view_data
CROSS APPLY OPENJSON(viewData.JSONLine) WITH (
    Description nvarchar(250),
    DateTime nvarchar(250),
    Process nvarchar(max) AS JSON
) as JSON_level1
CROSS APPLY OPENJSON(JSON_level1.Process) WITH (
    Description nvarchar(250),
    Year int
) as JSON_level2
``` 

### values as a CSV string in one row
``` sql
SELECT sell_date
,COUNT(product)
,STRING_AGG(product, ',') WITHIN GROUP (ORDER BY product asc) AS products 
FROM activities
GROUP BY sell_date
-- works like aggregate function, cannot be used in window functions
``` 

### ADMINISTRATION
#### LOGIN / USER
``` sql
CREATE LOGIN reporting_user WITH PASSWORD = 'myPswrd'
CREATE USER reporting_user FOR LOGIN reporting_user
DROP LOGIN login_name;
DROP USER user_name;
``` 

#### ROLES
``` sql
CREATE ROLE data_analyst
GRANT UPDATE ON sales TO data_analyst
GRANT data_analyst TO reporting_user
REVOKE data_analyst FROM reporting_user
GRANT SELECT, INSERT ON table_v_main TO reporting_user;
REVOKE INSERT ON table_v_main FROM reporting_user;
DROP ROLE data_analyst
```

#### CURSOR
FIRST is used to fetch only the first row from the cursor table. 
LAST is used to fetch only the last row from the cursor table. 
NEXT is used to fetch data in a forward direction from the cursor table. 
PRIOR is used to fetch data in a backward direction from the cursor table. 
ABSOLUTE n is used to fetch the exact nth row from the cursor table. 
RELATIVE n is used to fetch the data in an incremental way as well as a decremental way. 
``` sql
DECLARE s1 CURSOR FOR SELECT * FROM studDetails
OPEN s1
FETCH FIRST FROM s1
FETCH LAST FROM s1
FETCH NEXT FROM s1
FETCH PRIOR FROM s1
FETCH ABSOLUTE 7 FROM s1
FETCH RELATIVE -2 FROM s1
CLOSE s1
```

#### SYSTEM OBJECTS QUERY (views)
``` sql
SELECT *
FROM sys.objects AS obj
INNER JOIN sys.sql_modules as mod
ON obj.object_id = mod.object_id
WHERE obj.type = 'V'
AND mod.definition like '%MDMR%'
```

#### SYSTEM OBJECTS QUERY (tables)
``` sql
SELECT 
tab.name AS table_name,
col.name AS column_name
FROM 
sys.columns AS col
INNER JOIN sys.tables AS tab ON col.object_id = tab.object_id
INNER JOIN sys.types AS typ ON col.user_type_id = typ.user_type_id
WHERE typ.name = 'date'
AND tab.type = 'U' -- filter only user-defined tables
```


