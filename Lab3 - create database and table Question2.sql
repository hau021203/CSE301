create table employee(
	employee_ID varchar(3),
    last_Name varchar(20) not null,
    middle_Name varchar(20),
    first_Name varchar(20) not null,
    date_0f_Birth date,
    gender varchar(5) not null,
    salary bigint not null,
    address varchar(100) not null,
    manager_ID varchar(3),
    department_ID int,
    primary key(employee_ID)
);
create table department(
	departmentID int,
    department_Name varchar(10) not null,
    manager_ID varchar(3),	
    date0fEmployment date not null,
    primary key(departmentID)
);
create table DEPARTMENTADDRESS (
	department_ID int ,
    address varchar(30),
    primary key(department_ID,address)
);
create table PROJECTS(
	project_ID int ,
    project_Name varchar(30) not null,
    project_Address varchar(100) not null,
    department_ID int,
    primary key(project_ID)
);
create table ASSIGNMENT(
	employee_ID varchar(3),
    project_ID int,
    working_Hour float not null,
    primary key (employee_ID,project_ID)
);
create table RELATIVE(
	employee_ID varchar(3) ,
    relative_Name varchar(50),
    gender varchar(5) not null,
    date_0f_Birth date,
    relationship varchar(30) not null,
    primary key(employee_ID,relative_Name)
);
