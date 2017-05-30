USE [csis_db]
GO
/****** Object:  StoredProcedure [dbo].[sel_room_equip]    Script Date: 5/30/2017 4:48:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sel_room_equip]

AS
BEGIN

	SET NOCOUNT ON;

	-- Output isn't exactly pretty, but it gets the job done
	SELECT e1.RoomNumber, 

		STUFF((SELECT
            ', ' + STR(e2.Quantity) + ' ' + e2.EquipmentType
            FROM Equipment e2
            WHERE e1.RoomNumber =e2.RoomNumber
            ORDER BY e2.EquipmentType
            FOR XML PATH(''), TYPE
        ).value('.','varchar(max)')
        ,1,2, '') As Items

	FROM Equipment e1
	GROUP BY e1.RoomNumber

END
