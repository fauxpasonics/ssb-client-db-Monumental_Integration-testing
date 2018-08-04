SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[sp_CRMProcess_DistinctAccounts_Contacts]
AS
--SELECT * 
--INTO stg.DistinctAccount_Saved_20150226
--FROM dbo.SFDCProcess_DistinctAccounts

-- Create Main Transaction Records Table
SELECT *
INTO #tmpTrans
FROM dbo.vwCRMProcess_CRMQualify_Transactions
-- DROP TABLE #tmpTrans
--SELECT * FROM #tmpTrans


CREATE INDEX idx_Trans_Acct_ID ON [#tmpTrans] ([SSB_CRMSYSTEM_ACCT_ID])
CREATE INDEX idx_Trans_Contact_ID ON [#tmpTrans] ([SSB_CRMSYSTEM_CONTACT_ID])
CREATE INDEX idx_Trans_Household_ID ON [#tmpTrans] ([SSB_CRMSYSTEM_HOUSEHOLD_ID])

-- Create Activities/Notes Table
--SELECT b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, CASE WHEN Type LIKE '%Sixers%' THEN 'Sixers' ELSE 'Devils' END Brand, COUNT(*) RecordCount
--INTO #tmpActivity
--FROM PSP.dbo.vwDimCustomer_ModAcctId b
--INNER JOIN dbo.OtherSSIDsToBeLoaded c ON b.SSID = c.SSID
--GROUP BY b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, CASE WHEN Type LIKE '%Sixers%' THEN 'Sixers' ELSE 'Devils' END
---- Drop Table #tmpActivity

-- Create STH Table
SELECT b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, b.SSB_CRMSYSTEM_HOUSEHOLD_ID
, b.SourceSystem
, COUNT(*) Count 
INTO #tmpSTHs
-- Select *
FROM stg.CRMProcess_SeasonTicketHolders_SSIDs a
INNER JOIN [dbo].[vwDimCustomer_ModAcctId] b ON b.SSID = a.SSID and b.SourceSystem = 'TM' --updateme
GROUP BY b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, b.SourceSystem, b.SSB_CRMSYSTEM_HOUSEHOLD_ID
-- DROP TABLE #tmpSTHs
-- SELECT * FROM #tmpSTHs

-- Bring in CRMRecords
SELECT b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, SourceSystem, b.SSB_CRMSYSTEM_HOUSEHOLD_ID, COUNT(*) Count
INTO #tmpCRMRecords
-- Select *
FROM dbo.vwDimCustomer_ModAcctId b 
WHERE b.SourceSystem NOT LIKE 'Lead%' 
AND (SourceSystem LIKE '%CRM%' OR SourceSystem LIKE '%SFDC%' 
		)
AND [b].[SSB_CRMSYSTEM_ACCT_ID] IS NOT NULL
--AND b.SSID IN (SELECT contactid FROM ProdCopy.[vw_Contact])
GROUP BY b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, SourceSystem, b.SSB_CRMSYSTEM_HOUSEHOLD_ID
--DROP TABLE [#tmpCRMRecords]
--SELECT * from #tmpCRMRecords

CREATE INDEX idx_CRM_Acct_ID ON [#tmpCRMRecords] ([SSB_CRMSYSTEM_ACCT_ID])
CREATE INDEX idx_CRM_Contact_ID ON [#tmpCRMRecords] ([SSB_CRMSYSTEM_CONTACT_ID])

-- CREATE Branding Table ** ACCOUNT LEVEL w/ Transaction Level
TRUNCATE TABLE stg.Distinct_Accounts

INSERT INTO stg.Distinct_Accounts ([SSB_CRMSYSTEM_ACCT_ID])
SELECT DISTINCT [SSB_CRMSYSTEM_ACCT_ID] FROM [#tmpTrans] WHERE [SSB_CRMSYSTEM_ACCT_ID] IS NOT NULL
UNION SELECT DISTINCT [SSB_CRMSYSTEM_ACCT_ID] FROM [#tmpSTHs] WHERE [SSB_CRMSYSTEM_ACCT_ID] IS NOT NULL
UNION SELECT DISTINCT [SSB_CRMSYSTEM_ACCT_ID] FROM [#tmpCRMRecords] WHERE [SSB_CRMSYSTEM_ACCT_ID] IS NOT NULL

UPDATE a
SET [MaxTransDate] = trans.[MaxTransDate]
, STH = CASE WHEN ISNULL(sth.[Count],0) > 0 THEN 1 ELSE 0 END
, CRM = CASE WHEN ISNULL(crm.[Count],0) > 0 THEN 1 ELSE 0 END	
FROM stg.[Distinct_Accounts] a
LEFT JOIN (SELECT [SSB_CRMSYSTEM_ACCT_ID], MAX([MaxTransDate]) MaxTransDate FROM [#tmpTrans] GROUP BY [SSB_CRMSYSTEM_ACCT_ID]) trans ON [trans].[SSB_CRMSYSTEM_ACCT_ID] = [a].[SSB_CRMSYSTEM_ACCT_ID]
LEFT JOIN (SELECT [SSB_CRMSYSTEM_ACCT_ID], Sum(ISNULL(Count,0)) Count FROM [#tmpSTHs] GROUP BY [SSB_CRMSYSTEM_ACCT_ID]) sth ON [sth].[SSB_CRMSYSTEM_ACCT_ID] = [a].[SSB_CRMSYSTEM_ACCT_ID]
LEFT JOIN (SELECT [SSB_CRMSYSTEM_ACCT_ID], Sum(ISNULL(Count,0)) Count FROM [#tmpCRMRecords] GROUP BY [SSB_CRMSYSTEM_ACCT_ID]) crm ON [crm].[SSB_CRMSYSTEM_ACCT_ID] = [a].[SSB_CRMSYSTEM_ACCT_ID]

--SELECT * FROM stg.[Distinct_Accounts]


--DISTINCT HOUSEHOLDS
TRUNCATE TABLE stg.Distinct_Households

INSERT INTO stg.Distinct_Households (SSB_CRMSYSTEM_HOUSEHOLD_ID)
SELECT DISTINCT SSB_CRMSYSTEM_HOUSEHOLD_ID FROM [#tmpTrans] WHERE SSB_CRMSYSTEM_HOUSEHOLD_ID IS NOT NULL
UNION SELECT DISTINCT SSB_CRMSYSTEM_HOUSEHOLD_ID FROM [#tmpSTHs] WHERE SSB_CRMSYSTEM_HOUSEHOLD_ID IS NOT NULL
UNION SELECT DISTINCT SSB_CRMSYSTEM_HOUSEHOLD_ID FROM [#tmpCRMRecords] WHERE SSB_CRMSYSTEM_HOUSEHOLD_ID IS NOT NULL

UPDATE a
SET [MaxTransDate] = trans.[MaxTransDate]
, STH = CASE WHEN ISNULL(sth.[Count],0) > 0 THEN 1 ELSE 0 END
, CRM = CASE WHEN ISNULL(crm.[Count],0) > 0 THEN 1 ELSE 0 END	
FROM stg.distinct_households a
LEFT JOIN (SELECT SSB_CRMSYSTEM_HOUSEHOLD_ID, MAX([MaxTransDate]) MaxTransDate FROM [#tmpTrans] GROUP BY SSB_CRMSYSTEM_HOUSEHOLD_ID) trans ON [trans].SSB_CRMSYSTEM_HOUSEHOLD_ID = [a].SSB_CRMSYSTEM_HOUSEHOLD_ID
LEFT JOIN (SELECT SSB_CRMSYSTEM_HOUSEHOLD_ID, Sum(ISNULL(Count,0)) Count FROM [#tmpSTHs] GROUP BY SSB_CRMSYSTEM_HOUSEHOLD_ID) sth ON [sth].SSB_CRMSYSTEM_HOUSEHOLD_ID = [a].SSB_CRMSYSTEM_HOUSEHOLD_ID
LEFT JOIN (SELECT SSB_CRMSYSTEM_HOUSEHOLD_ID, Sum(ISNULL(Count,0)) Count FROM [#tmpCRMRecords] GROUP BY SSB_CRMSYSTEM_HOUSEHOLD_ID) crm ON [crm].SSB_CRMSYSTEM_HOUSEHOLD_ID = [a].SSB_CRMSYSTEM_HOUSEHOLD_ID

--SELECT * FROM stg.[Distinct_Accounts]

-- distinct contacts
TRUNCATE TABLE [stg].[Distinct_Contacts]

INSERT INTO [stg].[Distinct_Contacts] ([SSB_CRMSYSTEM_ACCT_ID], [SSB_CRMSYSTEM_CONTACT_ID])
SELECT DISTINCT [SSB_CRMSYSTEM_ACCT_ID], [SSB_CRMSYSTEM_CONTACT_ID] FROM [#tmpTrans] WHERE [SSB_CRMSYSTEM_ACCT_ID] IS NOT NULL

UNION SELECT DISTINCT [SSB_CRMSYSTEM_ACCT_ID], [SSB_CRMSYSTEM_CONTACT_ID] FROM [#tmpSTHs] WHERE [SSB_CRMSYSTEM_ACCT_ID] IS NOT NULL

UNION SELECT DISTINCT comp.[SSB_CRMSYSTEM_ACCT_ID], comp.[SSB_CRMSYSTEM_CONTACT_ID] 
FROM [#tmpCRMRecords] crm INNER JOIN dbo.vwCompositeRecord_ModAcctID comp ON comp.SSB_CRMSYSTEM_CONTACT_ID = crm.SSB_CRMSYSTEM_CONTACT_ID WHERE crm.[SSB_CRMSYSTEM_ACCT_ID] IS NOT NULL 




UPDATE a
SET [MaxTransDate] = trans.[MaxTransDate]
, STH = CASE WHEN ISNULL(sth.[Count],0) > 0 THEN 1 ELSE 0 END
, CRM = CASE WHEN ISNULL(crm.[Count],0) > 0 THEN 1 ELSE 0 END	
FROM stg.[Distinct_Contacts] a
LEFT JOIN [#tmpTrans] trans ON [trans].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]
LEFT JOIN [#tmpSTHs] sth ON [sth].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]
LEFT JOIN [#tmpCRMRecords] crm ON [crm].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]

SELECT a.SSB_CRMSYSTEM_ACCT_ID
, a.MaxTransDate
, a.STH
, c.SeasonTicket_Years
, CRM
-- Select *
INTO #tmp_Results_Acct
FROM stg.Distinct_Accounts a 
LEFT JOIN dbo.CRMProcess_Acct_SeasonTicketHolders c ON c.SSB_CRMSYSTEM_ACCT_ID = a.SSB_CRMSYSTEM_ACCT_ID


SELECT a.SSB_CRMSYSTEM_household_ID
, a.MaxTransDate
, a.STH
, NULL AS SeasonTicket_Years
, CRM
-- Select *
INTO #tmp_Results_Household
FROM stg.Distinct_Households a 


--for contacts
SELECT a.SSB_CRMSYSTEM_ACCT_ID
,a.SSB_CRMSYSTEM_CONTACT_ID
, a.MaxTransDate
, a.STH
, c.SeasonTicket_Years
, CRM
--, *
INTO #tmp_Results_Contact
FROM stg.Distinct_Contacts a 
LEFT JOIN dbo.CRMProcess_Contact_SeasonTicketHolders c ON c.SSB_CRMSYSTEM_CONTACT_ID = a.SSB_CRMSYSTEM_CONTACT_ID



TRUNCATE TABLE dbo.CRMProcess_DistinctAccounts

INSERT INTO dbo.CRMProcess_DistinctAccounts
SELECT *
, 0 CriteriaMet
FROM #tmp_Results_Acct

UPDATE a
SET CRMLoadCriteriaMet = 1
--SELECT *
FROM dbo.[CRMProcess_DistinctAccounts] a 
WHERE MaxTransDate IS NOT NULL
OR CRM = 1
--OR STH = 1


TRUNCATE TABLE dbo.CRMProcess_DistinctHouseholds

INSERT INTO dbo.CRMProcess_DistinctHouseholds
SELECT *
, 0 CriteriaMet
FROM #tmp_Results_Household

UPDATE a
SET CRMLoadCriteriaMet = 1
--SELECT *
FROM dbo.[CRMProcess_DistinctHouseholds] a 
WHERE MaxTransDate IS NOT NULL
OR CRM = 1
--OR STH = 1



TRUNCATE TABLE dbo.CRMProcess_DistinctContacts

INSERT INTO dbo.CRMProcess_DistinctContacts
SELECT *
, 0 
FROM #tmp_Results_Contact

UPDATE a
SET CRMLoadCriteriaMet = 1
FROM dbo.[CRMProcess_DistinctContacts] a 
WHERE MaxTransDate IS NOT NULL
OR CRM = 1
--OR STH = 1

--SELECT * FROM dbo.[CRMProcess_DistinctAccounts]
--SELECT * FROM [dbo].[CRMProcess_DistinctContacts]

GO
