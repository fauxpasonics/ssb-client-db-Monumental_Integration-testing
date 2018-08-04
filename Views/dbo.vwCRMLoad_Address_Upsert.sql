SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwCRMLoad_Address_Upsert] AS

SELECT  p.Id AS Contact__c
, addr.Street_Address_1__c
, addr.Street_Address_2__c
, addr.city__c
, addr.Zip_Postal_Code__c
, addr.State_Province__c
, addr.Country__c
, addr.Archtics_Account_ID__c
, addr.Archtics_CustName_ID__c
, addr.Archtics_Address_Type__c
, addr.Archtics_Primary_Address__c
FROM dbo.vwCRMLoad_Address_Prep addr
INNER JOIN dbo.vwCRMLoad_Contact_Std_Prep p
ON p.SSB_CRMSYSTEM_CONTACT_ID__c = addr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN Monumental_Reporting.prodcopy.Address__c sf
ON p.Id = sf.Contact__c 
AND sf.Street_Address_1__c = addr.Street_Address_1__c
AND ISNULL(sf.Street_Address_2__c,'') = ISNULL(addr.Street_Address_2__c,'')
AND sf.City__c = addr.city__c
AND sf.State_Province__c = addr.State_Province__c
AND LEFT(sf.Zip_Postal_Code__c,5) = LEFT(addr.Zip_Postal_Code__c,5)
AND sf.Contact__c = addr.Contact__c
LEFT JOIN Monumental_Reporting.prodcopy.Address__c conadd --REMOVE AFTER TM Corrected
ON conadd.Contact__c = p.Id
--replace with ID when possible
WHERE p.id != p.SSB_CRMSYSTEM_CONTACT_ID__c AND addr.crm_id IS NULL AND sf.id IS NULL
AND conadd.id IS NULL --REMOVE AFTER TM Corrected
GO
