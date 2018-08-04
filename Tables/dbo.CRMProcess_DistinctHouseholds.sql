CREATE TABLE [dbo].[CRMProcess_DistinctHouseholds]
(
[SSB_CRMSYSTEM_HOUSEHOLD_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MaxTransDate] [datetime] NULL,
[STH] [int] NULL,
[SeasonTicket_Years] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM] [int] NULL,
[CRMLoadCriteriaMet] [bit] NULL
)
GO
ALTER TABLE [dbo].[CRMProcess_DistinctHouseholds] ADD CONSTRAINT [PK_CRMProcess_DistinctHouseHold] PRIMARY KEY CLUSTERED  ([SSB_CRMSYSTEM_HOUSEHOLD_ID])
GO
