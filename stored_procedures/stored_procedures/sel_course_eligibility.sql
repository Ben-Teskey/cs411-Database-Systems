USE [csis_db]
GO
/****** Object:  StoredProcedure [dbo].[sel_course_eligibility]    Script Date: 5/30/2017 4:42:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sel_course_eligibility]
@pUserID char(4), @pSectionTUID int, @return varchar(5) output
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @vCourseNumber varchar(6)
    SET @vCourseNumber = (Select CourseNumber FROM CourseSection WHERE SectionTUID = @pSectionTUID);

	-- All courses a student has passed successfully
	DECLARE @tblStudEnrollment TABLE (
		StudID smallint,
		courseNumber char(6),
		Grade decimal
	);

	INSERT INTO @tblStudEnrollment
	SELECT StudID, CourseNumber, Grade FROM Enrollment e
		INNER JOIN CourseSection cs ON e.SectionTUID = cs.SectionTUID
	WHERE StudID = @pUserID AND Grade >= 2

	-- All prereqs required for the course
	DECLARE @tblPrereqsRequired TABLE (
		prereq char(6)
	);

	INSERT INTO @tblPrereqsRequired
	SELECT DISTINCT PrereqID FROM CourseSection cs
		INNER JOIN Prerequisite p ON cs.CourseNumber = p.PrereqID
		WHERE p.CourseNumber = @vCourseNumber

	--SELECT * FROM @tblStudEnrollment;
	--SELECT * FROM @tblPrereqsRequired;

	-- All prereqs missing from student's successfully passed courses
	DECLARE @tblPrereqsMissing TABLE (
		prereq char(6)
	);

	INSERT INTO @tblPrereqsMissing
	SELECT prereq FROM @tblPrereqsRequired 
	WHERE prereq NOT IN (SELECT courseNumber FROM @tblStudEnrollment)

	IF (@@ROWCOUNT > 0) SET @return = 'false'

	-- So they're not missing any prereqs. That's good, but we're going to need to check for a couple more things
	ELSE 
		BEGIN

		-- Are they already in the course section?
		IF (@pUserID IN (SELECT StudID FROM Enrollment WHERE StudID = @pUserID AND SectionTUID = @pSectionTUID)) SET @return = 'false';
		ELSE 

		-- Is the student available on the day(s) and time slot that the course is taught?
		Declare @vStartTime char(5)
		SET @vStartTime = (
			SELECT startTime FROM CourseSection cs
				INNER JOIN TimeTable tt ON cs.TimesTUID = tt.TimesTUID
				WHERE cs.SectionTUID = @pSectionTUID
		);

		Declare @vEndTime char(5)
		SET @vEndTime = (
			SELECT endTime FROM CourseSection cs
				INNER JOIN TimeTable tt ON cs.TimesTUID = tt.TimesTUID
				WHERE cs.SectionTUID = @pSectionTUID
		);

		Declare @vDay char(5)
		SET @vDay = (
			SELECT "day" FROM CourseSection cs
				INNER JOIN TimeTable tt ON cs.TimesTUID = tt.TimesTUID
				WHERE cs.SectionTUID = @pSectionTUID
		);

		DECLARE @vConflicts int
		SET @vConflicts = (SELECT COUNT(*) FROM Enrollment e
			INNER JOIN CourseSection cs ON e.SectionTUID = cs.SectionTUID
			INNER JOIN Course c ON cs.CourseNumber = c.CourseNumber
			INNER JOIN TimeTable t ON cs.TimesTUID = t.TimesTUID
			WHERE StudID = @pUserID AND "day" = @vDay AND startTime = @vStartTime AND endTime = @vEndTime);

		IF (@vConflicts > 0) SET @return = 'false';
		ELSE SET @return = 'true';

		END
END