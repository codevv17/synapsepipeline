IF OBJECT_ID('dbo.household_income_raw', 'U') IS NOT NULL
    DROP TABLE dbo.household_income_raw;
GO


CREATE TABLE dbo.household_income_raw
(
    Prop_0 VARCHAR(4000) NULL,
    Prop_1 VARCHAR(4000) NULL,
    Prop_2 VARCHAR(4000) NULL,
    Prop_3 VARCHAR(4000) NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    HEAP
);
GO



IF OBJECT_ID('dbo.household_income', 'U') IS NOT NULL
    DROP TABLE dbo.household_income;
GO

CREATE TABLE dbo.household_income
(
    neighborhood        VARCHAR(200)   NOT NULL,
    id                  INT            NOT NULL,
    estimate            BIGINT         NULL,
    margin_of_error     DECIMAL(18,3)  NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    HEAP
);
GO


IF OBJECT_ID('dbo.usp_household_income', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_household_income;
GO

CREATE PROCEDURE dbo.usp_household_income
AS
BEGIN
    TRUNCATE TABLE dbo.household_income;

    INSERT INTO dbo.household_income
    (
        neighborhood,
        id,
        estimate,
        margin_of_error
    )
    SELECT
        LTRIM(RTRIM(neighborhood)) AS neighborhood,
        TRY_CAST(NULLIF(LTRIM(RTRIM(id)), '') AS INT) AS id,
        TRY_CAST(NULLIF(LTRIM(RTRIM(estimate)), '') AS BIGINT) AS estimate,
        TRY_CAST(NULLIF(LTRIM(RTRIM(margin_of_error)), '') AS DECIMAL(18,3)) AS margin_of_error
    FROM dbo.household_income_raw;
END;
GO


-- EXEC dbo.usp_household_income;
