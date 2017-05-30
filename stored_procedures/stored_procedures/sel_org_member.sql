USE [csis_db]
GO
/****** Object:  StoredProcedure [dbo].[sel_org_members]    Script Date: 5/30/2017 4:45:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sel_org_members]
@pOrgName char(25)
AS
BEGIN

	SET NOCOUNT ON;

	-- Start with membership, branch to users and students
	SELECT Fname, Lname, Major, Minor, Email, Phone, "address", city, "state", zip 
	FROM Membership m
		INNER JOIN "User" u ON m.UserID = u.UserID
		INNER JOIN Student s ON s.UserID = m.UserID
	WHERE OrgName = @pOrgName

END
