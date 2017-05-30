USE [csis_db]
GO
/****** Object:  StoredProcedure [dbo].[sel_office_hours]    Script Date: 5/30/2017 4:44:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sel_office_hours]
@pUserID smallint
AS
BEGIN

	SET NOCOUNT ON;

	-- First, make sure the user entered is a student
	IF @pUserID IN (SELECT UserID FROM Student)
		BEGIN

			-- Start with enrollment, then branch out to course sections and go from there
			SELECT CourseName, RoomNumber, "day", startTime, endTime FROM Enrollment e 
				INNER JOIN CourseSection cs ON e.SectionTUID = cs.SectionTUID
				INNER JOIN Course c ON cs.CourseNumber = c.CourseNumber
				INNER JOIN Faculty f ON cs.ProfID = f.UserID
				INNER JOIN TimeTable t ON f.TimesTUID = t.TimesTUID
			WHERE e.StudID = @pUserID
		
		END

END
