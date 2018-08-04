SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vwCRMLoad_Contact_Std_Prep]
AS 
SELECT
	  a.[SSB_CRMSYSTEM_ACCT_ID] SSB_CRMSYSTEM_ACCT_ID__c
	  , a.[SSB_CRMSYSTEM_CONTACT_ID] SSB_CRMSYSTEM_CONTACT_ID__c
	  , a.[SSB_CRMSYSTEM_HOUSEHOLD_ID] SSB_CRMSYSTEM_HOUSEHOLD_ID__c
	  , NULLIF(a.[Prefix],'') Prefix
      , a.[FirstName]
	  , a.[LastName]
	  , NULLIF(a.[Suffix],'') Suffix
      --,a.[AddressPrimaryStreet] MailingStreet
      --,a.[AddressPrimaryCity] MailingCity
      --,a.[AddressPrimaryState] MailingState
      --,a.[AddressPrimaryZip] MailingPostalCode
      --,a.[AddressPrimaryCountry] MailingCountry
      ,NULLIF(a.[Phone],'') Phone
      ,a.[crm_id] Id
	  , h.crm_id AccountId
	  , acc.crm_id Fan_Profile__c
	  ,c.[LoadType]
	  ,a.EmailPrimary Email
  FROM [dbo].Contact a 
INNER JOIN dbo.[CRMLoad_Contact_ProcessLoad_Criteria] c ON [c].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]
LEFT JOIN dbo.account acc
ON a.SSB_CRMSYSTEM_Acct_ID = acc.SSB_CRMSYSTEM_ACCT_ID AND acc.crm_id != acc.SSB_CRMSYSTEM_ACCT_ID
LEFT JOIN dbo.HouseHold h
ON a.SSB_CRMSYSTEM_HouseHold_ID = h.SSB_CRMSYSTEM_HOUSEHOLD_ID AND h.crm_id != h.SSB_CRMSYSTEM_HOUSEHOLD_ID


GO
