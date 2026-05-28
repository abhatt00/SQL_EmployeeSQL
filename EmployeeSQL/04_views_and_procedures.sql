/*******************************************************************************
   Script:      04_views_and_procedures.sql
   Description: Creates views and stored procedures for the EmployeeSQL database.
                Views provide simplified, pre-joined datasets for Tableau.
                Stored procedures provide parameterized, reusable query logic.
   DB Server:   Microsoft SQL Server 2022
   Author:      Abhishek Bhatt
********************************************************************************/

USE [EmployeeSQL];
GO

/*******************************************************************************
   VIEWS
********************************************************************************/

/*******************************************************************************
   View: vw_EmployeeDetails
   Description: Flat view joining employees, salaries, titles, department
                assignments, and department names. Primary data source for
                Tableau dashboards. Returns all historical records per employee
                allowing Tableau to filter by date range or current records.
********************************************************************************/

CREATE OR ALTER VIEW [dbo].[vw_EmployeeDetails] AS

SELECT
  e.EMP_NO
, e.LAST_NAME
, e.FIRST_NAME
, e.FIRST_NAME + ' ' + e.LAST_NAME AS FULL_NAME
, e.GENDER
, e.BIRTH_DATE
, e.HIRE_DATE
, t.TITLE
, t.FROM_DATE   AS  TITLE_FROM_DATE
, t.TO_DATE     AS  TITLE_TO_DATE
, s.SALARY
, s.FROM_DATE   AS  SALARY_FROM_DATE
, s.TO_DATE     AS  SALARY_TO_DATE
, de.DEPT_NO
, d.DEPT_NAME
, de.FROM_DATE  AS  DEPT_FROM_DATE
, de.FROM_DATE  AS  DEPT_TO_DATE
FROM dbo.EMPLOYEES e
JOIN dbo.SALARIES s
    ON s.EMP_NO=e.EMP_NO
JOIN dbo.TITLES t
    ON t.EMP_NO=e.EMP_NO
JOIN dbo.DEPT_EMP de
    ON de.EMP_NO=e.EMP_NO
JOIN dbo.DEPARTMENTS d
    ON d.DEPT_NO=de.DEPT_NO
GO


/*******************************************************************************
   View: vw_DepartmentManagers
   Description: All department manager assignments with department and
                employee details. Includes full history of manager changes.
                Used for department hierarchy dashboard in Tableau.
********************************************************************************/

CREATE OR ALTER VIEW [dbo].[vw_DepartmentManagers] AS
SELECT
  d.DEPT_NO
, d.DEPT_NAME
, e.EMP_NO      AS  MANAGER_EMP_NO
, e.FIRST_NAME  AS  MANAGER_FIRST_NAME
, e.LAST_NAME   AS  MANAGER_LAST_NAME
, e.FIRST_NAME + ' ' + e.LAST_NAME      AS MANAGER_FULL_NAME
, e.GENDER
, e.HIRE_DATE
, s.SALARY
, dm.FROM_DATE  AS  MGMT_FROM_DATE
, dm.TO_DATE    AS  MGMT_TO_DATE
FROM dbo.DEPT_MANAGER dm
JOIN dbo.DEPARTMENTS d
    ON dm.DEPT_NO=d.DEPT_NO
JOIN dbo.EMPLOYEES e
    ON e.EMP_NO=dm.EMP_NO
JOIN dbo.SALARIES s
    ON s.EMP_NO=e.EMP_NO
GO


/*******************************************************************************
   View: vw_SalaryAnalysis
   Description: Employee salary records joined with title, department, gender,
                and hire date. Includes all historical salary records.
                Used for salary and compensation dashboard in Tableau.
********************************************************************************/

CREATE OR ALTER VIEW [dbo].[vw_SalaryAnalysis] AS

SELECT
  e.EMP_NO
, e.LAST_NAME   AS  LAST_NAME
, e.FIRST_NAME  AS  FIRST_NAME
, e.FIRST_NAME + ' ' + e. LAST_NAME     AS  FULL_NAME
, e.GENDER
, e.HIRE_DATE
, DATEDIFF(YEAR, e.HIRE_DATE,GETDATE()) AS YEARS_OF_SERVICE
FROM dbo.EMPLOYEES e
JOIN dbo.SALARIES s
    ON s.EMP_NO=e.EMP_NO
JOIN dbo.TITLES t
    ON t.EMP_NO=e.EMP_NO
JOIN dbo.DEPT_EMP de
    ON de.EMP_NO=e.EMP_NO
