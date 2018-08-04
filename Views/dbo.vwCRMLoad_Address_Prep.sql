SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwCRMLoad_Address_Prep] AS
SELECT p.addr_id
, p.SSB_CRMSYSTEM_CONTACT_ID
, p.street_addr_1 AS Street_Address_1__c
, p.street_addr_2 AS Street_Address_2__c
, p.City AS City__c
, p.zip AS Zip_Postal_Code__c
, p.state AS State_Province__c
, p.country AS Country__c
, p.Archtics_Address_Type__c
, p.Archtics_Primary_Address__c
, p.Archtics_Account_ID__c
, p.Archtics_CustName_ID__c
, p.crm_id
, p.Contact__c
 FROM dbo.addr p
INNER JOIN dbo.[CRMLoad_Contact_ProcessLoad_Criteria] c 
ON [c].[SSB_CRMSYSTEM_CONTACT_ID] = [p].[SSB_CRMSYSTEM_CONTACT_ID]
GO
