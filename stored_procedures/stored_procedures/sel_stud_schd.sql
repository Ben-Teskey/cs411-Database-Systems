USE [csis_db]
GO
/****** Object:  StoredProcedure [dbo].[select_stud_schd]    Script Date: 5/30/2017 4:49:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[select_stud_schd] 
@pUserID AS smallint
AS
BEGIN

	SET NOCOUNT ON;

	IF @pUserID IN (SELECT UserID FROM Student)
	BEGIN

		-- Select the student's schedule from all relevant tables
		SELECT Semester, cs.CourseNumber, CourseName, Credits, "Description", "day", startTime, endTime  FROM Enrollment e
			INNER JOIN CourseSection cs ON e.SectionTUID = cs.SectionTUID
			INNER JOIN Course c ON cs.CourseNumber = c.CourseNumber
			INNER JOIN TimeTable t ON cs.TimesTUID = t.TimesTUID
			WHERE StudID = @pUserID
	END

END
