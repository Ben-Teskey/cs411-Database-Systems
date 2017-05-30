USE [csis_db]
GO
/****** Object:  StoredProcedure [dbo].[sel_purchase_list]    Script Date: 5/30/2017 4:47:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sel_purchase_list]

@pUserID smallint

AS
BEGIN

	SET NOCOUNT ON;

	-- First check if the user entered is a student
	IF @pUserID IN (SELECT UserID FROM STUDENT)
		BEGIN 

			-- Now, we will perform a series of joins starting from the student's enrollment
			-- to get all of the required materials that they need
			SELECT DISTINCT t.TextISBN, t.Author, t.Title, t.Edition FROM Enrollment e 
				INNER JOIN CourseSection cs ON e.SectionTUID = cs.SectionTUID
				INNER JOIN Textbook t ON cs.TextISBN = t.TextISBN
			WHERE e.StudID = @pUserID

		END

END
