--1. List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT
	EMP."EMP_NO",
	EMP."LAST_NAME",
	EMP."FIRST_NAME",
	EMP."GENDER",
	SAL."SALARY"
-- 	grabbing columns from respective tables
FROM "EMPLOYEES" as EMP 
-- bring everything from the employees table and add on from the salaries table.
LEFT JOIN "SALARIES" as SAL
	on (EMP."EMP_NO" = SAL."EMP_NO");
-- 	match primary key on "employees" table to foreign key in "salaries" table
	

--2. List employees who were hired in 1986.
SELECT
	EMP."EMP_NO", 
	EMP."LAST_NAME", 
	EMP."FIRST_NAME", 
	EMP."GENDER",
	EMP."HIRE_DATE",
	SAL."SALARY"
FROM "EMPLOYEES" as EMP
LEFT JOIN "SALARIES" as SAL
	on (EMP."EMP_NO" = SAL."EMP_NO")
WHERE (EMP."HIRE_DATE" BETWEEN DATE('1986-01-01') AND DATE('1986-12-31'))
ORDER BY EMP."HIRE_DATE" ASC;


--3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
SELECT
	DM."DEPT_NO",
	DP."DEPT_NAME",
	EMP."EMP_NO", 
	EMP."LAST_NAME", 
	EMP."FIRST_NAME", 
	EMP."GENDER",
	DM."FROM_DATE",
	DM."TO_DATE"
FROM "EMPLOYEES" as EMP
JOIN "DEPT_MANAGER" as DM
	on (EMP."EMP_NO" = DM."EMP_NO")
JOIN "DEPARTMENTS" AS DP
	ON (DM."DEPT_NO" = DP."DEPT_NO");
	

--4. List the department of each employee with the following information: employee number, last name, first name, and department name.

select
	EMP."EMP_NO", 
	EMP."LAST_NAME", 
	EMP."FIRST_NAME",
	DP."DEPT_NAME"
from "EMPLOYEES" as EMP
left join "DEPT_EMP" as DE
	on (EMP."EMP_NO" = DE."EMP_NO")
join "DEPARTMENTS" as DP
	on (DE."DEPT_NO" = DP."DEPT_NO");
	
	
--5. List all employees whose first name is "Hercules" and last names begin with "B."
select
	"EMP_NO",
	"LAST_NAME",
	"FIRST_NAME"
from "EMPLOYEES"
where (upper("FIRST_NAME") = 'HERCULES' and "LAST_NAME" like 'B%');


--6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
select
	EMP."EMP_NO",
	EMP."LAST_NAME",
	EMP."FIRST_NAME",
	DP."DEPT_NAME"
from "EMPLOYEES" as EMP
left join "DEPT_EMP" as DE
	on (EMP."EMP_NO" = DE."EMP_NO")
join "DEPARTMENTS" as DP
	on (DE."DEPT_NO" = DP."DEPT_NO")
where (upper(DP."DEPT_NAME") = 'SALES');


--7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
select
	EMP."EMP_NO",
	EMP."LAST_NAME",
	EMP."FIRST_NAME",
	DP."DEPT_NAME"
from "EMPLOYEES" as EMP
left join "DEPT_EMP" as DE
	on (EMP."EMP_NO" = DE."EMP_NO")
join "DEPARTMENTS" as DP
	on (DE."DEPT_NO" = DP."DEPT_NO")
where (upper(DP."DEPT_NAME") = 'SALES' or upper(DP."DEPT_NAME") = 'DEVELOPMENT');


--8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
select 
	"LAST_NAME",
	count("LAST_NAME") as "LAST_NAME_FREQUENCY"
from "EMPLOYEES"
group by "LAST_NAME"
order by "LAST_NAME_FREQUENCY" desc;

-- 9. List employees who were hired since 1990.
SELECT * FROM "EMPLOYEES" 
WHERE ("HIRE_DATE" > '1990-1-1')
ORDER BY "HIRE_DATE" ASC ;

-- 10. List all employees whose first name begins with "A". Order by their last name.
select
	"EMP_NO",
	"LAST_NAME",
	"FIRST_NAME"
from "EMPLOYEES"
where ("FIRST_NAME" like 'A%')
ORDER BY "LAST_NAME" ASC ;

