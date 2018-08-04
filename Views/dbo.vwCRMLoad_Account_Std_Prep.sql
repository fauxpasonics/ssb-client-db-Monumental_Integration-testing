SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vwCRMLoad_Account_Std_Prep]
AS 
SELECT
	  a.SSB_CRMSYSTEM_HOUSEHOLD_ID ssb_crmsystem_household_ID__c
      ,NULLIF([FullName],'') Name
	  ,NULLIF(FirstName,'') FirstName
	  ,NULLIF(LastName,'') LastName
	  ,NULLIF(Suffix,'') Suffix
      ,NULLIF([AddressPrimaryStreet],'') BillingStreet
      ,NULLIF([AddressPrimaryCity],'') BillingCity
      ,NULLIF([AddressPrimaryState],'') BillingState
      ,NULLIF([AddressPrimaryZip],'') BillingPostalCode
      ,NULLIF(CASE WHEN [AddressPrimaryCountry] = 'US' THEN 'United States' ELSE a.AddressPrimaryCountry end,'') BillingCountry
      ,NULLIF([Phone],'') Phone
      ,[crm_id] Id
	  ,c.[LoadType]
  FROM [dbo].household a WITH (NOLOCK)
INNER JOIN dbo.[CRMLoad_household_ProcessLoad_Criteria] c WITH (NOLOCK) ON [c].ssb_crmsystem_household_ID = [a].ssb_crmsystem_household_ID



GO
