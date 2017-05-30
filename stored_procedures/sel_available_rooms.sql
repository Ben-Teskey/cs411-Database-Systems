USE [csis_db]
GO
/****** Object:  StoredProcedure [dbo].[sel_available_rooms]    Script Date: 5/30/2017 4:41:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sel_available_rooms]
@pDateTime datetime
AS
BEGIN

	SET NOCOUNT ON;
	
	-- I'm going to build a temp table that converts the start and end times to time format. 
	-- After all the conversions are said and done, it should be pretty easy to get the information we need.

	-- Another aspect of this, is that the relevant date parts should be extracted from date
	-- time to be used for comparison. Otherwise, the year or the month could throw off the result. 

	-- Declare temp table
	DECLARE @tblTTDateTime TABLE (
		TimesTUID int,
		RoomNumber char(5),
		"day" char(5),
		startTime time,
		endTime time
	);

	Insert INTO @tblTTDateTime
	SELECT TimesTUID, RoomNumber, "day", 
		CONVERT(time, startTime, 108) AS startTime, CONVERT(time, endTime, 108) AS endTime
	FROM TimeTable;

	-- Now, let's partition out this datetime the user passed
	DECLARE @vTime time
	SET @vTime = CAST(@pDateTime AS time);

	DECLARE @vDay char(1)
	SET @vDay = DATEPART(dw, @pDateTime);

	-- Case statement logic to convert numeric day of the week format to letter
	-- day of the week format used in our time table
	SET @vDay = CASE @vDay
		WHEN '1' THEN 'M'
		WHEN '2' THEN 'T'
		WHEN '3' THEN 'W'
		WHEN '4' THEN 'R'
		WHEN '5' THEN 'F'
	ELSE NULL END 

	-- Now this will be a piece of cake
	SELECT RoomNumber, "day", startTime, endTime
	FROM @tblTTDateTime
	WHERE "day" LIKE CONCAT('%', @vDay, '%') AND @vTime BETWEEN startTime AND endTime

END