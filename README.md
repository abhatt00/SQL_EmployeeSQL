# Employee SQL Database: A Mystery in Two Parts

## Overview

This project is a full rebuild and significant expansion of an employee database originally completed in 2019 as part of a data analytics bootcamp at UC Irvine. The original project was built in PostgreSQL. This version migrates the database to **Microsoft SQL Server 2022**, applies professional database design and administration practices, extends the original analysis queries with T-SQL stored procedures and views, and connects the final database to **Tableau** for dashboard reporting.

The dataset represents fictional employee records from **Pewlett Hackard**, a company whose entire employee database from the 1980s and 1990s survived only as six CSV files. The project reconstructs that database from the ground up.

This project is designed to demonstrate skills across the full data lifecycle: database design, ETL, T-SQL querying, database administration, cloud migration, and business intelligence reporting.

---

## Tech Stack

| Tool | Purpose |
|---|---|
| Microsoft SQL Server 2022 | Primary database engine |
| SQL Server Management Studio (SSMS) 21.3.7 | Database management and query execution |
| SQL Server BULK INSERT | CSV import pipeline (ETL) |
| Amazon RDS for SQL Server | Cloud-hosted database environment |
| Tableau Desktop | Dashboard and visualization development |
| Tableau Public | Dashboard publishing |
| GitHub | Version control and portfolio documentation |

---

## Architecture

<img width=“500” alt='ERD' src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/QuickDBD-ERD.png">

The database consists of six tables with the following relationships:

- **EMPLOYEES** is the central table. Every other table references it via `EMP_NO`.
- **DEPARTMENTS** is the other parent table. Junction tables reference it via `DEPT_NO`.
- **TITLES**, **SALARIES**, and **DEPT_EMP** are child tables of EMPLOYEES.
- **DEPT_MANAGER** is a child of both EMPLOYEES and DEPARTMENTS.
- **DEPT_EMP** and **DEPT_MANAGER** are junction tables modeling many-to-many relationships and carry composite primary keys.

---

## Dataset

Six CSV files form the source data for this project:

| File | Description |
|---|---|
| `employees.csv` | Core employee records including birth date, name, gender, and hire date |
| `departments.csv` | Department numbers and names |
| `titles.csv` | Employee title history with effective date ranges |
| `salaries.csv` | Employee salary history with effective date ranges |
| `dept_emp.csv` | Employee-to-department assignments with date ranges |
| `dept_manager.csv` | Department manager assignments with date ranges |

---

## Project Phases

### Phase 1 — Database Design and ETL - Complete

**What was built:**

The EmployeeSQL database was created in Microsoft SQL Server 2022 with all six tables, full constraint implementation, and non-clustered indexes on all foreign key columns.

**Database design decisions:**

- **Primary keys** were defined on `EMPLOYEES` (`EMP_NO`) and `DEPARTMENTS` (`DEPT_NO`), the two parent tables that all other tables reference.
- **Composite primary keys** were applied to `DEPT_EMP` (`EMP_NO`, `DEPT_NO`) and `DEPT_MANAGER` (`DEPT_NO`, `EMP_NO`). These are junction tables modeling many-to-many relationships where neither column alone is unique, only the combination is. A composite PK enforces that uniqueness correctly.
- **Foreign key constraints** were declared on all referencing columns across `TITLES`, `SALARIES`, `DEPT_EMP`, and `DEPT_MANAGER`. This enforces referential integrity at the database engine level, preventing orphaned records from entering the database during the CSV import process.
- **CHECK constraint** was added to the `GENDER` column in `EMPLOYEES`, restricting values to `'M'` or `'F'` to prevent invalid data entry.
- **Non-clustered indexes** were created on all foreign key columns (`EMP_NO` in TITLES and SALARIES, `EMP_NO` in DEPT_MANAGER, `DEPT_NO` in DEPT_EMP). SQL Server does not automatically index foreign key columns. Without these indexes, every JOIN operation in the analysis queries would perform a full table scan. These indexes make JOIN performance efficient from the start.
- Table creation order was intentional: `EMPLOYEES` and `DEPARTMENTS` are created before any table that references them via foreign key. This same load order is maintained during the CSV import phase.

