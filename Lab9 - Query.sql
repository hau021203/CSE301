
-- II. Creating constraint for database:
-- 1. Check constraint to value of gender in “Nam” or “Nu”.
alter table employee add check (gender='Nam' or gender='Nu');
-- 2. Check constraint to value of salary > 0.
alter table employee add check (salary > 0);
-- 3. Check constraint to value of relationship in Relative table in “Vo chong”, “Con trai”, “Con
-- gai”, “Me ruot”, “Cha ruot”.
alter table relative add check (relationship in ('Vo chong', 'Con trai', 'Con gai', 'Me ruot', 'Cha ruot'));
-- III. Writing SQL Queries.
-- 1. Look for employees with salaries above 25,000 in room 4 or employees with salaries above
-- 30,000 in room 5.
select * from employee e
inner join department d on e.department_ID = d.departmentID
where (e.salary > 25000 and d.departmentID = '4')or(e.salary > 30000 and d.departmentID = '5');
-- 2. Provide full names of employees in HCM city.
select concat(last_Name,' ',middle_Name,' ',first_Name) fullname  from employee where address like '%TPHCM%';
-- 3. Indicate the date of birth of Dinh Ba Tien staff.
select date_0f_Birth  from employee where last_Name = 'Dinh' and middle_Name = 'Ba' and first_Name = 'Tien';
-- 4. The names of the employees of Room 5 are involved in the "San pham X" project and this
-- employee is directly managed by "Nguyen Thanh Tung".
select concat(last_Name,' ',middle_Name,' ',first_Name) name from employee e  
inner join assignment a on e.employee_ID = a.employee_ID
inner join projects p on a.project_ID = p.project_ID
where p.project_Name = "San pham X" and e.manager_ID = 
(select employee_id from employee where last_Name = "Nguyen" and middle_Name="Thanh" and first_Name="Tung");
select * from employee;
select * from projects;
select * from assignment;
-- 5. Find the names of department heads of each department.
select * from employee e, department d where e.employee_ID = d.manager_ID;
-- 6. Find projectID, projectName, projectAddress, departmentID, departmentName, date0fEmployment.
select * from projects p, department d where p.department_ID = d.departmentID;
-- 7. Find the names of female employees and their relatives.
select * from employee e 
inner join relative r on e.employee_ID= r.employee_ID
where e.gender = 'Nu';
-- 8. For all projects in "Hanoi", list the project code (projectID), the code of the project lead
-- department (departmentID), the full name of the manager (lastName, middleName,
-- firstName) as well as the address (Address) and date of birth (date0fBirth) of the Employees.
select * from projects p 
inner join department d on p.department_ID = d.departmentID
inner join employee e on e.manager_ID = e.manager_ID
where p.project_Address = "HA NOI";
-- 9. For each employee, include the employee's full name and the employee's line manager.
select last_Name,middle_Name,first_Name,(select concat(last_Name,' ',middle_Name,' ',first_Name) from employee e where e.employee_ID = e1.manager_ID) manager_name 
from employee e1;
-- 10. For each employee, indicate the employee's full name and the full name of the head of the
-- department in which the employee works.
select concat(e1.last_Name,' ',e1.middle_Name,' ',e1.first_Name) employee_name,(select concat(e.last_Name,' ',e.middle_Name,' ',e.first_Name) from employee e where e.employee_ID = e1.manager_ID) manager_name 
from employee e1;
-- 11. Provide the employee's full name (lastName, middleName, firstName) and the names of
-- the projects in which the employee participated, if any.
select concat(e.last_Name,' ',e.middle_Name,' ',e.first_Name) employee_name, project_Name from projects p
inner join assignment a on  p.project_ID = a.project_ID
inner join employee e on a.employee_ID = e.employee_ID;
-- 12. For each scheme, list the scheme name (projectName) and the total number of hours
-- worked per week of all employees attending that scheme.
select * from projects p
inner join assignment a on  p.project_ID = a.project_ID
inner join employee e on a.employee_ID = e.employee_ID
group by p.project_ID;
-- 13. For each department, list the name of the department (departmentName) and the average
-- salary of the employees who work for that department.
select d.department_Name,avg(salary) total from department d
inner join employee e on d.departmentID = e.department_ID
group by d.departmentID;
-- 14. For departments with an average salary above 30,000, list the name of the department and
-- the number of employees of that department.
select d.department_Name,count(*) from department d
inner join employee e on d.departmentID = e.department_ID 
group by d.departmentID
having avg(salary) > 30000;
-- 15. Indicate the list of schemes (projectID) that has: workers with them (lastName) as 'Dinh'
-- or, whose head of department presides over the scheme with them (lastName) as 'Dinh'.
select * from projects p
inner join assignment a on  p.project_ID = a.project_ID
inner join employee e on a.employee_ID = e.employee_ID
where e.employee_ID = (select employee_ID from employee where last_Name = 'Dinh')
or e.manager_ID = (select employee_ID from employee where last_Name = 'Dinh');
-- 16. List of employees (lastName, middleName, firstName) with more than 2 relatives.
select e.employee_ID,count(*) relative from employee e
inner join relative r on e.employee_ID = r.employee_ID
group by e.employee_ID
having relative > 2;
-- 17. List of employees (lastName, middleName, firstName) without any relatives.
select e.employee_ID,count(*) relative from employee e
inner join relative r on e.employee_ID = r.employee_ID
group by e.employee_ID
having relative = 0;
-- 18. List of department heads (lastName, middleName, firstName) with at least one relative.
select concat(e.last_Name,' ',e.middle_Name,' ',e.first_Name) employee_name,count(*) relative from department d
inner join employee e on d.manager_ID = e.manager_ID
inner join relative r on e.employee_ID = r.employee_ID
group by e.employee_ID
having relative > 0;
-- 19. Find the surname (lastName) of unmarried department heads.
select * from department d
inner join employee e on d.manager_ID = e.manager_ID
inner join relative r on e.employee_ID = r.employee_ID
where e.employee_ID not in (select employee_ID from relative where relationship = 'Vo chong' );
select * from relative;
-- 20. Indicate the full name of the employee (lastName, middleName, firstName) whose salary
-- is above the average salary of the "Research" department.
select concat(e.last_Name,' ',e.middle_Name,' ',e.first_Name) employee_name from employee e where salary > (
select avg(salary) salary from department d
inner join employee e on d.departmentID = e.department_ID
where d.department_Name = 'Nghien cuu');
-- 21. Indicate the name of the department and the full name of the head of the department with
-- the largest number of employees.
select concat(e.last_Name,' ',e.middle_Name,' ',e.first_Name) head_name from employee e where employee_ID = (
select de.manager_ID from department de where de.departmentID = (
select d.departmentID from department d
inner join employee e on d.departmentID = e.department_ID
group by d.departmentID
order by count(*) desc limit 1));
-- 22. Find the full names (lastName, middleName, firstName) and addresses (Address) of
-- employees who work on a project in 'HCMC' but the department they belong to is not
-- located in 'HCMC'.
select * from projects;
select * from departmentaddress;
select * from assignment;
select * from employee where address not like '%TPHCM%';
-- 23. Find the names and addresses of employees who work on a scheme in a city but the
-- department to which they belong is not located in that city.


-- 24. Create procedure List employee information by department with input data
-- departmentName.
Delimiter $$
CREATE PROCEDURE employee_information (IN in_department_name varchar(30))
Begin
select * from department where department_Name = in_department_name;
End$$
Delimiter;
call employee_information('O20006');
select * from departme
-- 25. Create a procedure to Search for projects that an employee participates in based on the
-- employee's last name (lastName).
-- 26. Create a function to calculate the average salary of a department with input data
-- departmentID.
Delimiter $$
CREATE PROCEDURE update_delivery_status (IN in_order_number varchar(30))
Begin
update salesorder set delivery_status = 'On Way' where order_number = in_order_number;
End$$
Delimiter ;
call update_delivery_status('O20006');
-- 27. Create a function to Check if an employee is involved in a particular project input data is
-- employeeID, projectID.