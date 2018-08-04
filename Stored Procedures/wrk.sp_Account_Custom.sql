SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [wrk].[sp_Account_Custom]
AS 


MERGE INTO dbo.Account_Custom Target
USING dbo.Account source
ON source.[SSB_CRMSYSTEM_ACCT_ID] = target.[SSB_CRMSYSTEM_ACCT_ID]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([SSB_CRMSYSTEM_ACCT_ID]) VALUES (source.[SSB_CRMSYSTEM_ACCT_ID])
WHEN NOT MATCHED BY SOURCE THEN
DELETE ;


/*=======================================================
				dbo.sp_CRMProcess_ConcatIDs
=======================================================*/

EXEC dbo.sp_CRMProcess_ConcatIDs 'Account'

/*=======================================================
					SSID Winner
=======================================================*/

UPDATE a
SET SSB_CRMSYSTEM_SSID_Winner__c = ssbid.[SSID], a.SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c =  ssbid.SourceSystem	 
FROM [dbo].Account_Custom a
	JOIN dbo.vwCompositeRecord_ModAcctID ssbid ON ssbid.[SSB_CRMSYSTEM_ACCT_ID] = [a].[SSB_CRMSYSTEM_ACCT_ID]




EXEC  [dbo].[sp_CRMLoad_Account_ProcessLoad_Criteria]


GO
