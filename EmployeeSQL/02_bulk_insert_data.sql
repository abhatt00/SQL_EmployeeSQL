/*******************************************************************************
   Script:      02_bulk_insert_data.sql
   Description: Loads all six CSV files into the EmployeeSQL database
                using BULK INSERT in correct dependency order.

 
   DB Server:   Microsoft SQL Server 2022
   Author:      Abhishek Bhatt
********************************************************************************/

USE [EmployeeSQL];
GO

/*******************************************************************************
   Cleanup — clear all tables before reloading
   Delete in child-first order to respect FK constraints
********************************************************************************/
DELETE FROM [dbo].[DEPT_MANAGER];
DELETE FROM [dbo].[DEPT_EMP];
DELETE FROM [dbo].[TITLES];
DELETE FROM [dbo].[SALARIES];
DELETE FROM [dbo].[EMPLOYEES];
DELETE FROM [dbo].[DEPARTMENTS];
GO

-- Drop staging table if it exists from a previous interrupted run
IF OBJECT_ID('dbo.STG_EMPLOYEES', 'U') IS NOT NULL DROP TABLE [dbo].[STG_EMPLOYEES];
IF OBJECT_ID('dbo.STG_DEPARTMENTS', 'U') IS NOT NULL DROP TABLE [dbo].[STG_DEPARTMENTS];
IF OBJECT_ID('dbo.STG_TITLES', 'U') IS NOT NULL DROP TABLE [dbo].[STG_TITLES];
IF OBJECT_ID('dbo.STG_SALARIES', 'U') IS NOT NULL DROP TABLE [dbo].[STG_SALARIES];
IF OBJECT_ID('dbo.STG_DEPT_EMP', 'U') IS NOT NULL DROP TABLE [dbo].[STG_DEPT_EMP];
IF OBJECT_ID('dbo.STG_DEPT_MANAGER', 'U') IS NOT NULL DROP TABLE [dbo].[STG_DEPT_MANAGER];
GO

/*******************************************************************************
   Step 1 of 6 — Load DEPARTMENTS
********************************************************************************/
CREATE TABLE [dbo].[STG_DEPARTMENTS] (
    [DEPT_NO]   VARCHAR(10),
    [DEPT_NAME] VARCHAR(50)
);
GO

BULK INSERT [dbo].[STG_DEPARTMENTS]
FROM 'C:\path to file'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    CODEPAGE        = 'RAW',
    TABLOCK
);
GO

INSERT INTO [dbo].[DEPARTMENTS] ([DEPT_NO], [DEPT_NAME])
SELECT
    LTRIM(RTRIM([DEPT_NO])),
    LTRIM(RTRIM(REPLACE(REPLACE([DEPT_NAME],CHAR(13),''),CHAR(10),'')))
FROM [dbo].[STG_DEPARTMENTS];
GO

DROP TABLE [dbo].[STG_DEPARTMENTS];
GO

/*******************************************************************************
   Step 2 of 6 — Load EMPLOYEES
********************************************************************************/
CREATE TABLE [dbo].[STG_EMPLOYEES] (
    [EMP_NO]     VARCHAR(10),
    [BIRTH_DATE] VARCHAR(20),
    [FIRST_NAME] VARCHAR(100),
    [LAST_NAME]  VARCHAR(100),
    [GENDER]     VARCHAR(1),
    [HIRE_DATE]  VARCHAR(20)
);
GO

BULK INSERT [dbo].[STG_EMPLOYEES]
FROM 'C:\path to file'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    CODEPAGE        = 'RAW',
    TABLOCK
);
GO

INSERT INTO [dbo].[EMPLOYEES] (
    [EMP_NO], [BIRTH_DATE], [FIRST_NAME], [LAST_NAME], [GENDER], [HIRE_DATE]
)
SELECT
    CAST(LTRIM(RTRIM([EMP_NO]))                                              AS INTEGER),
    CAST(LTRIM(RTRIM([BIRTH_DATE]))                                          AS DATE),
    LTRIM(RTRIM([FIRST_NAME])),
    LTRIM(RTRIM([LAST_NAME])),
    LTRIM(RTRIM([GENDER])),
    CAST(LTRIM(RTRIM(REPLACE(REPLACE([HIRE_DATE],CHAR(13),''),CHAR(10),''))) AS DATE)
FROM [dbo].[STG_EMPLOYEES];
GO

DROP TABLE [dbo].[STG_EMPLOYEES];
GO

/*******************************************************************************
   Step 3 of 6 — Load TITLES
********************************************************************************/
CREATE TABLE [dbo].[STG_TITLES] (
    [EMP_NO]    VARCHAR(10),
    [TITLE]     VARCHAR(50),
    [FROM_DATE] VARCHAR(20),
    [TO_DATE]   VARCHAR(20)
);
GO

BULK INSERT [dbo].[STG_TITLES]
FROM 'C:\path to file'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    CODEPAGE        = 'RAW',
    TABLOCK
);
GO

