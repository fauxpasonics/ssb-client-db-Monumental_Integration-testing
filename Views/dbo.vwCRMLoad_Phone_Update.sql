SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwCRMLoad_Phone_Update] AS

SELECT
 phn.crm_id AS Id									  	
, phn.phone_number__c								  --,pc.phone_number__c			
, phn.phone_type__c									  --,pc.phone_type__c				
, phn.archtics_account_id__c						  --,pc.archtics_account_id__c	
, phn.archtics_custname_id__c						  --,pc.archtics_custname_id__c	
, phn.contact__c									  --,pc.contact__c				

 FROM dbo.vwCRMLoad_Phone_Prep phn
INNER JOIN dbo.vwCRMLoad_Contact_Std_Prep c
ON c.SSB_CRMSYSTEM_CONTACT_ID__c = phn.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN Monumental_Reporting.prodcopy.Phone_Number__c pc
ON phn.crm_id = pc.id
WHERE c.Id != c.SSB_CRMSYSTEM_CONTACT_ID__c 
AND pc.id IS NOT NULL
AND (1=2
	OR ISNULL(phn.phone_number__c,'') != ISNULL(pc.Phone_Number__c,'')
	OR ISNULL(phn.phone_type__c,'') != ISNULL(pc.phone_type__c,'')
	OR ISNULL(phn.archtics_account_id__c,'') != ISNULL(pc.archtics_account_id__c,'')
	OR ISNULL(phn.archtics_custname_id__c,'') != ISNULL(pc.archtics_custname_id__c,'')
	OR ISNULL(phn.contact__c,'') != ISNULL(pc.contact__c,'')
	)
GO
