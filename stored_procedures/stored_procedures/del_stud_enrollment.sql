USE [csis_db]
GO
/****** Object:  StoredProcedure [dbo].[del_stud_enrollment]    Script Date: 5/30/2017 4:34:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[del_stud_enrollment]
@pUserID smallint, @pSectionTUID int, @return varchar(4) output
AS
BEGIN

	SET NOCOUNT ON;
	-- Check if registration exists
	IF @pUserID IN (SELECT StudID FROM Enrollment WHERE SectionTUID = @pSectionTUID)
		BEGIN
			-- Delete the student's registration
			DELETE FROM Enrollment WHERE StudID = @pUserID AND SectionTUID = @pSectionTUID
			SET @return = '0000';
		END
	ELSE SET @return = '0001';

END
