SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [dbo].[vwCRMLoad_FanProfile_Std_Prep]
AS 
SELECT
	  a.SSB_CRMSYSTEM_acct_ID ssb_crmsystem_acct_ID__c
      ,nullif(prefix,'') prefix
	  ,nullif([FullName],'') Name
	  ,nullif(FirstName,'') FirstName
	  ,nullif(LastName,'') LastName
	  ,nullif(Suffix,'') Suffix
      --,[AddressPrimaryStreet]  BillingStreet
      --,[AddressPrimaryCity]	   BillingCity
      --,[AddressPrimaryState]   BillingState
      --,[AddressPrimaryZip]	   BillingPostalCode
      --,[AddressPrimaryCountry] BillingCountry
      --,[Phone] Phone
      ,[crm_id] Id
	  ,c.[LoadType]
  FROM [dbo].account a WITH (NOLOCK)
INNER JOIN dbo.[CRMLoad_account_ProcessLoad_Criteria] c WITH (NOLOCK) ON [c].ssb_crmsystem_acct_ID = [a].ssb_crmsystem_acct_ID









GO
