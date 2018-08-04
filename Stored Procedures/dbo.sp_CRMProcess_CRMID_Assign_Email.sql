SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_CRMProcess_CRMID_Assign_Email] AS 

UPDATE dbo.Email
SET Contact__c = LEFT(c.crm_id,18)
FROM dbo.email e
INNER JOIN dbo.contact c
ON c.SSB_CRMSYSTEM_Contact_ID = e.SSB_CRMSYSTEM_CONTACT_ID
WHERE c.crm_id != c.SSB_CRMSYSTEM_Contact_ID

UPDATE dbo.email 
SET crm_id = NULL
FROM dbo.email e
LEFT JOIN Monumental_Reporting.prodcopy.Email_Address__c pc
ON e.crm_id = pc.Id
WHERE pc.id IS NULL OR pc.IsDeleted = 1
AND e.crm_id IS NOT null

UPDATE dbo.email 
SET crm_id = pc.id
FROM dbo.email e
INNER JOIN dbo.contact c ON c.SSB_CRMSYSTEM_Contact_ID = e.SSB_CRMSYSTEM_CONTACT_ID
inner JOIN Monumental_Reporting.prodcopy.Email_Address__c pc
ON pc.Email_Address__c = e.Email_Address__c AND pc.Contact__c = e.Contact__c  --may want to update with our ID after first recognition/push
WHERE e.crm_id IS NULL
GO
