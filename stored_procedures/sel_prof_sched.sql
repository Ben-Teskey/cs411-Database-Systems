USE [csis_db]
GO
/****** Object:  StoredProcedure [dbo].[sel_prof_schd]    Script Date: 5/30/2017 4:46:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sel_prof_schd]
@pUserID AS smallint
AS
BEGIN

	SET NOCOUNT ON;

	IF @pUserID IN (SELECT UserID FROM Faculty)
	BEGIN

		-- Select professor's schedule not including office hours, using CourseSection, Course, and TimeTable
		SELECT Semester, cs.CourseNumber, cs.SectionNumber, CourseName, "Description", Credits, "day", startTime, endTime FROM CourseSection cs
			INNER JOIN Course c ON cs.CourseNumber = c.CourseNumber
			INNER JOIN TimeTable t ON cs.TimesTUID = t.TimesTUID
			WHERE ProfID = @pUserID
	END

END