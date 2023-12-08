USE db_test
GO

------------------------------------------------------
-- Table Schema 
------------------------------------------------------
CREATE TABLE MyApp_open_requests
(
	open_requests_ID INT PRIMARY KEY IDENTITY (1,1),
	complete_person INT,
	complete_person_name VARCHAR(50),
	complete_date VARCHAR(50),
	complete_count INT,
	open_requests INT,
	open_requests_action_required INT,
)

USE db_test
GO
------------------------------------------------------
-- PROCEDURE -> INSERT INTO MyApp_open_requests
------------------------------------------------------
-- Procedure to insert count of done requests by specialists after the shift
-- Execute every day at 18:00 via job. Enters only people that have completed at least one requests that day
CREATE PROCEDURE usp_MyApp_open_requests_upd
AS
BEGIN
	INSERT INTO db_test.dbo.MyApp_open_requests 
	SELECT DISTINCT
	--main.Main_ID
	INSERTED_Person_ID AS complete_person
	,gp.FirstName + ' ' + gp.LastName AS complete_person_name
	,convert(VARCHAR, INSERTED_UTCDate, 106) AS complete_date
	,COUNT(main.Main_ID) OVER (PARTITION BY INSERTED_PERSON_ID) AS complete_count
	,(SELECT 
		COUNT(Main_ID) 
		FROM db.dbo.MyApp_Main
		WHERE Status_ID NOT IN (1000,9999,1)) AS open_requests
	,(SELECT 
		COUNT(Main_ID) 
		FROM db.dbo.MyApp_Main
		WHERE Status_ID IN (900,950,10,1010)) AS open_requests_action_required
	FROM db.dbo.MyApp_Main AS main
	INNER JOIN db.dbo.Global_Person AS gp
	ON gp.Person_ID = main.INSERTED_Person_ID
	WHERE main.Main_ID IN (SELECT Main_ID
							FROM db.dbo.MyApp_log
							WHERE CAST([Log_UTCDate] AS DATE) = CAST(GETDATE() AS DATE)
							AND Status_ID = 1000)
END

------------------------------------------------------
-- EXECUTION // CHECKS
------------------------------------------------------
EXEC usp_MyApp_open_requests_upd
SELECT * FROM MyApp_open_requests
TRUNCATE TABLE MyApp_open_requests