------------------------------------------------------
-- PROCEDURE -> INSERT / UPDATE MyApp_Reminder
------------------------------------------------------
-- Procedure to check the requestors/tickets without action for 7 days.
-- Execute every 7 days via job. When same row is INSERTED/UPDATED 3 times, Flag ToBeCanceled is set to 1.
-- Master Data receives then a list with all tickets/requestors to be canceled.

ALTER PROCEDURE usp_MyApp_ReminderUpdate
AS 
BEGIN
	-- CTE -- CHECK requestor AND ticket
	WITH CTE AS (SELECT DISTINCT Main_ID
			,TypeShortDescription
			,Requestor_Name
			,Priority_Description
			,Status_Description
			,Requestor_ID
			,CONVERT(VARCHAR, Log_UTCDate, 106) as Log_UTCDate
			,Creation_Date
			,COUNT(Requestor_ID) OVER(PARTITION BY Requestor_ID) AS ID_count
			FROM [db].[dbo].[MyApp_View_Main]
			WHERE Status_ID <= 3
			AND datediff(DAY,[Log_UTCDate], GETDATE()) > 7)

	-- MERGE: UPDATE OR INSERT data
	-- CONDITION: if Main_ID/person combination in source == in target, ReminderCount adds 1, otherwise set to 1
	MERGE INTO MyApp_Reminder AS target
	USING CTE AS source
	ON source.Main_ID = target.Main_ID AND source.Requestor_ID = target.Person_ID
	WHEN MATCHED THEN
		UPDATE 
		SET target.ReminderCount = target.ReminderCount + 1,
		target.ToBeCanceled = 
		CASE 
			WHEN target.ReminderCount >= 2 THEN 1
			ELSE 0
		END,
		target.lastReminderDate = GETDATE()
	WHEN NOT MATCHED THEN
		INSERT (
			Main_ID, 
			TypeShortDescription,
			Requestor_Name, 
			Priority_Description, 
			Status_Description, 
			Person_ID, 
			[Log_UTCDate],
			Creation_Date,
			ReminderCount, 
			ToBeCanceled, 
			IsCanceled, 
			lastReminderDate
		)
		VALUES (
			source.Main_ID, 
			source.TypeShortDescription, 
			source.Requestor_Name, 
			source.Priority_Description, 
			source.Status_Description, 
			source.requestor_id, 
			CONVERT(VARCHAR, source.Log_UTCDate, 106), 
			source.Creation_Date,
			1, 
			0,
			0, 
			CONVERT(VARCHAR, GETDATE(), 106)+' '+CONVERT(VARCHAR, GETDATE(), 108)
		);

	-- show the target table after UPDATE/INSERT
	BEGIN
		SELECT *
		FROM MyApp_Reminder
		--WHERE ReminderCount >= 3;
		PRINT('Merging MyApp_Reminder...')
		PRINT('Done')
	END
END

------------------------------------------------------
-- TRIGGER -> DELETE FROM MyApp_Reminder
------------------------------------------------------
-- when in row with Main_ID, status_id is changed from 1,2,3
-- then in MyApp_reminder delete Main_ID 

go
CREATE TRIGGER utr_MyApp_ReminderDelete
ON MyApp_Main
AFTER UPDATE
AS 
BEGIN
	IF UPDATE(Status_ID)
	BEGIN
		DELETE FROM MyApp_Reminder
		WHERE Main_ID IN (SELECT Main_ID
				  FROM inserted
				  WHERE Status_ID NOT IN (1,2,3))
	END
END

------------------------------------------------------
-- EXECUTION // CHECKS
------------------------------------------------------
EXEC usp_MyApp_ReminderUpdate

TRUNCATE TABLE MyApp_Reminder
SELECT * FROM MyApp_Reminder

ALTER TABLE MyApp_Reminder
ADD Creation_Date varchar(50)
