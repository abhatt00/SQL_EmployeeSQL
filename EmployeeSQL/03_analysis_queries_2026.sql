/*******************************************************************************
   Script:      03_analysis_queries.sql
   Description: Analysis queries for the EmployeeSQL database.
                Answers 14 business questions about Pewlett Hackard employees.
                Queries written in T-SQL for Microsoft SQL Server 2022.
   DB Server:   Microsoft SQL Server 2022
   Author:      Abhishek Bhatt
********************************************************************************/

/** *************************************************
Utilize the proper Database
************************************************* **/
USE [EmployeeSQL];
GO

/** *************************************************
Create queries to answer the questions
************************************************* **/

--List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT
  e.EMP_NO
, e.LAST_NAME
, e.FIRST_NAME
, e.GENDER
, s.SALARY
FROM dbo.EMPLOYEES e
LEFT JOIN dbo.SALARIES s
	ON e.EMP_NO=s.EMP_NO
;

--List employees who were hired in 1986.
SELECT
  e.EMP_NO
, e.LAST_NAME
, e.FIRST_NAME
, e.HIRE_DATE
, s.SALARY
FROM dbo.EMPLOYEES e
LEFT JOIN dbo.SALARIES s
	ON e.EMP_NO=s.EMP_NO
--WHERE e.HIRE_DATE BETWEEN '1986-01-01' AND '1986-12-31'
WHERE YEAR(e.HIRE_DATE) = 1986
ORDER BY e.HIRE_DATE ASC
;

--List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
SELECT
  dm.DEPT_NO
, d.DEPT_NAME
, dm.EMP_NO
, e.LAST_NAME
, e.FIRST_NAME
, dm.FROM_DATE
, dm.TO_DATE
FROM dbo.DEPT_MANAGER dm
LEFT JOIN dbo.DEPARTMENTS d
	ON dm.DEPT_NO=d.DEPT_NO
LEFT JOIN dbo.EMPLOYEES e
	ON e.EMP_NO=dm.EMP_NO
ORDER BY dm.DEPT_NO, dm.FROM_DATE
;

--List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT
e.EMP_NO
, e.LAST_NAME
, e.FIRST_NAME
, d.DEPT_NAME
FROM dbo.EMPLOYEES e
LEFT JOIN dbo.DEPT_EMP de
	ON e.EMP_NO=de.EMP_NO
LEFT JOIN dbo.DEPARTMENTS d
	ON de.DEPT_NO=d.DEPT_NO
;

--List all employees whose first name is "Hercules" and last names begin with "B."
SELECT
e.EMP_NO
, e.LAST_NAME
, e.FIRST_NAME
, e.GENDER
, e.HIRE_DATE
FROM dbo.EMPLOYEES e
WHERE e.FIRST_NAME = 'Hercules'
AND	e.LAST_NAME LIKE 'B%'
;

--List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT
  e.EMP_NO
, e.LAST_NAME
, e.FIRST_NAME
, d.DEPT_NAME
FROM dbo.EMPLOYEES e
JOIN dbo.DEPT_EMP de
	ON e.EMP_NO=de.EMP_NO
JOIN dbo.DEPARTMENTS d
	ON de.DEPT_NO=d.DEPT_NO
WHERE d.DEPT_NAME = 'Sales'
;

--List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT
  e.EMP_NO
, e.LAST_NAME
, e.FIRST_NAME
, d.DEPT_NAME
FROM dbo.EMPLOYEES e
JOIN dbo.DEPT_EMP de
	ON e.EMP_NO=de.EMP_NO
JOIN dbo.DEPARTMENTS d
	ON de.DEPT_NO=d.DEPT_NO
WHERE d.DEPT_NAME IN ('Sales','Development')
;

--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT
e.LAST_NAME
, COUNT(e.LAST_NAME) AS COUNTOFLASTNAME
FROM dbo.EMPLOYEES e
GROUP BY e.LAST_NAME
ORDER BY COUNTOFLASTNAME Desc
;

--List employees who were hired since 1990.
SELECT
  e.LAST_NAME
, e.FIRST_NAME
, e.HIRE_DATE
FROM dbo.EMPLOYEES e
WHERE YEAR(e.HIRE_DATE) >= 1990
ORDER BY e.HIRE_DATE ASC
;

--List all employees whose first name begins with "A" in order by their last name.
SELECT
  e.LAST_NAME 
, e.FIRST_NAME
FROM dbo.EMPLOYEES e
WHERE e.FIRST_NAME LIKE 'A%'
ORDER BY e.LAST_NAME ASC
;

--List the following details of each employee: employee number, last name, first name, gender, and salary. Order the list by highest salary to lowest.
SELECT
  e.EMP_NO
, e.LAST_NAME
, e.FIRST_NAME
, e.GENDER
, s.SALARY
FROM dbo.EMPLOYEES e
JOIN dbo.SALARIES s
	ON s.EMP_NO=e.EMP_NO
ORDER BY s.SALARY DESC
;

