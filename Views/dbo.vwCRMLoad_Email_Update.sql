SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vwCRMLoad_Email_Update] AS

SELECT
 em.crm_id AS Id									  	
, em.SSB_CRMSYSTEM_CONTACT_ID				----,pc.SSB_CRMSYSTEM_CONTACT_ID
, em.Email_Address__c						--,pc.Email_Address__c
, em.Archtics_Account_ID__c					--,pc.Archtics_Account_ID__c
, em.Archtics_CustName_ID__c				--,pc.Archtics_CustName_ID__c
, em.Archtics_Primary_Email__c				--,pc.Archtics_Primary_Email__c
, em.Archtics_Email_Type__c					--,pc.Archtics_Email_Type__c
, em.Do_Not_Solicit__c						--,pc.Do_Not_Solicit__c
, em.Contact__c								--,pc.Contact__c
, em.email_id

	--,case when ISNULL(em.Email_Address__c,'') != ISNULL(pc.Email_Address__c,'')						   then 1 else 0 end as Email_Address__c
	--,case when ISNULL(em.Archtics_Account_ID__c,'') != ISNULL(pc.Archtics_Account_ID__c,'')			   then 1 else 0 end as Archtics_Account_ID__c
	--,case when ISNULL(em.Archtics_Primary_Email__c,'') != ISNULL(pc.Archtics_Primary_Email__c,'')	   then 1 else 0 end as Archtics_Primary_Email__c
	--,case when ISNULL(em.archtics_custname_id__c,'') != ISNULL(pc.archtics_custname_id__c,'')		   then 1 else 0 end as archtics_custname_id__c
	--,case when ISNULL(em.Archtics_Email_Type__c,'') != ISNULL(pc.Archtics_Email_Type__c,'')			   then 1 else 0 end as Archtics_Email_Type__c
	--,case when ISNULL(em.Do_Not_Solicit__c,'') != ISNULL(pc.Do_Not_Solicit__c,'')					   then 1 else 0 end as Do_Not_Solicit__c
	--,case when ISNULL(em.Contact__c,'') != ISNULL(pc.Contact__c,'')									   then 1 else 0 end as Contact__c

 FROM dbo.vwCRMLoad_email_Prep em
INNER JOIN dbo.vwCRMLoad_Contact_Std_Prep c
ON c.SSB_CRMSYSTEM_CONTACT_ID__c = em.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN Monumental_Reporting.prodcopy.Email_Address__c pc
ON em.crm_id = pc.id
WHERE c.Id != c.SSB_CRMSYSTEM_CONTACT_ID__c 
AND pc.id IS NOT NULL
AND (1=2
	OR ISNULL(em.Email_Address__c,'') != ISNULL(pc.Email_Address__c,'')
	OR ISNULL(em.Archtics_Account_ID__c,'') != ISNULL(pc.Archtics_Account_ID__c,'')
	OR ISNULL(em.Archtics_Primary_Email__c,'') != ISNULL(pc.Archtics_Primary_Email__c,'')
	OR ISNULL(em.archtics_custname_id__c,'') != ISNULL(pc.archtics_custname_id__c,'')
	OR ISNULL(em.Archtics_Email_Type__c,'') != ISNULL(pc.Archtics_Email_Type__c,'')
	OR ISNULL(em.Do_Not_Solicit__c,'') != ISNULL(pc.Do_Not_Solicit__c,'')
	OR ISNULL(em.Contact__c,'') != ISNULL(pc.Contact__c,'')
	)

	
GO
