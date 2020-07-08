# SQL - Employee Database: A Mystery in Two Parts


## Background

It is a beautiful spring day, and it is two weeks since you have been hired as a new data engineer at Pewlett Hackard. Your first major task is a research project on employees of the corporation from the 1980s and 1990s. All that remain of the database of employees from that period are six CSV files.

You will perform:

1. Data Modeling

2. Data Engineering

3. Data Analysis


#### Data Modeling

Inspect the CSVs and sketch out an ERD of the tables.
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/QuickDBD-ERD.png">


#### Data Engineering

* Use the information you have to create a table schema for each of the six CSV files. Remember to specify data types, primary keys, foreign keys, and other constraints.

* Import each CSV file into the corresponding SQL table.
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/table_schema_code.png">


#### Data Analysis

Once you have a complete database, do the following:

1. List the following details of each employee: employee number, last name, first name, gender, and salary.
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query1.png">
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query1_results.png">

2. List employees who were hired in 1986.
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query2.png">
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query2_results.png">

3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query3.png">
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query3_results.png">

4. List the department of each employee with the following information: employee number, last name, first name, and department name.
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query4.png">
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query4_results.png">

5. List all employees whose first name is "Hercules" and last names begin with "B."
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query5.png">
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query5_results.png">

6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query6.png">
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query6_results.png">

7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query7.png">
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query7_results.png">

8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query8.png">
<img width=“500” alt=“” src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/query_results/query8_results.png">

