SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [wrk].[sp_Prep_Address] AS

/*==================================
Attempt to combat GUID change - TCF 1/2/2018
==================================*/
UPDATE a
SET a.SSB_CRMSYSTEM_CONTACT_ID = c.SSB_CRMSYSTEM_Contact_ID
--SELECT p.SSB_CRMSYSTEM_Contact_ID, p.contact__c, c.SSB_CRMSYSTEM_CONTACT_ID
FROM dbo.Addr a
INNER JOIN dbo.contact c
ON a.Contact__c = c.crm_id
WHERE c.SSB_CRMSYSTEM_Contact_ID != a.SSB_CRMSYSTEM_CONTACT_ID

/*==================================
Resume typical script
==================================*/

DELETE a
--SELECT COUNT(*) 
FROM dbo.Addr a
LEFT JOIN dbo.[vwDimCustomer_ModAcctId] b ON [b].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]
WHERE b.[DimCustomerId] IS NULL 

TRUNCATE TABLE stg.Addr

INSERT INTO stg.Addr
SELECT 'TM-' + CAST(a.id AS NVARCHAR(100))
, ma.SSB_CRMSYSTEM_CONTACT_ID
, nullif(street_addr_1,'')
, nullif(street_addr_2,'')
, nullif(city,'')
, nullif(zip,'')
, nullif(state,'')
, nullif(country,'')
, acct_id
, cust_name_id
, address_type_name
, primary_code
FROM Monumental.ods.TM_CustAddress a
INNER JOIN dbo.vwDimCustomer_ModAcctId ma
ON ma.SourceSystem = 'tm' and ma.SSID = CAST(a.acct_id AS NVARCHAR(100)) + ':' + CAST(a.cust_name_id AS NVARCHAR(100))
WHERE ma.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL

UNION 

SELECT 'DCP-' + CAST(DimCustomerId AS NVARCHAR(100))
, SSB_CRMSYSTEM_CONTACT_ID
, NULLIF(AddressPrimaryStreet,'')
, NULL
, nullif(AddressPrimaryCity,'')
, nullif(AddressPrimaryZip,'')
, nullif(AddressPrimaryState,'')
, nullif(AddressPrimaryCountry,'')
, NULL
, NULL
, NULL
, NULL
 FROM dbo.vwCompositeRecord_ModAcctID
 WHERE CONCAT(ISNULL(AddressPrimaryStreet,''),ISNULL(AddressPrimaryZip,''),ISNULL(AddressPrimaryZip,''))  != ''
 AND SourceSystem NOT IN ('TM', 'Monumental PC_SFDC FanProfile', 'Monumental PC_SFDC Contact', 'Monumental PC_SFDC Account')

 UNION

 SELECT 'DC1-' + CAST(DimCustomerId AS NVARCHAR(100))
, SSB_CRMSYSTEM_CONTACT_ID
, NULLIF(AddressOneStreet,'')
, NULL	 
, nullif(AddressOneCity,'')
, nullif(AddressOneZip,'')
, nullif(AddressOneState,'')
, nullif(AddressOneCountry,'')
, NULL
, NULL
, NULL
, NULL
 FROM dbo.vwCompositeRecord_ModAcctID
 WHERE CONCAT(ISNULL(AddressOneStreet,''),ISNULL(AddressOneZip,''),ISNULL(AddressOneZip,''))  != ''
 AND SourceSystem NOT IN ('TM', 'Monumental PC_SFDC FanProfile', 'Monumental PC_SFDC Contact', 'Monumental PC_SFDC Account')

 UNION

 SELECT 'DC2-' + CAST(DimCustomerId AS NVARCHAR(100))
, SSB_CRMSYSTEM_CONTACT_ID
, NULLIF(AddressTwoStreet,'')
, NULL	 
, NULLIF(AddressTwoCity,'')
, NULLIF(AddressTwoZip,'')
, NULLIF(AddressTwoState,'')
, NULLIF(AddressTwoCountry,'')
, NULL
, NULL
, NULL
, NULL
 FROM dbo.vwCompositeRecord_ModAcctID
 WHERE CONCAT(ISNULL(AddressTwoStreet,''),ISNULL(AddressTwoZip,''),ISNULL(AddressTwoZip,''))  != ''
 AND SourceSystem NOT IN ('TM', 'Monumental PC_SFDC FanProfile', 'Monumental PC_SFDC Contact', 'Monumental PC_SFDC Account')
  UNION

 SELECT 'DC2-' + CAST(DimCustomerId AS NVARCHAR(100))
