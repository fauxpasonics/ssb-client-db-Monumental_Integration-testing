SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [wrk].[sp_Prep_Email] AS

/*==================================
Attempt to combat GUID change - TCF 1/2/2018
==================================*/
UPDATE e
SET e.SSB_CRMSYSTEM_CONTACT_ID = c.SSB_CRMSYSTEM_Contact_ID
--SELECT p.SSB_CRMSYSTEM_Contact_ID, p.contact__c, c.SSB_CRMSYSTEM_CONTACT_ID
FROM dbo.email e
INNER JOIN dbo.contact c
ON e.Contact__c = c.crm_id
WHERE c.SSB_CRMSYSTEM_Contact_ID != e.SSB_CRMSYSTEM_CONTACT_ID

/*==================================
Resume typical script
==================================*/

DELETE a
--SELECT COUNT(*) 
FROM dbo.Email a
LEFT JOIN dbo.[vwDimCustomer_ModAcctId] b ON [b].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]
WHERE b.[DimCustomerId] IS NULL 

TRUNCATE TABLE stg.Email

INSERT INTO stg.Email
SELECT 'TM-' + CAST(email_id AS NVARCHAR(100))									--AS email_id
, ma.SSB_CRMSYSTEM_CONTACT_ID
, email_addr																--AS Email_Address__c
, acct_id																	--AS Archtics_Account_ID__c
, cust_name_id																--AS Archtics_CustName_ID__C
, NULL
, email_type_name															--AS Archtics_Email_Type__c 
, solicit_email																--AS Do_Not_Solicit__c
, e.email_sort																		--AS Another_Archtics_Primary_Email_Exists__c 
FROM Monumental.ods.TM_CustEmail e
INNER JOIN dbo.vwDimCustomer_ModAcctId ma
ON ma.SourceSystem = 'tm' and ma.SSID = CAST(e.acct_id AS NVARCHAR(100)) + ':' + CAST(e.cust_name_id AS NVARCHAR(100))
WHERE ma.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL
AND e.email_id NOT IN
(
'1956341',
'3069842',
'1766344',
'1737390')


UNION 

SELECT 'DCP-' + CAST(DimCustomerId AS NVARCHAR(100))
, SSB_CRMSYSTEM_CONTACT_ID
, EmailPrimary
, NULL
, NULL
, NULL
, NULL
, NULL
, NULL
 FROM dbo.vwCompositeRecord_ModAcctID
 WHERE ISNULL(EmailPrimary,'') != ''
 AND SourceSystem NOT IN ('TM', 'Monumental PC_SFDC FanProfile', 'Monumental PC_SFDC Contact', 'Monumental PC_SFDC Account')



 UNION

 SELECT 'DC1-' + CAST(DimCustomerId AS NVARCHAR(100))
, SSB_CRMSYSTEM_CONTACT_ID
, EmailOne
, NULL
, NULL
, NULL
, NULL
, NULL
, NULL
 FROM dbo.vwCompositeRecord_ModAcctID
 WHERE ISNULL(EmailOne,'') != ''
 AND SourceSystem NOT IN ('TM', 'Monumental PC_SFDC FanProfile', 'Monumental PC_SFDC Contact', 'Monumental PC_SFDC Account')

 UNION

 SELECT 'DC2-' + CAST(DimCustomerId AS NVARCHAR(100))
, SSB_CRMSYSTEM_CONTACT_ID
, EmailTwo
, NULL
, NULL
, NULL
, NULL
, NULL
, NULL
 FROM dbo.vwCompositeRecord_ModAcctID
 WHERE ISNULL(EmailTwo,'') != ''
 AND SourceSystem NOT IN ('TM', 'Monumental PC_SFDC FanProfile', 'Monumental PC_SFDC Contact', 'Monumental PC_SFDC Account')

--Need to populate "another" based on what is in the table. Run after merge sproc.
--Translate solicit

SELECT *, ROW_NUMBER() OVER (PARTITION BY ssb_crmsysteM_contact_id, email_address__c ORDER BY CASE WHEN archtics_account_id__c IS NOT NULL THEN 0 ELSE 1 end , email_sort, email_id) AS rownum
INTO #temp
FROM stg.email

TRUNCATE TABLE wrk.Email

INSERT INTO wrk.email

SELECT email_id	
, t.SSB_CRMSYSTEM_CONTACT_ID	
, Email_Address__c	
, Archtics_Account_ID__c	
, Archtics_CustName_ID__c	
, CASE WHEN email_id LIKE 'TM%' and Email_Address__c = c.EmailPrimary THEN 'Yes' WHEN email_id LIKE 'TM%' THEN 'No' ELSE NULL END AS  Archtics_Primary_Email__c	
, Archtics_Email_Type__c	
, CASE WHEN Do_Not_Solicit__c = 'Y' THEN 0 WHEN Do_Not_Solicit__c = 'N' THEN 1 ELSE 0 END AS Do_Not_Solicit__c
FROM #temp t

LEFT JOIN dbo.contact c 
ON t.ssb_crmsystem_contact_id = c.SSB_CRMSYSTEM_Contact_ID
WHERE rownum = 1

DROP TABLE #temp



MERGE INTO dbo.email AS target
USING wrk.email AS source
ON source.SSB_CRMSYSTEM_CONTACT_ID = target.SSB_CRMSYSTEM_CONTACT_ID AND source.email_id = target.email_id
WHEN MATCHED THEN
UPDATE SET 
target.Email_Address__c = source.Email_Address__c,
target.Archtics_Account_ID__c = source.Archtics_Account_ID__c,
target.Archtics_CustName_ID__c = source.Archtics_CustName_ID__c,
target.Archtics_Primary_Email__c = source.Archtics_Primary_Email__c,
target.Archtics_Email_Type__c = source.Archtics_Email_Type__c,
target.Do_Not_Solicit__c = source.Do_Not_Solicit__c
WHEN NOT MATCHED BY TARGET THEN
INSERT (email_id,	SSB_CRMSYSTEM_CONTACT_ID,	Email_Address__c,	Archtics_Account_ID__c,	Archtics_CustName_ID__c,	Archtics_Primary_Email__c,	Archtics_Email_Type__c,	Do_Not_Solicit__c,	crm_id,	Contact__c) 
VALUES (SOURCE.email_id,	SOURCE.SSB_CRMSYSTEM_CONTACT_ID,	SOURCE.Email_Address__c,	SOURCE.Archtics_Account_ID__c,	SOURCE.Archtics_CustName_ID__c,	SOURCE.Archtics_Primary_Email__c,	SOURCE.Archtics_Email_Type__c,	SOURCE.Do_Not_Solicit__c, NULL, NULL);


DELETE dbo.email
FROM dbo.email p
LEFT JOIN dbo.CRMLoad_Contact_ProcessLoad_Criteria lc
ON lc.SSB_CRMSYSTEM_Contact_ID = p.SSB_CRMSYSTEM_CONTACT_ID
WHERE lc.SSB_CRMSYSTEM_Contact_ID IS null

EXEC [dbo].[sp_CRMProcess_CRMID_Assign_Email]


GO
