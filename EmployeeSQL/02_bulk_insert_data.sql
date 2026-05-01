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

/*******************************************************************************
   Step 1 of 6 — Load DEPARTMENTS
   Parent table. Must be loaded before DEPT_EMP and DEPT_MANAGER.
********************************************************************************/
BULK INSERT [dbo].[DEPARTMENTS]
FROM 'C:\Path to file'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    FIELDQUOTE      = '"',
    CODEPAGE        = 'RAW',
    TABLOCK
);
GO

/*******************************************************************************
   Step 2 of 6 — Load EMPLOYEES
   Parent table. Must be loaded before TITLES, SALARIES, DEPT_EMP, DEPT_MANAGER.
********************************************************************************/
BULK INSERT [dbo].[EMPLOYEES]
FROM 'C:\Path to file'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    FIELDQUOTE      = '"',
    CODEPAGE        = 'RAW',
    TABLOCK
);
GO

/*******************************************************************************
   Step 3 of 6 — Load TITLES
   Child of EMPLOYEES.
********************************************************************************/
BULK INSERT [dbo].[TITLES]
FROM 'C:\Path to file'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    FIELDQUOTE      = '"',
    CODEPAGE        = 'RAW',
    TABLOCK
);
GO

/*******************************************************************************
   Step 4 of 6 — Load SALARIES
   Child of EMPLOYEES.
********************************************************************************/
BULK INSERT [dbo].[SALARIES]
FROM 'C:\Path to file'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    FIELDQUOTE      = '"',
    CODEPAGE        = 'RAW',
    TABLOCK
);
GO

/*******************************************************************************
   Step 5 of 6 — Load DEPT_EMP
   Child of EMPLOYEES and DEPARTMENTS.
********************************************************************************/
BULK INSERT [dbo].[DEPT_EMP]
FROM 'C:\Path to file'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    FIELDQUOTE      = '"',
    CODEPAGE        = 'RAW',
    TABLOCK
);
GO

/*******************************************************************************
   Step 6 of 6 — Load DEPT_MANAGER
   Child of EMPLOYEES and DEPARTMENTS.
********************************************************************************/
BULK INSERT [dbo].[DEPT_MANAGER]
FROM 'C:\Path to file'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',
    FIELDQUOTE      = '"',
    CODEPAGE        = 'RAW',
    TABLOCK
);
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
