CREATE TABLE [stg].[HouseHold]
(
[SSB_CRMSYSTEM_Acct_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_HOUSEHOLD_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_Contact_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsBusinessAccount] [int] NOT NULL,
[FullName] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryStreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryCity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryState] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryZip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryCountry] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailPrimary] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[crm_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDM_UpdatedDate] [datetime] NOT NULL,
[CRMProcess_UpdatedDate] [datetime] NULL,
[CRM_LoadDate] [datetime] NULL,
[LastSFDCLoad_Error] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastSFDCLoad_AttemptDate] [datetime] NULL
)
GO
ALTER TABLE [stg].[HouseHold] ADD CONSTRAINT [PK_Household_1] PRIMARY KEY CLUSTERED  ([SSB_CRMSYSTEM_HOUSEHOLD_ID])
GO
