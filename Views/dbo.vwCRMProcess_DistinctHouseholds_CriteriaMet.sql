SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwCRMProcess_DistinctHouseholds_CriteriaMet]
AS
SELECT * FROM dbo.CRMProcess_DistinctHouseholds
WHERE [CRMLoadCriteriaMet] = 1
GO
