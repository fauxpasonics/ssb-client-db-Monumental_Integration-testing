SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vwCRMLoad_FanProfile_Std_Upsert] AS
SELECT 
SSB_CRMSYSTEM_ACCT_ID__c
, Name
--CONVERT(NVARCHAR(300), Name, 1252) Name,
, Prefix
, FirstName
, LastName
, Suffix
, Id

 , [LoadType]
FROM [dbo].[vwCRMLoad_fanprofile_Std_Prep]
WHERE LoadType = 'Upsert'

GO