**Schema verification queries:**

After running the schema script, the following verification queries were executed to confirm all objects were created correctly:

```sql
-- Confirm all six tables exist
SELECT TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME;

-- Confirm all constraints exist
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

-- Confirm all indexes exist
SELECT
    t.name      AS TABLE_NAME,
    i.name      AS INDEX_NAME,
    i.type_desc AS INDEX_TYPE
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
WHERE t.is_ms_shipped = 0
  AND i.name IS NOT NULL
ORDER BY t.name, i.name;
```

**Verification results:**

- 6 tables confirmed: DEPARTMENTS, DEPT_EMP, DEPT_MANAGER, EMPLOYEES, SALARIES, TITLES - all type BASE TABLE
- 11 constraints confirmed: 4 PRIMARY KEYs, 6 FOREIGN KEYs, 1 CHECK constraint
- 4 non-clustered indexes confirmed across TITLES, SALARIES, DEPT_MANAGER, DEPT_EMP

<img width=“500” alt='Table Creation Schema' src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/docs/screenshots/table_schema_code.png">
<img width=“500” alt='Schema Verification' src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/docs/screenshots/2026_verify_schema_results.png">

**Files:**
- `sql/create table schema_2026.sql` — Full DDL script: database creation, table definitions, constraints, and indexes
- `sql/verify_schema.sql` — Schema verification queries

---

### Phase 2 — Data Import and Analysis Queries - Complete

**What will be built:**

- T-SQL BULK INSERT script to load all six CSV files in correct dependency order
- Rebuilt original analysis queries in T-SQL
- Extended analysis queries beyond the original bootcamp scope
- Stored procedures with parameters for reusable query logic
- Views that simplify complex joins for downstream Tableau reporting

**Import method:** T-SQL `BULK INSERT` statements executed directly in SSMS.
CSVs were preprocessed to ensure dates are in `YYYY-MM-DD` format before import.
`FIELDQUOTE = '"'` was used to strip double quotes wrapping all field values in
the source CSV files. `CODEPAGE = 'RAW'` handled character encoding cleanly.
Tables are loaded in parent-first dependency order to satisfy FK constraints.

**Data quality fixes applied during import:**
- Staging tables used for all six files to allow data transformation before
  inserting into typed final tables
- `LTRIM(RTRIM())` applied to all text fields to strip leading and trailing spaces
- `REPLACE(column, CHAR(13), '')` and `REPLACE(column, CHAR(10), '')` applied
  to the last column of each file to strip hidden Windows line ending characters
  that were causing date conversion failures
- Safety `DROP` checks added for all staging tables to handle interrupted runs

**Original analysis questions to be answered:**

1. List the following details of each employee: employee number, last name, first name, gender, and salary.
2. List employees who were hired in 1986.
3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
4. List the department of each employee with the following information: employee number, last name, first name, and department name.
5. List all employees whose first name is "Hercules" and last names begin with "B."
6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
9. List employees who were hired since 1990.
10. List all employees whose first name begins with "A" in order by their last name.
11. List the following details of each employee: employee number, last name, first name, gender, and salary. Order the list by highest salary to lowest.
12. List the following details of all employees: department number, department name, the manager's employee number, last name, first name, and salary. Order the list first by highest salary to lowest, then by department name.
13. List all employees that have "Engineer" in their title along with their department number, department name, the manager's employee number, last name, first name, and salary. Order by highest salary to lowest.
14. List all employees who have an annual salary higher than $65,000 along with their titles, employee numbers, full names, gender, and hire date.

