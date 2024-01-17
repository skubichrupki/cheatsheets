-- table to log the debug procedure result 
CREATE TABLE table_Debug
( debug_ID INT PRIMARY KEY IDENTITY (1,1), 
test_ID INT,
test_description VARCHAR(50),
test_flag INT ,
flag_description VARCHAR(50),
test_user VARCHAR(50),
DATE datetime )

-- constraint to test the procedure
ALTER TABLE table_Debug
ADD CONSTRAINT check_test_flag CHECK (test_flag IN (0,1))

-- proc - insert the 3 parameters defined during exec by user
GO
CREATE PROCEDURE usp_table_Debug @test_ID INT, @test_flag INT, @test_description VARCHAR(50)
AS 
BEGIN
	INSERT INTO db_test.dbo.table_debug (
		test_ID, 
		test_flag,
		test_description,
		flag_description,
		DATE,
		test_user)
	VALUES ( 
		@test_ID,
		@test_flag,
		@test_description,
		CASE 
			WHEN @test_flag = 1 THEN 'success'
			WHEN @test_flag = 0 THEN 'fail'
		END,
		getdate(),
		suser_sname())
END 

-- test 1
GO
BEGIN TRY
	INSERT INTO table_Debug (test_flag, DATE)
	VALUES (3, getdate())
	-- show result in tmp table and exec the proc
	SELECT 'test 1 - success' AS message
	EXEC usp_table_debug @test_id = 1, @test_flag = 1, @test_description = 'insert test'
END TRY
BEGIN CATCH
	-- show result in tmp table and exec the proc
	SELECT 'test 1 - failed' AS message
	EXEC usp_table_debug @test_id = 1, @test_flag = 0, @test_description = 'insert test'
END CATCH

-- test result
SELECT * FROM table_debug