JOIN dbo.DEPARTMENTS d
    ON d.DEPT_NO=de.DEPT_NO
GO


/*******************************************************************************
   STORED PROCEDURES
********************************************************************************/

/*******************************************************************************
   Procedure: usp_GetEmployeesByDepartment
   Description: Returns all employees and their details for a given department.
                Accepts department name as a parameter.
   Usage:       EXEC usp_GetEmployeesByDepartment @DeptName = 'Sales';
********************************************************************************/

CREATE OR ALTER PROCEDURE [dbo].[usp_GetEmployeesByDepartment]
    @DeptName VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

SELECT
e.EMP_NO
, e.FIRST_NAME
, e.LAST_NAME
, e.GENDER
, e.HIRE_DATE
, t.TITLE
, s.SALARY
, d.DEPT_NAME
FROM dbo.EMPLOYEES e
JOIN dbo.SALARIES s
    ON s.EMP_NO=e.EMP_NO
JOIN dbo.TITLES t
    ON t.EMP_NO=e.EMP_NO
JOIN dbo.DEPT_EMP de
    ON de.EMP_NO=e.EMP_NO
JOIN dbo.DEPARTMENTS d
    ON d.DEPT_NO=de.DEPT_NO
WHERE d.DEPT_NAME   = @DeptName
    AND t.TO_DATE   = '9999-01-01'
    AND de.TO_DATE  = '9999-01-01'
ORDER BY e.LAST_NAME, e.FIRST_NAME
;

END;
GO


/*******************************************************************************
   Procedure: usp_GetEmployeesBySalaryThreshold
   Description: Returns all employees earning above a specified salary,
                with their current title and department.
                Accepts minimum salary as a parameter.
   Usage:       EXEC usp_GetEmployeesBySalaryThreshold @MinSalary = 90000;
********************************************************************************/
CREATE OR ALTER PROCEDURE [dbo].[usp_GetEmployeesBySalaryThreshold]
    @MinSalary INT
AS
BEGIN
    SET NOCOUNT ON;

SELECT
  e.EMP_NO
, e.FIRST_NAME
, e.LAST_NAME
, e.GENDER
, e.HIRE_DATE
, t.TITLE
, d.DEPT_NAME
, s.SALARY
FROM dbo.EMPLOYEES e
JOIN dbo.SALARIES s
    ON s.EMP_NO=e.EMP_NO
JOIN dbo.TITLES t
    ON t.EMP_NO=e.EMP_NO
JOIN dbo.DEPT_EMP de
    ON de.EMP_NO=e.EMP_NO
JOIN dbo.DEPARTMENTS d
    ON d.DEPT_NO=de.DEPT_NO
WHERE s.SALARY > @MinSalary
AND t.TO_DATE   = '9999-01-01'
AND de.TO_DATE  = '9999-01-01'
ORDER BY s.SALARY DESC
;

END;
GO


/*******************************************************************************
   Procedure: usp_GetDepartmentSummary
   Description: Returns headcount, average salary, min salary, and max salary
                for a specified department. Current employees only.
                Accepts department name as a parameter.
   Usage:       EXEC usp_GetDepartmentSummary @DeptName = 'Engineering';
********************************************************************************/
CREATE OR ALTER PROCEDURE [dbo].[usp_GetDepartmentSummary]
    @DeptName VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

SELECT
  d.DEPT_NAME
, COUNT(DISTINCT e.EMP_NO)              AS HEADCOUNT
, AVG(CAST(s.SALARY AS DECIMAL(10,2)))  AS AVG_SALARY
, MIN(s.SALARY)                         AS MIN_SALARY
, MAX(s.SALARY)                         AS MAX_SALARY
FROM dbo.EMPLOYEES e
JOIN dbo.SALARIES s
    ON s.EMP_NO=e.EMP_NO
JOIN dbo.DEPT_EMP de
    ON de.EMP_NO=e.EMP_NO
JOIN dbo.DEPARTMENTS d
    ON d.DEPT_NO=de.DEPT_NO
WHERE d.DEPT_NAME       = @DeptName
AND de.TO_DATE          = '9999-01-01'
GROUP BY d.DEPT_NAME
;

END;
GO


/*******************************************************************************
   Verification — Confirm views and procedures were created successfully
********************************************************************************/
SELECT
    name         AS OBJECT_NAME,
    type_desc    AS OBJECT_TYPE
FROM sys.objects
WHERE type IN ('V', 'P')
  AND is_ms_shipped = 0
ORDER BY type_desc, name
;
GO

