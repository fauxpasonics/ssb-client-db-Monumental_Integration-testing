SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create VIEW [dbo].[vwCRMProcess_UpdateGUIDs_ProdCopyAccount]
AS
SELECT DISTINCT b.SSID Id, b.SSB_CRMSYSTEM_HOUSEhoLD_ID SSB_CRMSYSTEM_HOUSEHOLD_ID__c
--, REPLACE(REPLACE(c.[new_ssbcrmsystemcontactid],'{',''),'}','')
FROM dbo.vwDimCustomer_ModAcctId b
INNER JOIN ProdCopy.Account c WITH(NOLOCK) ON b.SSID = c.id
WHERE c.SSB_CRMSYSTEM_HOUSEHOLD_ID__c IS NULL OR c.SSB_CRMSYSTEM_HOUSEHOLD_ID__c <> b.[SSB_CRMSYSTEM_HOUSEHOLD_ID]

GO