SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwCRMLoad_Email_Upsert] AS

SELECT  p.Id AS Contact__c
, em.SSB_CRMSYSTEM_CONTACT_ID
, em.Email_Address__c
, em.Archtics_Account_ID__c
, em.Archtics_CustName_ID__c
, em.Archtics_Primary_Email__c
, em.Archtics_Email_Type__c
, em.Do_Not_Solicit__c
, em.email_id
FROM dbo.vwCRMLoad_email_Prep em
INNER JOIN dbo.vwCRMLoad_Contact_Std_Prep p
ON p.SSB_CRMSYSTEM_CONTACT_ID__c = em.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN Monumental_Reporting.prodcopy.Email_Address__c sf
ON p.Id = sf.Contact__c AND em.Email_Address__c = sf.Email_Address__c
WHERE p.id != p.SSB_CRMSYSTEM_CONTACT_ID__c AND em.crm_id IS NULL AND sf.id IS null

GO
