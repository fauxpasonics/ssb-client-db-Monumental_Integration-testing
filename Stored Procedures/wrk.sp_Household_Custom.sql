SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [wrk].[sp_Household_Custom]
AS 


MERGE INTO dbo.Household_Custom Target
USING dbo.Household source
ON source.[SSB_CRMSYSTEM_HOUSEHOLD_ID] = target.[SSB_CRMSYSTEM_HOUSEHOLD_ID]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([SSB_CRMSYSTEM_HOUSEHOLD_ID]) VALUES (source.[SSB_CRMSYSTEM_HOUSEHOLD_ID])
WHEN NOT MATCHED BY SOURCE THEN
DELETE ;


/*=======================================================
				dbo.sp_CRMProcess_ConcatIDs
=======================================================*/

EXEC dbo.sp_CRMProcess_ConcatIDs 'Household'

/*=======================================================
					SSID Winner
=======================================================*/

--UPDATE a
--SET SSID_Winner = ssbid.[SSID], a.SSB_CRMSystem_SSIDWinnerSourceSystem__c =  ssbid.SourceSystem	 
--FROM [dbo].Household_Custom a
--	JOIN dbo.vwDimCustomer_ModAcctId ssbid ON ssbid.[SSB_CRMSYSTEM_HOUSEHOLD_ID] = [a].[SSB_CRMSYSTEM_HOUSEHOLD_ID]
--WHERE ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG = 1



EXEC  [dbo].[sp_CRMLoad_Household_ProcessLoad_Criteria]


GO