, SSB_CRMSYSTEM_CONTACT_ID
, NULLIF(AddressThreeStreet,'')
, NULL	  
, NULLIF(AddressThreeCity,'')
, NULLIF(AddressThreeZip,'')
, NULLIF(AddressThreeState,'')
, NULLIF(AddressThreeCountry,'')
, NULL
, NULL
, NULL
, NULL
 FROM dbo.vwCompositeRecord_ModAcctID
 WHERE CONCAT(ISNULL(AddressThreeStreet,''),ISNULL(AddressThreeZip,''),ISNULL(AddressThreeZip,''))  != ''
 AND SourceSystem NOT IN ('TM', 'Monumental PC_SFDC FanProfile', 'Monumental PC_SFDC Contact', 'Monumental PC_SFDC Account')
  UNION

 SELECT 'DC2-' + CAST(DimCustomerId AS NVARCHAR(100))
, SSB_CRMSYSTEM_CONTACT_ID
, NULLIF(AddressFourStreet,'')
, NULL	 
, NULLIF(AddressFourCity,'')
, NULLIF(AddressFourZip,'')
, NULLIF(AddressFourState,'')
, NULLIF(AddressFourCountry,'')
, NULL
, NULL
, NULL
, NULL
 FROM dbo.vwCompositeRecord_ModAcctID
 WHERE CONCAT(ISNULL(AddressFourStreet,''),ISNULL(AddressFourZip,''),ISNULL(AddressFourZip,''))  != ''
 AND SourceSystem NOT IN ('TM', 'Monumental PC_SFDC FanProfile', 'Monumental PC_SFDC Contact', 'Monumental PC_SFDC Account')


SELECT *, ROW_NUMBER() OVER (PARTITION BY ssb_crmsysteM_contact_id, street_addr_1 ORDER BY CASE WHEN archtics_account_id__c IS NOT NULL THEN 0 ELSE 1 end , archtics_primary_address__c, addr_id) AS rownum
INTO #temp
FROM stg.addr
ORDER BY ssb_crmsystem_contact_id

DELETE other
--SELECT COUNT(*)
-- select other.*
FROM #temp other
INNER JOIN #temp TM
ON other.ssb_crmsystem_contact_id = tm.ssb_crmsystem_contact_id
AND other.addr_id NOT LIKE 'TM%' AND tm.addr_id LIKE 'TM%'

TRUNCATE TABLE wrk.Addr

INSERT INTO wrk.Addr

SELECT Addr_id	
, t.SSB_CRMSYSTEM_CONTACT_ID	
, street_addr_1
, street_addr_2
, city 
, zip 
, state 
, country
, Archtics_Account_ID__c	
, Archtics_CustName_ID__c	
, Archtics_Address_Type__c	
, Archtics_Primary_Address__c
FROM #temp t
WHERE rownum = 1

DROP TABLE #temp



MERGE INTO dbo.addr AS target
USING wrk.addr AS source
ON source.SSB_CRMSYSTEM_CONTACT_ID = target.SSB_CRMSYSTEM_CONTACT_ID AND source.addr_id = target.addr_id
WHEN MATCHED THEN
UPDATE SET 
target.street_addr_1 = source.street_addr_1,
target.street_addr_2 = source.street_addr_2,
target.city = source.city,
target.zip = source.zip,
target.state = source.state,
target.country = source.country,
target.Archtics_Account_ID__c = source.Archtics_Account_ID__c,
target.Archtics_CustName_ID__c = source.Archtics_CustName_ID__c,
target.Archtics_Address_Type__c = source.Archtics_Address_Type__c,
target.Archtics_Primary_Address__c = source.Archtics_Primary_Address__c
WHEN NOT MATCHED BY TARGET THEN
INSERT (addr_id,	SSB_CRMSYSTEM_CONTACT_ID,	street_addr_1,	street_addr_2,	city,	zip,	state,	country,	Archtics_Account_ID__c,	Archtics_CustName_ID__c,	Archtics_Address_Type__c,	Archtics_Primary_Address__c,	crm_id,	Contact__c) 
VALUES (SOURCE.addr_id,	SOURCE.SSB_CRMSYSTEM_CONTACT_ID,	SOURCE.street_addr_1,	SOURCE.street_addr_2,	SOURCE.city,	SOURCE.zip,	SOURCE.state,	SOURCE.country,	SOURCE.Archtics_Account_ID__c,	SOURCE.Archtics_CustName_ID__c,	SOURCE.Archtics_Address_Type__c,	SOURCE.Archtics_Primary_Address__c, NULL, NULL);

DELETE dbo.addr
FROM dbo.addr p
LEFT JOIN dbo.CRMLoad_Contact_ProcessLoad_Criteria lc
ON lc.SSB_CRMSYSTEM_Contact_ID = p.SSB_CRMSYSTEM_CONTACT_ID
WHERE lc.SSB_CRMSYSTEM_Contact_ID IS null

EXEC [dbo].[sp_CRMProcess_CRMID_Assign_Address]
GO