**Key T-SQL concepts demonstrated:**
- Multi-table JOINs across six related tables
- INNER JOIN vs LEFT JOIN applied correctly based on query intent
- `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)` window function
  for isolating most recent records per employee
- CTEs for readable, modular query logic
- `GROUP BY` with `COUNT` for frequency analysis
- `LIKE` with wildcard patterns for text filtering
- String concatenation for formatted name output
- Sentinel date value filtering (`TO_DATE = '9999-01-01'`)

<img width=“300” alt='BULK INSERT Success' src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/docs/screenshots/verify bulk table INSERT results.png">
<img width=“300” alt='Query 3 Results' src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/docs/screenshots/query 3 results.png">
<img width=“300” alt='Query 8 Results' src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/docs/screenshots/query 8 results.png">
<img width=“300” alt='Query 12 Results' src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/docs/screenshots/query 12 results.png">
<img width=“300” alt='Query 14 Results' src="https://github.com/abhatt00/SQL_EmployeeSQL/blob/master/docs/screenshots/query 14 results.png">

---

### Phase 3 — DBA Infrastructure 📋 Planned

**What will be built:**

- Automated backup strategy using SQL Server Agent (full, differential, and transaction log backups)
- Documented restore test with step-by-step procedure
- Dynamic Management View (DMV) monitoring scripts for server health
- Query optimization using execution plan analysis
- Database maintenance plan for index and statistics management
- PowerShell script that checks SQL Server Agent job status and outputs a health report

---

### Phase 4 — AWS RDS Migration 📋 Planned

**What will be built:**

- Migration of the EmployeeSQL database to Amazon RDS for SQL Server
- IAM role configuration, security group setup, and subnet group configuration
- Automated snapshot configuration
- Documented RPO (Recovery Point Objective) and RTO (Recovery Time Objective) targets for the environment

---

### Phase 5 — Tableau Dashboards 📋 Planned

**What will be built:**

- Tableau Desktop connected to SQL Server views and stored procedures
- Minimum three dashboards:
  - Employee Overview
  - Salary and Compensation Analysis
  - Department Hierarchy
- Published to Tableau Public

> *Dashboard screenshots and Tableau Public links to be added upon completion.*

---

## How to Run This Project

To reproduce this database locally, follow these steps in order:

1. **Prerequisites**
   - Microsoft SQL Server 2022 (Developer or Express edition)
   - SQL Server Management Studio (SSMS)

2. **Clone this repository**
   ```bash
   git clone https://github.com/abhatt00/SQL_EmployeeSQL.git
   ```

3. **Run the schema script**
   - Open SSMS and connect to your SQL Server instance
   - Open `sql/create table schema_2026.sql`
   - Execute the full script — this will drop and recreate the EmployeeSQL database and all tables

4. **Verify the schema**
   - Open and run `sql/verify_schema.sql`
   - Confirm 6 tables, 11 constraints, and 4 indexes are present

5. **Import the CSV data** *(Phase 2 — instructions to be added)*

6. **Run analysis queries** *(Phase 2 — instructions to be added)*

---

## Repository Structure

```
EmployeeSQL/
├── README.md
├── data/
│   ├── departments.csv
│   ├── dept_emp.csv
│   ├── dept_manager.csv
│   ├── employees.csv
│   ├── salaries.csv
│   └── titles.csv
├── SQL_EmployeeSQL/
│   ├── create table schema_2026.sql
│   ├── verify_schema.sql
│   ├── analysis_queries.sql          (Phase 2)
│   └── views_and_procedures.sql      (Phase 2)
├── tableau/                          (Phase 5)
└── docs/
    └── screenshots/
```

---

## Author

**Abhishek Bhatt**

Originally completed: 2019 — UC Irvine Data Analytics Bootcamp (PostgreSQL)

Rebuilt and expanded: 2026 — Microsoft SQL Server 2022

[LinkedIn](https://www.linkedin.com/in/asbhatt12/) | [GitHub](https://github.com/abhatt00)
