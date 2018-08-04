SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[sp_CRMProcess_CRMID_Assign_Address] AS 

UPDATE dbo.Addr
SET Contact__c = LEFT(c.crm_id,18)
FROM dbo.addr a
INNER JOIN dbo.contact c
ON c.SSB_CRMSYSTEM_Contact_ID = a.SSB_CRMSYSTEM_CONTACT_ID
WHERE c.crm_id != c.SSB_CRMSYSTEM_Contact_ID

UPDATE dbo.Addr 
SET crm_id = NULL
FROM dbo.Addr a
LEFT JOIN Monumental_Reporting.prodcopy.Address__c pc
ON a.crm_id = pc.Id
WHERE pc.id IS NULL OR pc.IsDeleted = 1
AND a.crm_id IS NOT null

UPDATE dbo.addr 
SET crm_id = pc.id
--SELECT a.*, pc.*
FROM dbo.Addr a
INNER JOIN dbo.contact c ON c.SSB_CRMSYSTEM_Contact_ID = a.SSB_CRMSYSTEM_CONTACT_ID
inner JOIN Monumental_Reporting.prodcopy.Address__c pc
ON	 RTRIM(ISNULL(pc.Street_Address_1__c,'') +' '+ ISNULL(pc.Street_Address_2__c,'')) = RTRIM(ISNULL(a.street_addr_1,'') + ' ' + ISNULL(a.street_addr_2,''))
AND pc.City__c = a.city
AND pc.State_Province__c = a.state
AND LEFT(pc.Zip_Postal_Code__c,5) = LEFT(a.zip,5)
AND pc.Contact__c = a.Contact__c
--may want to update with our ID after first recognition/push
WHERE a.crm_id IS NULL





GO
