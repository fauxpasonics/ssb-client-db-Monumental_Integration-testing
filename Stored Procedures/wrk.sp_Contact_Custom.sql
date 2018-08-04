SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [wrk].[sp_Contact_Custom]
AS 

TRUNCATE TABLE dbo.Contact_Custom;

MERGE INTO dbo.Contact_Custom Target
USING dbo.[Contact] source
ON source.[SSB_CRMSYSTEM_Contact_ID] = target.[SSB_CRMSYSTEM_Contact_ID__c]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([SSB_CRMSYSTEM_Contact_ID__c]) VALUES (Source.[SSB_CRMSYSTEM_Contact_ID])
WHEN NOT MATCHED BY SOURCE THEN DELETE;

EXEC dbo.sp_CRMProcess_ConcatIDs 'Contact'

DECLARE @currentmemberyear int = (Select  datepart(year,getdate()))
					
DECLARE @previousmemberyear int = @currentmemberyear -1 


UPDATE a
SET [SSB_CRMSYSTEM_SSID_Winner__c] = b.SSID
	,[a].[SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c] = b.SourceSystem
	--,[PersonHomePhone] = b.PhoneHome
	--,[PersonOtherPhone] = b.PhoneOther
	--,[PersonEmail] = b.EmailOne
	
FROM [dbo].[Contact_Custom] a
INNER JOIN dbo.[vwCompositeRecord_ModAcctID] b ON b.[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_Contact_ID__c]
INNER JOIN dbo.[vwDimCustomer_ModAcctId] c ON b.[DimCustomerId] = c.[DimCustomerId] AND c.SSB_CRMSYSTEM_PRIMARY_FLAG = 1


/*================================
TM ACCT_ID and CUST_NAME_ID
================================*/

UPDATE dbo.Contact_Custom
SET [Archtics_Account_ID__c] = CASE WHEN r.dimcustomerid IS NULL THEN NULL ELSE  LEFT(r.ssid,CHARINDEX(':',r.ssid,1)-1) end,
[Archtics_CustName_ID__c] =CASE WHEN r.dimcustomerid IS NULL THEN NULL ELSE  RIGHT(r.ssid,LEN(r.ssid)-CHARINDEX(':',r.ssid,1)) end
--SELECT r.ssid, LEFT(r.ssid,CHARINDEX(':',r.ssid,1)-1),RIGHT(r.ssid,LEN(r.ssid)-CHARINDEX(':',r.ssid,1))
FROM dbo.Contact_Custom cc
left JOIN Monumental.mdm.PrimaryFlagRanking_Contact r WITH (NOLOCK)
ON cc.SSB_CRMSYSTEM_Contact_ID__c = r.SSB_CRMSYSTEM_CONTACT_ID AND r.sourcesystem = 'TM' AND  ss_ranking = 1


/*================================
Relationship Type and Name Type - Dependent on ACCT_ID and CUST_NAME_ID from above
================================*/

UPDATE dbo.contact_custom 
SET Archtics_Relationship_Type__c = CASE WHEN tm.Primary_Code IS NOT NULL THEN tm.Primary_code ELSE pcc.Archtics_Relationship_Type__c end,
Archtics_Name_Type__c = CASE WHEN name_type = 'I' THEN 'Individual' WHEN tm.name_type = 'C' THEN 'Organization' ELSE pcc.Archtics_Name_Type__c END
FROM dbo.Contact_Custom cc
INNER JOIN dbo.contact c 
ON c.SSB_CRMSYSTEM_Contact_ID = cc.SSB_CRMSYSTEM_Contact_ID__c
LEFT JOIN Monumental.ods.tm_cust tm WITH (NOLOCK)
ON cc.archtics_account_id__c = CAST(tm.acct_id AS NVARCHAR(100)) AND cc.archtics_custname_id__c = CAST(tm.cust_name_id AS NVARCHAR(100))
LEFT JOIN Monumental_Reporting.prodcopy.Contact pcc
ON c.crm_id = pcc.id



EXEC  [dbo].[sp_CRMLoad_Contact_ProcessLoad_Criteria]



GO