INSERT INTO [dbo].[TITLES] (
    [EMP_NO], [TITLE], [FROM_DATE], [TO_DATE]
)
SELECT
    CAST(LTRIM(RTRIM([EMP_NO]))                                            AS INTEGER),
    LTRIM(RTRIM([TITLE])),
    CAST(LTRIM(RTRIM([FROM_DATE]))                                         AS DATE),
    CAST(LTRIM(RTRIM(REPLACE(REPLACE([TO_DATE],CHAR(13),''),CHAR(10),''))) AS DATE)
FROM [dbo].[STG_TITLES];
GO

DROP TABLE [dbo].[STG_TITLES];
GO

/*******************************************************************************
   Step 4 of 6 — Load SALARIES
********************************************************************************/
CREATE TABLE [dbo].[STG_SALARIES] (
    [EMP_NO]    VARCHAR(10),
    [SALARY]    VARCHAR(10),
    [FROM_DATE] VARCHAR(20),
    [TO_DATE]   VARCHAR(20)
);
GO

BULK INSERT [dbo].[STG_SALARIES]
FROM 'C:\path to file'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    CODEPAGE        = 'RAW',
    TABLOCK
);
GO

INSERT INTO [dbo].[SALARIES] (
    [EMP_NO], [SALARY], [FROM_DATE], [TO_DATE]
)
SELECT
    CAST(LTRIM(RTRIM([EMP_NO]))                                            AS INTEGER),
    CAST(LTRIM(RTRIM([SALARY]))                                            AS INTEGER),
    CAST(LTRIM(RTRIM([FROM_DATE]))                                         AS DATE),
    CAST(LTRIM(RTRIM(REPLACE(REPLACE([TO_DATE],CHAR(13),''),CHAR(10),''))) AS DATE)
FROM [dbo].[STG_SALARIES];
GO

DROP TABLE [dbo].[STG_SALARIES];
GO

/*******************************************************************************
   Step 5 of 6 — Load DEPT_EMP
********************************************************************************/
CREATE TABLE [dbo].[STG_DEPT_EMP] (
    [EMP_NO]    VARCHAR(10),
    [DEPT_NO]   VARCHAR(10),
    [FROM_DATE] VARCHAR(20),
    [TO_DATE]   VARCHAR(20)
);
GO

BULK INSERT [dbo].[STG_DEPT_EMP]
FROM 'C:\path to file'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    CODEPAGE        = 'RAW',
    TABLOCK
);
GO

INSERT INTO [dbo].[DEPT_EMP] (
    [EMP_NO], [DEPT_NO], [FROM_DATE], [TO_DATE]
)
SELECT
    CAST(LTRIM(RTRIM([EMP_NO]))                                            AS INTEGER),
    LTRIM(RTRIM([DEPT_NO])),
    CAST(LTRIM(RTRIM([FROM_DATE]))                                         AS DATE),
    CAST(LTRIM(RTRIM(REPLACE(REPLACE([TO_DATE],CHAR(13),''),CHAR(10),''))) AS DATE)
FROM [dbo].[STG_DEPT_EMP];
GO

DROP TABLE [dbo].[STG_DEPT_EMP];
GO

/*******************************************************************************
   Step 6 of 6 — Load DEPT_MANAGER
********************************************************************************/
CREATE TABLE [dbo].[STG_DEPT_MANAGER] (
    [DEPT_NO]   VARCHAR(10),
    [EMP_NO]    VARCHAR(10),
    [FROM_DATE] VARCHAR(20),
    [TO_DATE]   VARCHAR(20)
);
GO

BULK INSERT [dbo].[STG_DEPT_MANAGER]
FROM 'C:\path to file'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    CODEPAGE        = 'RAW',
    TABLOCK
);
GO

INSERT INTO [dbo].[DEPT_MANAGER] (
    [DEPT_NO], [EMP_NO], [FROM_DATE], [TO_DATE]
)
SELECT
    LTRIM(RTRIM([DEPT_NO])),
    CAST(LTRIM(RTRIM([EMP_NO]))                                            AS INTEGER),
    CAST(LTRIM(RTRIM([FROM_DATE]))                                         AS DATE),
    CAST(LTRIM(RTRIM(REPLACE(REPLACE([TO_DATE],CHAR(13),''),CHAR(10),''))) AS DATE)
FROM [dbo].[STG_DEPT_MANAGER];
GO

DROP TABLE [dbo].[STG_DEPT_MANAGER];
GO

/*******************************************************************************
   Verification — Confirm row counts across all six tables
********************************************************************************/
SELECT 'DEPARTMENTS'  AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM [dbo].[DEPARTMENTS]
UNION ALL
SELECT 'EMPLOYEES',                  COUNT(*)              FROM [dbo].[EMPLOYEES]
UNION ALL
SELECT 'TITLES',                     COUNT(*)              FROM [dbo].[TITLES]
UNION ALL
SELECT 'SALARIES',                   COUNT(*)              FROM [dbo].[SALARIES]
UNION ALL
SELECT 'DEPT_EMP',                   COUNT(*)              FROM [dbo].[DEPT_EMP]
UNION ALL
SELECT 'DEPT_MANAGER',               COUNT(*)              FROM [dbo].[DEPT_MANAGER]
ORDER BY TABLE_NAME;

