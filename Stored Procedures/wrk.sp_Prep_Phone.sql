SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [wrk].[sp_Prep_Phone] AS

/*==================================
Attempt to combat GUID change - TCF 1/2/2018
==================================*/
UPDATE p
SET p.SSB_CRMSYSTEM_CONTACT_ID = c.SSB_CRMSYSTEM_Contact_ID
--SELECT p.SSB_CRMSYSTEM_Contact_ID, p.contact__c, c.SSB_CRMSYSTEM_CONTACT_ID
FROM dbo.phone p
INNER JOIN dbo.contact c
ON p.Contact__c = c.crm_id
WHERE c.SSB_CRMSYSTEM_Contact_ID != p.SSB_CRMSYSTEM_CONTACT_ID

/*==================================
Resume typical script
==================================*/

DELETE a
--SELECT COUNT(*) 
FROM dbo.Phone a
LEFT JOIN dbo.[vwDimCustomer_ModAcctId] b ON [b].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]
WHERE b.[DimCustomerId] IS NULL 

TRUNCATE TABLE stg.Phone

INSERT INTO stg.Phone
SELECT comp.SSB_CRMSYSTEM_CONTACT_ID
, SourceSystem
, SSID
, PhoneHome
, PhoneBusiness
, PhoneFax
, PhoneCell
FROM dbo.vwCompositeRecord_ModAcctID comp

TRUNCATE TABLE wrk.Phone

INSERT INTO wrk.Phone 
SELECT SSB_CRMSYSTEM_CONTACT_ID
, SourceSystem
, SSID
, PhoneHome
, 'Home'
, CASE WHEN SourceSystem = 'tm' THEN SUBSTRING(SSID,1,CHARINDEX(':',SSID,1)-1) ELSE NULL END
, CASE WHEN SourceSystem = 'tm' THEN SUBSTRING(SSID,CHARINDEX(':',SSID,1)+1,LEN(ssid)-CHARINDEX(':',SSID,1)+1) ELSE NULL END
, NULL
FROM stg.Phone
WHERE ISNULL(PhoneHome,'') != ''
AND SourceSystem NOT LIKE '%SFDC%'

UNION

SELECT SSB_CRMSYSTEM_CONTACT_ID
, SourceSystem
, SSID
, PhoneHome
, 'Business'
, CASE WHEN SourceSystem = 'tm' THEN SUBSTRING(SSID,1,CHARINDEX(':',SSID,1)-1) ELSE NULL END
, CASE WHEN SourceSystem = 'tm' THEN SUBSTRING(SSID,CHARINDEX(':',SSID,1)+1,LEN(ssid)-CHARINDEX(':',SSID,1)+1) ELSE NULL END
, NULL
FROM stg.Phone
WHERE ISNULL(PhoneBusiness,'') != ''
AND SourceSystem NOT LIKE '%SFDC%'

UNION

SELECT SSB_CRMSYSTEM_CONTACT_ID
, SourceSystem
, SSID
, PhoneHome
, 'Mobile'
, CASE WHEN SourceSystem = 'tm' THEN SUBSTRING(SSID,1,CHARINDEX(':',SSID,1)-1) ELSE NULL END
, CASE WHEN SourceSystem = 'tm' THEN SUBSTRING(SSID,CHARINDEX(':',SSID,1)+1,LEN(ssid)-CHARINDEX(':',SSID,1)+1) ELSE NULL END
, NULL
FROM stg.Phone
WHERE ISNULL(PhoneFax,'') != ''
AND SourceSystem NOT LIKE '%SFDC%'

UNION

SELECT SSB_CRMSYSTEM_CONTACT_ID
, SourceSystem
, SSID
, PhoneHome
, 'Fax'
, CASE WHEN SourceSystem = 'tm' THEN SUBSTRING(SSID,1,CHARINDEX(':',SSID,1)-1) ELSE NULL END
, CASE WHEN SourceSystem = 'tm' THEN SUBSTRING(SSID,CHARINDEX(':',SSID,1)+1,LEN(ssid)-CHARINDEX(':',SSID,1)+1) ELSE NULL END
, NULL
FROM stg.Phone
WHERE ISNULL(PhoneCell,'') != ''
AND SourceSystem NOT LIKE '%SFDC%'


DELETE other
--SELECT COUNT(*)
-- select *
FROM wrk.Phone Other
INNER JOIN wrk.phone TM
ON other.SSB_CRMSYSTEM_CONTACT_ID = tm.SSB_CRMSYSTEM_CONTACT_ID AND other.SourceSystem != 'tm' AND tm.SourceSystem = 'tm'
AND other.Phone_Type__c = tm.Phone_Type__c AND other.Phone_Number__c = tm.Phone_Number__c

MERGE INTO dbo.Phone AS target
USING wrk.Phone AS source
ON source.SSB_CRMSYSTEM_CONTACT_ID = target.SSB_CRMSYSTEM_CONTACT_ID AND source.Phone_Type__c = target.Phone_Type__c
WHEN MATCHED THEN
UPDATE SET 
target.Phone_Number__c = source.Phone_Number__c,
target.SourceSystem = source.SourceSystem,
target.SSID = source.SSID,
target.Archtics_Account_ID__c = source.Archtics_Account_ID__c,
target.Archtics_CustName_ID__c = source.Archtics_CustName_ID__c
WHEN NOT MATCHED BY TARGET THEN
INSERT (SSB_CRMSYSTEM_CONTACT_ID, [SourceSystem], [SSID], Phone_Number__c, Phone_Type__c, Archtics_Account_ID__c, Archtics_CustName_ID__c, crm_id, Contact__c) 
VALUES (source.SSB_CRMSYSTEM_CONTACT_ID, source.[SourceSystem], source.[SSID], source.Phone_Number__c, source.Phone_Type__c, source.Archtics_Account_ID__c, source.Archtics_CustName_ID__c, NULL, NULL);


DELETE dbo.Phone
FROM dbo.phone p
LEFT JOIN dbo.CRMLoad_Contact_ProcessLoad_Criteria lc
ON lc.SSB_CRMSYSTEM_Contact_ID = p.SSB_CRMSYSTEM_CONTACT_ID
WHERE lc.SSB_CRMSYSTEM_Contact_ID IS NULL

DELETE dbo.Phone
FROM dbo.Phone
WHERE ISNULL(Phone_Number__c,'') = ''


EXEC [dbo].[sp_CRMProcess_CRMID_Assign_Phone]
GO
