SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vwCRMLoad_Address_Update] AS

SELECT addr.addr_id
, addr.Contact__c														 --,pc.Contact__c
, addr.Street_Address_1__c												 --,pc.Street_Address_1__c
, addr.Street_Address_2__c												 --,pc.Street_Address_2__c
, addr.city__c															 --,pc.city__c
, addr.Zip_Postal_Code__c												 --,pc.Zip_Postal_Code__c
, addr.State_Province__c												 --,pc.State_Province__c
, addr.Country__c														 --,pc.Country__c
, addr.Archtics_Account_ID__c											 --,pc.Archtics_Account_ID__c
, addr.Archtics_CustName_ID__c											 --,pc.Archtics_CustName_ID__c
, addr.Archtics_Address_Type__c											 --,pc.Archtics_Address_Type__c
, addr.Archtics_Primary_Address__c							  			 --,pc.Archtics_Primary_Address__c

 FROM dbo.vwCRMLoad_Address_Prep addr
INNER JOIN dbo.vwCRMLoad_Contact_Std_Prep c
ON c.SSB_CRMSYSTEM_CONTACT_ID__c = addr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN Monumental_Reporting.prodcopy.Address__c pc
ON addr.crm_id = pc.id
WHERE c.Id != c.SSB_CRMSYSTEM_CONTACT_ID__c 
AND pc.id IS NOT NULL
AND (1=2
	OR ISNULL(addr.Contact__c,'') != ISNULL(pc.Contact__c,'')
	OR ISNULL(addr.Street_Address_1__c,'') != ISNULL(pc.Street_Address_1__c,'')
	OR ISNULL(addr.Street_Address_2__c,'') != ISNULL(pc.Street_Address_2__c,'')
	OR ISNULL(addr.city__c,'') != ISNULL(pc.city__c,'')
	OR ISNULL(addr.Zip_Postal_Code__c,'') != ISNULL(pc.Zip_Postal_Code__c,'')
	OR ISNULL(addr.State_Province__c,'') != ISNULL(pc.State_Province__c,'')
	OR ISNULL(addr.Archtics_Account_ID__c,'') != ISNULL(pc.Archtics_Account_ID__c,'')
	OR ISNULL(addr.Archtics_CustName_ID__c,'') != ISNULL(pc.Archtics_CustName_ID__c,'')
	OR ISNULL(addr.Archtics_Address_Type__c,'') != ISNULL(pc.Archtics_Address_Type__c,'')
	OR ISNULL(addr.Archtics_Primary_Address__c,'') != ISNULL(pc.Archtics_Primary_Address__c,'')
	
	)
GO
