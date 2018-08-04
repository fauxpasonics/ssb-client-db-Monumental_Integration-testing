SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_CRMProcess_CRMID_Assign_Phone] AS 


UPDATE dbo.Phone
SET Contact__c = LEFT(c.crm_id,18)
FROM dbo.phone p
INNER JOIN dbo.contact c
ON c.SSB_CRMSYSTEM_Contact_ID = p.SSB_CRMSYSTEM_CONTACT_ID
WHERE c.crm_id != c.SSB_CRMSYSTEM_Contact_ID

UPDATE dbo.phone 
SET crm_id = NULL
FROM dbo.phone p
LEFT JOIN Monumental_Reporting.prodcopy.Phone_Number__c pc
ON p.crm_id = pc.Id
WHERE (pc.id IS NULL OR pc.IsDeleted = 1) AND p.crm_id IS NOT null

UPDATE dbo.phone 
SET crm_id = pc.id
FROM dbo.phone p
INNER JOIN dbo.contact c ON c.SSB_CRMSYSTEM_Contact_ID = p.SSB_CRMSYSTEM_CONTACT_ID
inner JOIN Monumental_Reporting.prodcopy.Phone_Number__c pc
ON REPLACE(REPLACE(REPLACE(REPLACE(pc.Phone_Number__c,')',''),'(',''),'-',''),' ','') = REPLACE(REPLACE(REPLACE(REPLACE(p.Phone_Number__c,')',''),'(',''),'-',''),' ','') AND pc.Phone_Type__c = p.Phone_Type__c AND pc.Contact__c = p.Contact__c
 --may want to update with our ID after first recognition/push
WHERE p.crm_id IS NULL



GO