--List the following details of all employees: department number, department name, the manager's employee number, last name, first name, and salary. Order the list first by highest salary to lowest, then by department name.
WITH CurrentDeptManager AS (
	SELECT
	DEPT_NO
	,EMP_NO
	,FROM_DATE
	,ROW_NUMBER() OVER (Partition By DEPT_NO ORDER BY FROM_DATE DESC) AS rn
	FROM dbo.DEPT_MANAGER
)
, CurrentDeptEmp AS (
	SELECT
	EMP_NO
	,DEPT_NO
	,FROM_DATE
	,ROW_NUMBER() OVER (Partition By EMP_NO ORDER BY FROM_DATE DESC) AS rn
	FROM dbo.DEPT_EMP
)
SELECT
cde.DEPT_NO
,d.DEPT_NAME
,e2.EMP_NO AS ManagerNumber
,e2.LAST_NAME + ' ' + e2.FIRST_NAME AS ManagerName
,e.EMP_NO AS EmployeeNumber
,e.LAST_NAME AS EmployeeLastName
,e.FIRST_NAME AS EmployeeFirstName
,s.SALARY
FROM dbo.EMPLOYEES e
JOIN dbo.SALARIES s
	ON e.EMP_NO=s.EMP_NO
JOIN CurrentDeptEmp cde
	ON cde.EMP_NO=e.EMP_NO
	AND cde.rn=1
JOIN dbo.DEPARTMENTS d
	ON d.DEPT_NO=cde.DEPT_NO
JOIN CurrentDeptManager cdm
	ON cdm.DEPT_NO=d.DEPT_NO
JOIN dbo.EMPLOYEES e2
	ON e2.EMP_NO=cdm.EMP_NO
	AND cdm.rn=1
ORDER BY s.SALARY DESC, d.DEPT_NAME ASC
;

--List all employees that have "Engineer" in their title along with their department number, department name, the manager's employee number, last name, first name, and salary. Order by highest salary to lowest.
WITH EngineerTitle AS (
	--Most recent title per employee, also only Engineers
	SELECT
	t.EMP_NO
	,t.TITLE
	,t.TO_DATE
	,ROW_NUMBER() OVER (PARTITION BY t.EMP_NO ORDER BY t.TO_DATE DESC) AS rn
	FROM dbo.TITLES t
	WHERE t.TITLE LIKE '%Engineer%'
)
, CurrentDeptEmp AS (
	--Most recent department assignment per employee
	SELECT
	de.EMP_NO
	,de.DEPT_NO
	,ROW_NUMBER() OVER (PARTITION BY de.EMP_NO ORDER BY de.FROM_DATE DESC) AS rn
	FROM dbo.DEPT_EMP de
)
, CurrentDeptManager AS (
	--Most recent manager per department
	SELECT
	dm.DEPT_NO
	,dm.EMP_NO
	,ROW_NUMBER() OVER (PARTITION BY dm.DEPT_NO ORDER BY dm.FROM_DATE DESC) AS rn
	FROM dbo.DEPT_MANAGER dm
)
SELECT
et.TITLE
,cde.DEPT_NO
,d.DEPT_NAME
,mgr.EMP_NO AS ManagerEmployeeNumber
,e.LAST_NAME AS EmployeeLastName
,e.FIRST_NAME AS EmployeeFirstName
,s.SALARY
FROM dbo.EMPLOYEES e	--Employee info
JOIN EngineerTitle et				--Employee titles
	ON et.EMP_NO=e.EMP_NO
	AND et.rn=1
JOIN dbo.SALARIES s		--Employee Salary info
	ON s.EMP_NO=e.EMP_NO
JOIN CurrentDeptEmp cde				--Employee Current Department
	ON cde.EMP_NO=e.EMP_NO
	AND cde.rn=1
JOIN dbo.DEPARTMENTS d	--Department Name
	ON d.DEPT_NO=cde.DEPT_NO
JOIN CurrentDeptManager cdm			--Current Department Manager
	ON cdm.DEPT_NO=d.DEPT_NO
	AND cdm.rn=1
JOIN dbo.EMPLOYEES mgr	--Manager Number
	ON mgr.EMP_NO=cdm.EMP_NO
ORDER BY s.SALARY DESC
;

--List all employees who have an annual salary higher than $65,000 along with their titles, employee numbers, full names, gender, and hire date.
WITH CurrentTitle AS (
	--Most recent title per employee
	SELECT
	t.EMP_NO
	,t.TITLE
	,t.FROM_DATE
	,ROW_NUMBER() OVER (PARTITION BY t.EMP_NO ORDER BY t.TO_DATE DESC) AS rn
	FROM dbo.TITLES t
)
, CurrentSalary AS (
	--Most recent salary per employee
	SELECT
	s.EMP_NO
	,s.SALARY
	,ROW_NUMBER() OVER (PARTITION BY s.EMP_NO ORDER BY s.TO_DATE DESC) AS rn
	FROM dbo.SALARIES s
)
SELECT
ct.TITLE
,ct.FROM_DATE
,e.EMP_NO
,e.LAST_NAME AS EmployeeLastName
,e.FIRST_NAME AS EmployeeFirstName
,e.GENDER
,e.HIRE_DATE
,cs.SALARY
FROM dbo.EMPLOYEES e
JOIN CurrentTitle ct
	ON ct.EMP_NO=e.EMP_NO
	AND ct.rn=1
JOIN CurrentSalary cs
	ON cs.EMP_NO=e.EMP_NO
	AND cs.rn=1
WHERE cs.SALARY > 65000
ORDER BY cs.SALARY DESC
;
