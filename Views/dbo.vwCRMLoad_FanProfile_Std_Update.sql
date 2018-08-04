SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [dbo].[vwCRMLoad_FanProfile_Std_Update] AS
SELECT a.SSB_CRMSYSTEM_acct_ID__c
, a.Name							--,c.Name
, a.Prefix							--,c.Prefix__c
, a.FirstName						--,c.First_Name__c
, a.LastName						--,c.Last_Name__c
, a.Suffix							--,c.Suffix__c
, a.Id
, [LoadType]
FROM [dbo].[vwCRMLoad_Fanprofile_Std_Prep] a
LEFT JOIN prodcopy.Fan_Profile__c c ON a.Id = c.ID
WHERE LoadType = 'Update'
AND  (1=2
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( a.Name as varchar(max)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( c.Name as varchar(max)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( a.Prefix as varchar(max)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( c.Prefix__c as varchar(max)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( a.FirstName as varchar(max)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( c.First_Name__c as varchar(max)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( a.LastName as varchar(max)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( c.Last_Name__c as varchar(max)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( a.Suffix as varchar(max)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( c.Suffix__c as varchar(max)))),'')) 

	)



GO
