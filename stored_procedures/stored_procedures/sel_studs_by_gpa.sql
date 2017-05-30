USE [csis_db]
GO
/****** Object:  StoredProcedure [dbo].[sel_studs_by_gpa]    Script Date: 5/30/2017 4:49:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sel_studs_by_gpa]

AS
BEGIN

	SET NOCOUNT ON;

	-- Declare temp table for student total credits and grade credits
	DECLARE @tblAggregatedStuds TABLE (
		StudID smallint,
		TotalCredits bigint,
		GradeCredits decimal(5, 2)
	);

	-- Insert Student GPA records
	INSERT INTO @tblAggregatedStuds
	SELECT StudID, SUM(Credits), SUM(Grade * Credits) AS GradeCredits 
	FROM Enrollment e
		INNER JOIN CourseSection cs ON e.SectionTUID = cs.SectionTUID
		INNER JOIN Course c ON c.CourseNumber = cs.CourseNumber
	GROUP BY StudID

	-- Now begin the join chain
	SELECT Fname, Lname, Major, Minor, Email, Phone, "address", city, "state", zip, CAST((GradeCredits / TotalCredits) AS decimal (3, 2)) AS GPA
	FROM Student s
		INNER JOIN "User" u ON s.UserID = u.UserID
		LEFT OUTER JOIN @tblAggregatedStuds a ON a.StudID = u.UserID
	ORDER BY GPA

END
