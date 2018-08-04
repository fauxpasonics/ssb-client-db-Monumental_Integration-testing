SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vwCRMLoad_Contact_Custom_Update]
AS
SELECT  
	 z.[crm_id] Id
	,b.SSB_CRMSYSTEM_SSID_Winner__c										--,c.SSB_CRMSYSTEM_SSID_Winner__c
	,b.SSB_CRMSYSTEM_DimCustomerID__c									--,c.SSB_CRMSYSTEM_DimCustomerID__c
	,b.SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c						--,c.SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c
	,b.SSB_CRMSYSTEM_SSID_TIX__c										--,c.SSB_CRMSYSTEM_SSID_TIX__c
	,b.[Archtics_Account_ID__c]											--,c.[Archtics_Account_ID__c]
	,b.[Archtics_CustName_ID__c]										--,c.[Archtics_CustName_ID__c]
	,b.Archtics_Relationship_Type__c									--,c.Archtics_Relationship_Type__c
	,b.Archtics_Name_Type__c											--,c.Archtics_Name_Type__c

	--,case when  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(  b.[Archtics_Account_ID__c] AS nVARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.[Archtics_Account_ID__c] AS nVARCHAR(MAX)))),'')) 			   then 1 else 0 end as [Archtics_Account_ID__c]
	--,case when  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( b.[Archtics_CustName_ID__c] AS nVARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(  c.[Archtics_CustName_ID__c] AS nVARCHAR(MAX)))),'')) 		   then 1 else 0 end as [Archtics_CustName_ID__c]
	--,case when  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( b.Archtics_Relationship_Type__c AS nVARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(  c.Archtics_Relationship_Type__c AS nVARCHAR(MAX)))),''))    then 1 else 0 end as Archtics_Relationship_Type__c
	--,case when  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( b.Archtics_Name_Type__c AS nVARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(  c.Archtics_Name_Type__c AS nVARCHAR(MAX)))),'')) 				   then 1 else 0 end as Archtics_Name_Type__c

FROM dbo.[vwCRMLoad_Contact_Std_Prep] a
INNER JOIN dbo.[Contact_Custom] b ON [a].[SSB_CRMSYSTEM_CONTACT_ID__c] = b.[SSB_CRMSYSTEM_CONTACT_ID__c]
INNER JOIN dbo.Contact z ON a.[SSB_CRMSYSTEM_CONTACT_ID__c] = z.[SSB_CRMSYSTEM_CONTACT_ID]
LEFT JOIN  prodcopy.contact c ON z.[crm_id] = c.ID
WHERE z.[SSB_CRMSYSTEM_CONTACT_ID] <> z.[crm_id]
AND  (1=2
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(  b.[Archtics_Account_ID__c] AS nVARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.[Archtics_Account_ID__c] AS nVARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( b.[Archtics_CustName_ID__c] AS nVARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(  c.[Archtics_CustName_ID__c] AS nVARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( b.Archtics_Relationship_Type__c AS nVARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(  c.Archtics_Relationship_Type__c AS nVARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( b.Archtics_Name_Type__c AS nVARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(  c.Archtics_Name_Type__c AS nVARCHAR(MAX)))),'')) 

	--OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(  b.SSB_CRMSYSTEM_SSID_Winner__c AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.SSB_CRMSYSTEM_SSID_Winner__c AS VARCHAR(MAX)))),'')) 
--	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( b.SSB_CRMSYSTEM_DimCustomerID__c AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(  c.SSB_CRMSYSTEM_DimCustomerID__c AS VARCHAR(MAX)))),'')) 
--	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( b.SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.SSB_CRMSYSTEM_SSID_Winner_SourceSystem__c AS VARCHAR(MAX)))),''))
--	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( b.SSB_CRMSYSTEM_SSID_TIX__c AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.SSB_CRMSYSTEM_SSID_TIX__c AS VARCHAR(MAX)))),''))
	)

GO
