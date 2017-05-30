USE [csis_db]
GO
/****** Object:  StoredProcedure [dbo].[sel_course_roster]    Script Date: 5/30/2017 4:44:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sel_course_roster]

@pSectionTUID int
AS
BEGIN

	SET NOCOUNT ON;

	-- So we have the course. Naturally, we join the course with enrollment, then join enrollment with students,
	-- then join that with users so we get even more information
	SELECT u.UserID, Fname, Lname, Major, Minor, Email, "address", city, "state", zip 
	FROM CourseSection cs
		INNER JOIN Enrollment e ON cs.SectionTUID = e.SectionTUID
		INNER JOIN Student s ON e.StudID = s.UserID
		INNER JOIN "User" u ON u.UserID = s.UserID
	WHERE cs.SectionTUID = @pSectionTUID

END