-- 11. List the following details of each employee: employee number, last name, first name, gender, and salary. Order the list by highest salary to lowest.
SELECT
	EMP."EMP_NO",
	EMP."LAST_NAME",
	EMP."FIRST_NAME",
	EMP."GENDER",
	SAL."SALARY"
FROM "EMPLOYEES" as EMP
LEFT JOIN "SALARIES" as SAL
	ON (EMP."EMP_NO" = SAL."EMP_NO")
ORDER BY "SALARY" DESC;

-- 12. List the following details of all employees: department number, department name, the manager's employee number, the manager's last name, the employee's first and last name, and the employee's salary. 
-- Order the list first by highest salary to lowest, then order the list by department name.
SELECT
	DEPT."DEPT_NO",
	DEPT."DEPT_NAME",
	DM."EMP_NO" AS MANAGER_NUM,
	EMP_M."LAST_NAME" AS MAN_LAST_NAME,
	EMP."EMP_NO",
	EMP."LAST_NAME",
	EMP."FIRST_NAME",
	SAL."SALARY"
FROM "EMPLOYEES" AS EMP
LEFT JOIN "SALARIES" AS SAL
	ON (EMP."EMP_NO" = SAL."EMP_NO")
LEFT JOIN "DEPT_EMP" AS DEPT_EMP
	ON (EMP."EMP_NO" = DEPT_EMP."EMP_NO")
LEFT JOIN "DEPARTMENTS" AS DEPT
	ON (DEPT_EMP."DEPT_NO" = DEPT."DEPT_NO")
LEFT JOIN "DEPT_MANAGER" AS DM
	ON (DEPT."DEPT_NO" = DM."DEPT_NO")
LEFT JOIN "EMPLOYEES" AS EMP_M
	ON (DM."EMP_NO" = EMP_M."EMP_NO")
WHERE (DM."TO_DATE" = '9999-01-01')
ORDER BY "SALARY" DESC, "DEPT_NAME" ASC;

-- 13. List all employees that have "Engineer" in their title along with their: department number, department name, last name, first name, and salary. Order the list by highest salary to lowest.
SELECT
	TITLES."TITLES",
	DEPT."DEPT_NO",
	DEPT."DEPT_NAME",
	EMP."LAST_NAME",
	EMP."FIRST_NAME",
	SAL."SALARY"
FROM "EMPLOYEES" AS EMP
LEFT JOIN "SALARIES" AS SAL ON (EMP."EMP_NO" = SAL."EMP_NO")
LEFT JOIN "DEPT_EMP" AS DEPT_EMP ON (EMP."EMP_NO" = DEPT_EMP."EMP_NO")
LEFT JOIN "TITLES" AS TITLES ON (EMP."EMP_NO" = TITLES."EMP_NO")
LEFT JOIN "DEPARTMENTS" AS DEPT ON (DEPT_EMP."DEPT_NO" = DEPT."DEPT_NO")
LEFT JOIN "DEPT_MANAGER" AS DM ON (DEPT."DEPT_NO" = DM."DEPT_NO")
LEFT JOIN "EMPLOYEES" AS EMP_M ON (DM."EMP_NO" = EMP_M."EMP_NO")
WHERE (TITLES."TITLES" LIKE '%Engineer%')
AND (TITLES."TO_DATE" > current_date)
AND (DM."TO_DATE" > current_date)
ORDER BY "SALARY" DESC;

-- 14. List all employees who have an annual salary higher than $65,000 and their titles, employee numbers, full names, gender, and hire date.
SELECT
	TITLES."TITLES",
	EMP."EMP_NO", 
	EMP."LAST_NAME", 
	EMP."FIRST_NAME", 
	EMP."GENDER",
	EMP."HIRE_DATE",
	SAL."SALARY"
FROM "EMPLOYEES" as EMP
LEFT JOIN "SALARIES" as SAL
	on (EMP."EMP_NO" = SAL."EMP_NO")
LEFT JOIN "TITLES" AS TITLES
	ON (EMP."EMP_NO" = TITLES."EMP_NO")
WHERE (SAL."SALARY" > (65000))
AND TITLES."TO_DATE" > current_date
ORDER BY EMP."HIRE_DATE" ASC;
