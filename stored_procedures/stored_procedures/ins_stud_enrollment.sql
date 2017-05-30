USE [csis_db]
GO
/****** Object:  StoredProcedure [dbo].[ins_stud_enrollment]    Script Date: 5/30/2017 4:40:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ins_stud_enrollment]

@pUserID smallint, @pSectionTUID int, @return varchar(4) output
AS
BEGIN

	SET NOCOUNT ON;

	-- Check if registration already exists
	IF @pUserID NOT IN (SELECT StudID FROM Enrollment WHERE SectionTUID = @pSectionTUID)
		BEGIN
			-- Insert the UserID, Section combination
			INSERT INTO Enrollment (StudID, SectionTUID) VALUES (@pUserID, @pSectionTUID);
			SET @return = '0000';
		END
	ELSE SET @return = '0001';

END