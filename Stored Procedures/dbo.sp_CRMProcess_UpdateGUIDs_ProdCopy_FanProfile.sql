SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[sp_CRMProcess_UpdateGUIDs_ProdCopy_FanProfile]
as
UPDATE b
SET [b].SSB_CRMSYSTEM_ACCT_ID__c = a.SSB_CRMSYSTEM_ACCT_ID__c
--SELECT a.* 
FROM [dbo].[vwCRMProcess_UpdateGUIDs_ProdCopyFanProfile] a 
INNER JOIN ProdCopy.Fan_Profile__c b ON a.Id = b.Id
WHERE ISNULL(b.SSB_CRMSYSTEM_ACCT_ID__c,'a') <> ISNULL(a.SSB_CRMSYSTEM_ACCT_ID__c,'a')
GO
