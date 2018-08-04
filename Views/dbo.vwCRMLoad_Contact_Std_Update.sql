SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vwCRMLoad_Contact_Std_Update] AS


SELECT a.SSB_CRMSYSTEM_ACCT_ID__c
, a.SSB_CRMSYSTEM_CONTACT_ID__c
, a.SSB_CRMSYSTEM_HOUSEHOLD_ID__c
, a.Prefix														   --,c.Salutation
, a.FirstName													   --,c.FirstName
, a.LastName													   --,c.LastName
, a.Suffix														   --,c.Suffix
, a.AccountId													   --,c.AccountId
, a.fan_profile__c												   --,c.fan_profile__c
--, a.MailingStreet
--, a.MailingCity
--, a.MailingState
--, a.MailingPostalCode
--, a.MailingCountry
--, a.Phone  -- Don't believe that Monumental wants to map this to the contact (along with addresses)
--, a.AccountId  --NEVER MAP, WILL BREAK HEDA
, [LoadType]
, a.Id

	--,case when  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.FirstName AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.FirstName AS VARCHAR(MAX)))),'')) 			   then 1 else 0 end as FirstName
	--,case when  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.LastName AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.LastName AS VARCHAR(MAX)))),'')) 				   then 1 else 0 end as LastName
	--,case when  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.AccountId AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.AccountId AS VARCHAR(MAX)))),'')) 			   then 1 else 0 end as AccountId
	--,case when  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.fan_profile__c AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.fan_profile__c AS VARCHAR(MAX)))),'')) 	   then 1 else 0 end as fan_profile__c
	--,case when  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( a.Prefix as varchar(max)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( c.Salutation as varchar(max)))),'')) 				   then 1 else 0 end as Salutation
	--,case when  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( a.Suffix as varchar(max)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( c.Suffix as varchar(max)))),'')) 				   then 1 else 0 end as Suffix__c
FROM [dbo].[vwCRMLoad_Contact_Std_Prep] a
LEFT JOIN  prodcopy.contact c ON a.Id = c.Id
WHERE LoadType = 'Update'
AND  (1=2

	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.FirstName AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.FirstName AS VARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.LastName AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.LastName AS VARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.AccountId AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.AccountId AS VARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.fan_profile__c AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.fan_profile__c AS VARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.Prefix AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.Salutation AS VARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.Suffix AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.Suffix AS VARCHAR(MAX)))),'')) 
	--OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( a.MailingStreet as varchar(max)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( c.MailingStreet as varchar(max)))),'')) 
	--or HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( a.MailingCity as varchar(max)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( c.MailingCity as varchar(max)))),'')) 
	--Or HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( a.MailingState as varchar(max)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( c.MailingState as varchar(max)))),'')) 
	--Or HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( a.MailingPostalCode as varchar(max)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( c.MailingPostalCode as varchar(max)))),'')) 
	--Or HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( a.MailingCountry as varchar(max)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Cast( c.MailingCountry as varchar(max)))),'')) 
	--OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( a.Phone AS VARCHAR(MAX)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST( c.Phone AS VARCHAR(MAX)))),'')) 
	)
	


GO
