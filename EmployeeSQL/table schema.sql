--Create tables and import data--
create table "EMPLOYEES" (
    "EMP_NO" INTEGER not null,
    "BIRTH_DATE" DATE not null,
    "FIRST_NAME" VARCHAR(100) not null,
    "LAST_NAME" VARCHAR(100) not null,
    "GENDER" VARCHAR(1) not null,
    "HIRE_DATE" DATE not null,
    CONSTRAINT "pk_EMPLOYEES" PRIMARY KEY (
        "EMP_NO"
     )
);

create table "TITLES" (
    "EMP_NO" INTEGER not null,
    "TITLES" VARCHAR(50) not null,
    "FROM_DATE" DATE not null,
    "TO_DATE" DATE not null
);

create table "SALARIES" (
    "EMP_NO" INTEGER not null,
    "SALARY" INTEGER not null,
    "FROM_DATE" DATE not null,
    "TO_DATE" DATE not null
);

create table "DEPARTMENTS" (
    "DEPT_NO" VARCHAR(4) not null,
    "DEPT_NAME" VARCHAR(30) not null,
    CONSTRAINT "pk_DEPARTMENTS" PRIMARY KEY (
        "DEPT_NO"
     )
);

create table "DEPT_MANAGER" (
    "DEPT_NO" VARCHAR(4) not null,
    "EMP_NO" INTEGER not null,
    "FROM_DATE" DATE not null,
    "TO_DATE" DATE not null
);

create table "DEPT_EMP" (
    "EMP_NO" INTEGER not null,
    "DEPT_NO" VARCHAR(4) not null,
    "FROM_DATE" DATE not null,
    "TO_DATE" DATE not null
);
