SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create VIEW [dbo].[vwCRMLoad_Email_Prep] AS
SELECT e.* FROM dbo.email e
INNER JOIN dbo.[CRMLoad_Contact_ProcessLoad_Criteria] c 
ON [c].[SSB_CRMSYSTEM_CONTACT_ID] = [e].[SSB_CRMSYSTEM_CONTACT_ID]
GO
