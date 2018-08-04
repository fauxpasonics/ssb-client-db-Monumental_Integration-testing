CREATE TABLE [stg].[Distinct_Households]
(
[SSB_CRMSYSTEM_HOUSEHOLD_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MaxTransDate] [datetime] NULL,
[STH] [int] NULL,
[CRM] [int] NULL
)
GO
ALTER TABLE [stg].[Distinct_Households] ADD CONSTRAINT [PK_Distinct_Households] PRIMARY KEY CLUSTERED  ([SSB_CRMSYSTEM_HOUSEHOLD_ID])
GO
