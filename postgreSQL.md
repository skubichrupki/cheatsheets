``` sql
WITH RECURSIVE cte AS (
    SELECT ...
    UNION ALL
    SELECT ...
    FROM cte
    WHERE ...
)
SELECT * FROM cte;
```

``` sql
CREATE TRIGGER trigger_name
AFTER INSERT ON table_name
FOR EACH ROW
EXECUTE FUNCTION trigger_function();
-- sql server
CREATE TRIGGER trigger_name
ON table_name
AFTER INSERT
AS
BEGIN
    -- Trigger logic
END;
```

``` sql
CREATE TEMP TABLE temp_table (column1 INT, column2 VARCHAR(50));
CREATE TABLE #temp_table (column1 INT, column2 VARCHAR(50)); --sql server
```

``` sql
SELECT CASE WHEN condition THEN result ELSE else_result END;
```
``` sql
SELECT CURRENT_DATE + INTERVAL '1 day';
SELECT DATEADD(day, 1, GETDATE()); --sql server
```
``` sql
BEGIN
    -- SQL statements
EXCEPTION
    WHEN others THEN
        -- Error handling code
END;
-- sql server
BEGIN TRY
    -- SQL statements
END TRY
BEGIN CATCH
    -- Error handling code
END CATCH;
```
``` sql
BEGIN;
-- SQL statements
COMMIT;
--sql server
BEGIN TRANSACTION;
-- SQL statements
COMMIT TRANSACTION;
```
``` sql
SELECT * FROM table_name WHERE column_name ~ 'pattern';
```
``` sql
CREATE TABLE example (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
```
``` sql
SELECT column1 FROM table_name LIMIT 10;
```

``` sql
SELECT column1, SUM(column2) OVER (PARTITION BY column3 ORDER BY column4 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total FROM table_name;
```

``` sql
SELECT TO_TIMESTAMP('2024-05-05', 'YYYY-MM-DD');
```

``` sql
SELECT 'Hello ' || 'World';
```
