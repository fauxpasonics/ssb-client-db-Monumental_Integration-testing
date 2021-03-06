SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create VIEW [dbo].[vwCRMProcess_UpdateGUIDs_ProdCopyContact]
AS
SELECT DISTINCT b.SSID Id, b.SSB_CRMSYSTEM_ACCT_ID SSB_CRMSYSTEM_ACCT_ID__c, b.SSB_CRMSYSTEM_CONTACT_ID SSB_CRMSYSTEM_CONTACT_ID__c, b.SSB_CRMSYSTEM_HOUSEHOLD_ID SSB_CRMSYSTEM_HOUSEHOLD_ID__c
--, REPLACE(REPLACE(c.[new_ssbcrmsystemcontactid],'{',''),'}','')
FROM dbo.vwDimCustomer_ModAcctId b
INNER JOIN ProdCopy.Contact c WITH(NOLOCK) ON b.SSID = c.id
WHERE (c.SSB_CRMSYSTEM_CONTACT_ID__c IS NULL OR c.SSB_CRMSYSTEM_CONTACT_ID__c <> b.[SSB_CRMSYSTEM_CONTACT_ID]
--OR c.SSB_CRMSYSTEM_ACCT_ID__c IS NULL OR c.SSB_CRMSYSTEM_ACCT_ID__c <> b.[SSB_CRMSYSTEM_Acct_ID]
--OR c.SSB_CRMSYSTEM_HOUSEHOLD_ID__c IS NULL OR c.SSB_CRMSYSTEM_HOUSEHOLD_ID__c <> b.[SSB_CRMSYSTEM_HOUSEHOLD_ID]
)
GO
