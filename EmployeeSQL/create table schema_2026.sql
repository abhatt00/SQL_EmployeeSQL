/*******************************************************************************
   "Employee SQL Database: A Mystery in Two Parts"
   Script: create table schema.sql
   Description: Creates the EmployeeSQL database and its tables.
   DB Server: SqlServer 2022
   Author: Abhishek Bhatt
********************************************************************************/
USE [master];
GO

/*******************************************************************************
   Drop database if it exists
********************************************************************************/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'EmployeeSQL')
BEGIN
    ALTER DATABASE [EmployeeSQL] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [EmployeeSQL];
END

GO

/*******************************************************************************
   Create database
********************************************************************************/
CREATE DATABASE [EmployeeSQL];
GO

USE [EmployeeSQL];
GO

/*******************************************************************************
   Create Tables
********************************************************************************/

--Create tables and import data--
-- For each csv file that contains data, create a table in which to import that data that contains a column name and a column value to match the csv.
create table [dbo].[EMPLOYEES] (
    [EMP_NO] INTEGER not null,
    [BIRTH_DATE] DATE not null,
    [FIRST_NAME] VARCHAR(100) not null,
    [LAST_NAME] VARCHAR(100) not null,
    [GENDER] VARCHAR(1) not null CONSTRAINT [ck_EMPLOYEES_GENDER] CHECK ([GENDER] IN ('M', 'F')),
    [HIRE_DATE] DATE not null,
    CONSTRAINT [pk_EMPLOYEES] PRIMARY KEY CLUSTERED ([EMP_NO] ASC)
);
GO

create table [dbo].[DEPARTMENTS] (
    [DEPT_NO] VARCHAR(4) not null,
    [DEPT_NAME] VARCHAR(30) not null,
    CONSTRAINT [pk_DEPARTMENTS] PRIMARY KEY CLUSTERED ([DEPT_NO] ASC)

);
GO

create table [dbo].[TITLES] (
    [EMP_NO] INTEGER not null,
    [TITLE] VARCHAR(50) not null,
    [FROM_DATE] DATE not null,
    [TO_DATE] DATE not null,
    CONSTRAINT [fk_TITLES_EMP_NO] FOREIGN KEY ([EMP_NO])
        REFERENCES [dbo].[EMPLOYEES] ([EMP_NO])
);
GO

create table [dbo].[SALARIES] (
    [EMP_NO] INTEGER not null,
    [SALARY] INTEGER not null,
    [FROM_DATE] DATE not null,
    [TO_DATE] DATE not null,
    CONSTRAINT [fk_SALARIES_EMP_NO] FOREIGN KEY ([EMP_NO])
        REFERENCES [dbo].[EMPLOYEES] ([EMP_NO])
);
GO

create table [dbo].[DEPT_MANAGER] (
    [DEPT_NO] VARCHAR(4) not null,
    [EMP_NO] INTEGER not null,
    [FROM_DATE] DATE not null,
    [TO_DATE] DATE not null,
    CONSTRAINT [pk_DEPT_MANAGER] PRIMARY KEY CLUSTERED ([DEPT_NO] ASC, [EMP_NO] ASC),
    CONSTRAINT [fk_DEPT_MANAGER_DEPT_NO] FOREIGN KEY ([DEPT_NO])
        REFERENCES [dbo].[DEPARTMENTS] ([DEPT_NO]),
    CONSTRAINT [fk_DEPT_MANAGER_EMP_NO] FOREIGN KEY ([EMP_NO])
        REFERENCES [dbo].[EMPLOYEES] ([EMP_NO])
);

GO
create table [dbo].[DEPT_EMP] (
    [EMP_NO] INTEGER not null,
    [DEPT_NO] VARCHAR(4) not null,
    [FROM_DATE] DATE not null,
    [TO_DATE] DATE not null,
    CONSTRAINT [pk_DEPT_EMP] PRIMARY KEY CLUSTERED ([EMP_NO] ASC, [DEPT_NO] ASC),
    CONSTRAINT [fk_DEPT_EMP_EMP_NO] FOREIGN KEY ([EMP_NO])
        REFERENCES [dbo].[EMPLOYEES] ([EMP_NO]),
    CONSTRAINT [fk_DEPT_EMP_DEPT_NO] FOREIGN KEY ([DEPT_NO])
        REFERENCES [dbo].[DEPARTMENTS] ([DEPT_NO])

);
GO

/*******************************************************************************
   Non-Clustered Indexes on Foreign Key Columns
********************************************************************************/
CREATE NONCLUSTERED INDEX [ix_TITLES_EMP_NO]
    ON [dbo].[TITLES] ([EMP_NO] ASC)
;
GO

CREATE NONCLUSTERED INDEX [ix_SALARIES_EMP_NO]
    ON [dbo].[SALARIES] ([EMP_NO] ASC)
;
GO

CREATE NONCLUSTERED INDEX [ix_DEPT_MANAGER_EMP_NO]
    ON [dbo].[DEPT_MANAGER] ([EMP_NO] ASC)
;
GO

CREATE NONCLUSTERED INDEX [ix_DEPT_EMP_DEPT_NO]
    ON [dbo].[DEPT_EMP] ([DEPT_NO] ASC)
;
GO