SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwCRMLoad_Phone_Upsert] AS

SELECT  p.Id AS Contact__c
, phn.Phone_Number__c
, phn.Phone_Type__c
FROM dbo.vwCRMLoad_Phone_Prep phn
INNER JOIN dbo.vwCRMLoad_Contact_Std_Prep p
ON p.SSB_CRMSYSTEM_CONTACT_ID__c = phn.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN Monumental_Reporting.prodcopy.Phone_Number__c sf
ON p.Id = sf.Contact__c AND ISNULL(phn.Phone_Type__c,'') = ISNULL(sf.Phone_Type__c,'')
WHERE p.id != p.SSB_CRMSYSTEM_CONTACT_ID__c AND phn.crm_id IS NULL AND sf.id IS null
GO
