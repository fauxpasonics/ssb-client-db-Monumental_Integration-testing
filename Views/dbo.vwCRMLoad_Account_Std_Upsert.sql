SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vwCRMLoad_Account_Std_Upsert] AS
SELECT 
SSB_CRMSYSTEM_household_ID__c, Name, --CONVERT(NVARCHAR(300), Name, 1252) Name,
 BillingStreet
 , BillingCity
 , BillingState
 , BillingPostalCode
 , BillingCountry
 , Phone
 , [LoadType]
FROM [dbo].[vwCRMLoad_account_Std_Prep]
WHERE LoadType = 'Upsert'

GO
